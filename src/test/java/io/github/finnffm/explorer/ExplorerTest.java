package io.github.finnffm.explorer;

import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.*;
import java.net.http.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;
import org.junit.jupiter.api.*;

class ExplorerTest {
  @Test
  void rejectsUnsupportedSchemaWithoutChangingIt() throws Exception {
    try (var db = DriverManager.getConnection("jdbc:sqlite:" + demo);
        var s = db.createStatement()) {
      s.execute("PRAGMA user_version=99");
    }
    assertThrows(IllegalArgumentException.class, () -> new Corpus(demo));
    try (var db = DriverManager.getConnection("jdbc:sqlite:" + demo);
        var s = db.createStatement();
        var r = s.executeQuery("PRAGMA user_version")) {
      assertTrue(r.next());
      assertEquals(99, r.getInt(1));
    }
  }

  Path demo;
  Corpus corpus;

  @BeforeEach
  void setup() throws Exception {
    demo = Main.createDemo();
    corpus = new Corpus(demo);
  }

  @AfterEach
  void cleanup() throws Exception {
    Files.deleteIfExists(demo);
  }

  Corpus.Filter filter(String... pairs) {
    var p = new HashMap<String, String>();
    for (int i = 0; i < pairs.length; i += 2) p.put(pairs[i], pairs[i + 1]);
    return Corpus.Filter.from(p);
  }

  @Test
  void paginatesWithoutDuplicates() throws Exception {
    var first = corpus.search(filter());
    var second = corpus.search(filter("page", "2"));
    assertEquals(24L, first.get("total"));
    var a = (List<?>) first.get("items");
    var b = (List<?>) second.get("items");
    assertEquals(20, a.size());
    assertEquals(4, b.size());
    Set<Object> ids = new HashSet<>();
    for (var row : a) assertTrue(ids.add(((Map<?, ?>) row).get("id")));
    for (var row : b) assertTrue(ids.add(((Map<?, ?>) row).get("id")));
  }

  @Test
  void searchesFiltersAndCountsConsistently() throws Exception {
    var f = filter("q", "Energiewende", "from", "2025-03-01", "to", "2025-03-31");
    var result = corpus.search(f);
    assertEquals(2L, result.get("total"));
    var totals = (Map<?, ?>) corpus.stats(f).get("totals");
    assertEquals(2, ((Number) totals.get("speeches")).intValue());
    assertEquals(0L, corpus.search(filter("faction", "' OR 1=1 --")).get("total"));
    assertEquals(0L, corpus.search(filter("q", "nonexistenttoken")).get("total"));
    assertNotNull(corpus.speech("DEMO-1-1"));
    assertNull(corpus.speech("not-found"));
  }

  @Test
  void validatesQueriesAndSchema() throws Exception {
    assertThrows(Exception.class, () -> filter("from", "2025-02-31"));
    assertThrows(Exception.class, () -> filter("page", "-1"));
    assertThrows(Exception.class, () -> filter("from", "2025-04-01", "to", "2025-03-01"));
    assertThrows(Exception.class, () -> filter("sort", "DROP TABLE"));
    assertThrows(Exception.class, () -> corpus.search(filter("q", "***")));
    assertThrows(Exception.class, () -> new Corpus(demo.resolveSibling("missing-corpus.db")));
  }

  @Test
  void servesApiAndRejectsInvalidRequests() throws Exception {
    var server = Main.start(corpus, 0, true);
    String base = "http://127.0.0.1:" + server.getAddress().getPort();
    try {
      var client = HttpClient.newHttpClient();
      var ok =
          client.send(
              HttpRequest.newBuilder(URI.create(base + "/api/speeches?q=Bildung")).build(),
              HttpResponse.BodyHandlers.ofString());
      assertEquals(200, ok.statusCode());
      assertTrue(new ObjectMapper().readTree(ok.body()).get("total").asInt() > 0);
      for (String route :
          List.of("/api/speeches?page=0", "/api/stats?from=wrong", "/api/speeches?q=%22"))
        assertEquals(
            400,
            client
                .send(
                    HttpRequest.newBuilder(URI.create(base + route)).build(),
                    HttpResponse.BodyHandlers.ofString())
                .statusCode());
      assertEquals(
          404,
          client
              .send(
                  HttpRequest.newBuilder(URI.create(base + "/api/speech?id=missing")).build(),
                  HttpResponse.BodyHandlers.ofString())
              .statusCode());
      assertEquals(
          405,
          client
              .send(
                  HttpRequest.newBuilder(URI.create(base + "/api/speeches"))
                      .POST(HttpRequest.BodyPublishers.noBody())
                      .build(),
                  HttpResponse.BodyHandlers.ofString())
              .statusCode());
      var html =
          client.send(
              HttpRequest.newBuilder(URI.create(base + "/")).build(),
              HttpResponse.BodyHandlers.ofString());
      assertEquals(200, html.statusCode());
      assertTrue(html.body().contains("Parliament Explorer"));
      assertTrue(
          html.headers()
              .firstValue("Content-Security-Policy")
              .orElse("")
              .contains("frame-ancestors 'none'"));
    } finally {
      server.stop(0);
    }
  }
}
