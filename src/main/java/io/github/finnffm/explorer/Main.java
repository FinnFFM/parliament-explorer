package io.github.finnffm.explorer;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.sql.DriverManager;
import java.util.*;
import java.util.concurrent.Executors;

/** Local, read-only web explorer. No remote services or credentials required. */
public final class Main {
  private static final ObjectMapper JSON = new ObjectMapper();

  public static void main(String[] args) {
    try {
      if (Arrays.asList(args).contains("--help")) {
        System.out.println(
            "parliament-explorer [--demo | --db corpus.db] [--port 7070]\nBinds to 127.0.0.1. Defaults to synthetic demo data.");
        return;
      }
      Path path = null;
      int port = 7070;
      boolean demo = false;
      for (int i = 0; i < args.length; i++)
        switch (args[i]) {
          case "--demo" -> demo = true;
          case "--db" -> {
            if (++i >= args.length) throw new IllegalArgumentException("Missing database path");
            path = Path.of(args[i]);
          }
          case "--port" -> {
            if (++i >= args.length) throw new IllegalArgumentException("Missing port");
            port = Integer.parseInt(args[i]);
          }
          default -> throw new IllegalArgumentException("Unknown option: " + args[i]);
        }
      if (demo && path != null) throw new IllegalArgumentException("Choose --demo or --db");
      if (port < 1 || port > 65535)
        throw new IllegalArgumentException("Port must be between 1 and 65535");
      demo = path == null;
      if (demo) path = createDemo();
      var app = start(new Corpus(path), port, demo);
      Runtime.getRuntime().addShutdownHook(new Thread(() -> app.stop(0)));
      System.out.println(
          "Parliament Explorer: http://127.0.0.1:"
              + port
              + "/"
              + (demo ? " (synthetic demo data)" : ""));
    } catch (Exception e) {
      System.err.println("Error: " + e.getMessage());
      System.exit(1);
    }
  }

  static Path createDemo() throws Exception {
    Path path = Files.createTempFile("parliament-demo-", ".db");
    path.toFile().deleteOnExit();
    try (var in = Main.class.getResourceAsStream("/demo.sql");
        var db = DriverManager.getConnection("jdbc:sqlite:" + path);
        var s = db.createStatement()) {
      if (in == null) throw new IllegalStateException("Missing demo data");
      for (String sql : new String(in.readAllBytes(), StandardCharsets.UTF_8).split(";"))
        if (!sql.isBlank()) s.execute(sql);
    }
    return path;
  }

  static HttpServer start(Corpus corpus, int port, boolean demo) throws Exception {
    var server = HttpServer.create(new InetSocketAddress("127.0.0.1", port), 32);
    server.setExecutor(Executors.newVirtualThreadPerTaskExecutor());
    server.createContext(
        "/",
        exchange -> {
          try {
            if (!exchange.getRequestMethod().equals("GET")) {
              send(
                  exchange,
                  405,
                  "application/json",
                  JSON.writeValueAsBytes(Map.of("error", "Only GET is supported")));
              return;
            }
            String route = exchange.getRequestURI().getPath();
            Map<String, String> params = params(exchange.getRequestURI().getRawQuery());
            if (route.equals("/api/speeches"))
              json(exchange, corpus.search(Corpus.Filter.from(params)));
            else if (route.equals("/api/stats"))
              json(exchange, corpus.stats(Corpus.Filter.from(params)));
            else if (route.equals("/api/factions")) json(exchange, corpus.factions());
            else if (route.equals("/api/meta"))
              json(exchange, Map.of("demo", demo, "schemaVersion", 1));
            else if (route.equals("/api/speech")) {
              var speech = corpus.speech(params.getOrDefault("id", ""));
              if (speech == null)
                send(
                    exchange,
                    404,
                    "application/json",
                    JSON.writeValueAsBytes(Map.of("error", "Speech not found")));
              else json(exchange, speech);
            } else {
              String resource =
                  switch (route) {
                    case "/" -> "index.html";
                    case "/app.js" -> "app.js";
                    case "/style.css" -> "style.css";
                    default -> null;
                  };
              if (resource == null) {
                send(exchange, 404, "text/plain", "Not found".getBytes(StandardCharsets.UTF_8));
                return;
              }
              try (var in = Main.class.getResourceAsStream("/public/" + resource)) {
                if (in == null) throw new IllegalStateException("Missing asset");
                send(
                    exchange,
                    200,
                    resource.endsWith(".js")
                        ? "text/javascript"
                        : resource.endsWith(".css") ? "text/css" : "text/html",
                    in.readAllBytes());
              }
            }
          } catch (IllegalArgumentException | java.time.DateTimeException e) {
            send(
                exchange,
                400,
                "application/json",
                JSON.writeValueAsBytes(
                    Map.of("error", e.getMessage() == null ? "Invalid query" : e.getMessage())));
          } catch (Exception e) {
            System.err.println("Request failed: " + e.getClass().getSimpleName());
            send(
                exchange,
                500,
                "application/json",
                JSON.writeValueAsBytes(Map.of("error", "Unable to read the corpus")));
          } finally {
            exchange.close();
          }
        });
    server.start();
    return server;
  }

  static Map<String, String> params(String raw) {
    Map<String, String> out = new HashMap<>();
    if (raw == null || raw.isEmpty()) return out;
    if (raw.length() > 4096) throw new IllegalArgumentException("Query is too long");
    for (String pair : raw.split("&")) {
      String[] kv = pair.split("=", 2);
      out.put(
          URLDecoder.decode(kv[0], StandardCharsets.UTF_8),
          kv.length == 1 ? "" : URLDecoder.decode(kv[1], StandardCharsets.UTF_8));
    }
    return out;
  }

  private static void json(HttpExchange ex, Object value) throws Exception {
    send(ex, 200, "application/json", JSON.writeValueAsBytes(value));
  }

  private static void send(HttpExchange ex, int status, String type, byte[] bytes)
      throws java.io.IOException {
    var h = ex.getResponseHeaders();
    h.set("Content-Type", type + "; charset=utf-8");
    h.set("X-Content-Type-Options", "nosniff");
    h.set(
        "Content-Security-Policy",
        "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; frame-ancestors 'none'; base-uri 'none'");
    h.set("Cache-Control", "no-store");
    ex.sendResponseHeaders(status, bytes.length);
    ex.getResponseBody().write(bytes);
  }
}
