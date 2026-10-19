package io.github.finnffm.explorer;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.nio.file.*;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import org.sqlite.SQLiteConfig;

/** Read-only queries against the parliament-corpus v1 format. */
public final class Corpus {
  private final Path path;
  private static final ObjectMapper JSON = new ObjectMapper();

  public Corpus(Path path) throws Exception {
    this.path = path.toAbsolutePath();
    if (!Files.isRegularFile(path))
      throw new IllegalArgumentException("Corpus does not exist: " + path);
    try (var db = open();
        var s = db.createStatement();
        var r = s.executeQuery("PRAGMA user_version")) {
      if (!r.next() || r.getInt(1) != 1)
        throw new IllegalArgumentException("Expected parliament-corpus schema version 1");
    }
  }

  private Connection open() throws SQLException {
    var config = new SQLiteConfig();
    config.setReadOnly(true);
    config.setBusyTimeout(5000);
    return DriverManager.getConnection("jdbc:sqlite:" + path, config.toProperties());
  }

  public record Filter(String q, String faction, String from, String to, int page, String sort) {
    public static Filter from(Map<String, String> p) {
      String q = p.getOrDefault("q", "").strip(), faction = p.getOrDefault("faction", "");
      String from = p.getOrDefault("from", ""), to = p.getOrDefault("to", "");
      if (q.length() > 200 || faction.length() > 200)
        throw new IllegalArgumentException("Search text is too long");
      if (!from.isEmpty()) LocalDate.parse(from);
      if (!to.isEmpty()) LocalDate.parse(to);
      if (!from.isEmpty() && !to.isEmpty() && from.compareTo(to) > 0)
        throw new IllegalArgumentException("Start date must not follow end date");
      int page = Integer.parseInt(p.getOrDefault("page", "1"));
      if (page < 1 || page > 100000)
        throw new IllegalArgumentException("Page must be between 1 and 100000");
      String sort = p.getOrDefault("sort", "newest");
      if (!Set.of("newest", "oldest", "longest").contains(sort))
        throw new IllegalArgumentException("Unknown sort order");
      return new Filter(q, faction, from, to, page, sort);
    }
  }

  private record Clause(String sql, List<Object> params) {}

  private Clause clause(Filter f) {
    StringBuilder sql =
        new StringBuilder(" FROM speeches s JOIN sessions t ON t.id=s.session_id WHERE 1=1");
    List<Object> params = new ArrayList<>();
    if (!f.q.isBlank()) {
      var matcher = java.util.regex.Pattern.compile("[\\p{L}\\p{N}]+").matcher(f.q);
      List<String> words = new ArrayList<>();
      while (matcher.find()) words.add("\"" + matcher.group() + "\"");
      if (words.isEmpty())
        throw new IllegalArgumentException("Search must contain a letter or number");
      sql.append(" AND s.id IN (SELECT id FROM speech_search WHERE speech_search MATCH ?)");
      params.add(String.join(" AND ", words));
    }
    if (!f.faction.isEmpty()) {
      sql.append(" AND s.faction=?");
      params.add(f.faction);
    }
    if (!f.from.isEmpty()) {
      sql.append(" AND t.date>=?");
      params.add(f.from);
    }
    if (!f.to.isEmpty()) {
      sql.append(" AND t.date<=?");
      params.add(f.to);
    }
    return new Clause(sql.toString(), params);
  }

  public Map<String, Object> search(Filter f) throws Exception {
    Clause c = clause(f);
    try (var db = open()) {
      long total =
          ((Number) query(db, "SELECT COUNT(*) AS n" + c.sql, c.params).getFirst().get("n"))
              .longValue();
      String sort =
          switch (f.sort) {
            case "oldest" -> "t.date ASC";
            case "longest" -> "s.word_count DESC";
            default -> "t.date DESC";
          };
      var params = new ArrayList<>(c.params);
      params.add(20);
      params.add((f.page - 1) * 20);
      var items =
          query(
              db,
              "SELECT s.id,s.speaker,s.faction,s.agenda,s.word_count,t.date,t.term,t.number,substr(s.text,1,260) AS excerpt"
                  + c.sql
                  + " ORDER BY "
                  + sort
                  + ",t.id,s.position LIMIT ? OFFSET ?",
              params);
      return Map.of("items", items, "total", total, "page", f.page, "pageSize", 20);
    }
  }

  public Map<String, Object> stats(Filter f) throws Exception {
    Clause c = clause(f);
    try (var db = open()) {
      var totals =
          query(
                  db,
                  "SELECT COUNT(*) AS speeches,COUNT(DISTINCT s.session_id) AS sessions,COUNT(DISTINCT s.speaker_id) AS speakers,COALESCE(SUM(s.word_count),0) AS words"
                      + c.sql,
                  c.params)
              .getFirst();
      var factions =
          query(
              db,
              "SELECT s.faction,COUNT(*) AS speeches,COALESCE(SUM(s.word_count),0) AS words"
                  + c.sql
                  + " GROUP BY s.faction ORDER BY speeches DESC,s.faction",
              c.params);
      var timeline =
          query(
              db,
              "SELECT substr(t.date,1,7) AS month,COUNT(*) AS speeches"
                  + c.sql
                  + " GROUP BY month ORDER BY month",
              c.params);
      return Map.of("totals", totals, "factions", factions, "timeline", timeline);
    }
  }

  public List<Map<String, Object>> factions() throws SQLException {
    try (var db = open()) {
      return query(db, "SELECT DISTINCT faction FROM speeches ORDER BY faction", List.of());
    }
  }

  public Map<String, Object> speech(String id) throws Exception {
    try (var db = open()) {
      var rows =
          query(
              db,
              "SELECT s.*,t.date,t.term,t.number,t.source FROM speeches s JOIN sessions t ON t.id=s.session_id WHERE s.id=?",
              List.of(id));
      if (rows.isEmpty()) return null;
      var row = rows.getFirst();
      row.put("comments", JSON.readTree((String) row.get("comments")));
      return row;
    }
  }

  private static List<Map<String, Object>> query(Connection db, String sql, List<Object> params)
      throws SQLException {
    try (var p = db.prepareStatement(sql)) {
      for (int i = 0; i < params.size(); i++) p.setObject(i + 1, params.get(i));
      try (var r = p.executeQuery()) {
        List<Map<String, Object>> rows = new ArrayList<>();
        while (r.next()) {
          Map<String, Object> row = new LinkedHashMap<>();
          for (int i = 1; i <= r.getMetaData().getColumnCount(); i++)
            row.put(r.getMetaData().getColumnLabel(i), r.getObject(i));
          rows.add(row);
        }
        return rows;
      }
    }
  }
}
