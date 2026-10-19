"use strict";
const $ = (id) => document.getElementById(id),
  number = new Intl.NumberFormat("de-DE");
const fields = ["q", "faction", "from", "to", "sort"];
let page = 1,
  total = 0,
  request,
  detailRequest,
  currentSpeech = null;
function element(tag, text, cls) {
  const e = document.createElement(tag);
  if (text !== undefined) e.textContent = text;
  if (cls) e.className = cls;
  return e;
}
function date(value) {
  return new Intl.DateTimeFormat("de-DE", {
    dateStyle: "medium",
    timeZone: "UTC",
  }).format(new Date(value + "T00:00:00Z"));
}
async function api(path, signal) {
  const r = await fetch(path, { signal });
  const data = await r.json();
  if (!r.ok) throw new Error(data.error || "Anfrage fehlgeschlagen");
  return data;
}
function parameters() {
  const p = new URLSearchParams();
  for (const id of fields) if ($(id).value) p.set(id, $(id).value);
  p.set("page", page);
  return p;
}
function restore() {
  const p = new URLSearchParams(location.search);
  for (const id of fields)
    $(id).value = p.get(id) || (id === "sort" ? "newest" : "");
  const n = Number(p.get("page") || 1);
  page = Number.isInteger(n) && n > 0 ? n : 1;
}
async function load(push = true) {
  request?.abort();
  request = new AbortController();
  const signal = request.signal;
  const params = parameters();
  if (push) history.replaceState(null, "", "/?" + params);
  $("status").textContent = "Reden werden gesucht …";
  $("cards").replaceChildren();
  $("prev").disabled = true;
  $("next").disabled = true;
  try {
    const [data, stats] = await Promise.all([
      api("/api/speeches?" + params, signal),
      api("/api/stats?" + params, signal),
    ]);
    if (signal.aborted) return;
    total = data.total;
    $("result-count").textContent = number.format(total);
    for (const key of ["speeches", "speakers", "sessions", "words"])
      $("m-" + key).textContent = number.format(stats.totals[key]);
    $("status").textContent = total
      ? `${number.format(total)} Reden in dieser Auswahl.`
      : "Keine Reden gefunden. Versuche andere Begriffe oder setze die Filter zurück.";
    for (const item of data.items) {
      const card = element("article", undefined, "speech-card"),
        top = element("div", undefined, "card-top");
      top.append(element("span", item.faction, "pill"));
      const time = element("time", date(item.date));
      time.dateTime = item.date;
      top.append(time);
      card.append(
        top,
        element("h3", item.speaker),
        element("p", item.agenda, "agenda"),
        element(
          "p",
          item.excerpt + (item.excerpt.length === 260 ? " …" : ""),
          "excerpt",
        ),
      );
      const bottom = element("div", undefined, "card-bottom"),
        button = element("button", "Rede lesen ↗");
      button.type = "button";
      button.setAttribute("aria-label", `Rede von ${item.speaker} lesen`);
      button.addEventListener("click", () => openSpeech(item.id));
      bottom.append(
        element(
          "span",
          `${number.format(item.word_count)} Wörter · Sitzung ${item.number}`,
        ),
        button,
      );
      card.append(bottom);
      $("cards").append(card);
    }
    $("groups").replaceChildren();
    const max = Math.max(1, ...stats.factions.map((x) => x.speeches));
    for (const group of stats.factions) {
      const row = element("div", undefined, "group-row"),
        label = element("div", undefined, "group-label"),
        bar = element("progress");
      label.append(
        element("span", group.faction),
        element("span", number.format(group.speeches)),
      );
      bar.max = max;
      bar.value = group.speeches;
      bar.setAttribute(
        "aria-label",
        `${group.faction}: ${group.speeches} Reden`,
      );
      row.append(label, bar);
      $("groups").append(row);
    }
    $("page-label").textContent =
      `Seite ${page} von ${Math.max(1, Math.ceil(total / 20))}`;
    $("prev").disabled = page <= 1;
    $("next").disabled = page * 20 >= total;
  } catch (e) {
    if (e.name === "AbortError") return;
    $("status").textContent =
      "Die Suche konnte nicht geladen werden: " + e.message;
    $("result-count").textContent = "";
    $("groups").replaceChildren();
    for (const key of ["speeches", "speakers", "sessions", "words"])
      $("m-" + key).textContent = "—";
    $("page-label").textContent = "";
  }
}
async function openSpeech(id) {
  detailRequest?.abort();
  detailRequest = new AbortController();
  const signal = detailRequest.signal;
  currentSpeech = null;
  $("speech-title").textContent = "Rede wird geladen …";
  for (const id of ["speech-meta", "speech-agenda", "speech-source"])
    $(id).textContent = "";
  $("speech-body").replaceChildren();
  $("comments").replaceChildren();
  $("comments-section").hidden = true;
  $("download").disabled = true;
  $("print").disabled = true;
  if (!$("speech-dialog").open) $("speech-dialog").showModal();
  try {
    const s = await api("/api/speech?id=" + encodeURIComponent(id), signal);
    if (signal.aborted) return;
    currentSpeech = s;
    $("speech-title").textContent = s.speaker;
    $("speech-meta").textContent =
      `${s.faction} · ${date(s.date)} · ${number.format(s.word_count)} Wörter`;
    $("speech-agenda").textContent = s.agenda;
    for (const text of s.text.split(/\n\s*\n/))
      $("speech-body").append(element("p", text));
    for (const comment of s.comments)
      $("comments").append(element("li", comment));
    $("comments-section").hidden = !s.comments.length;
    $("speech-source").textContent =
      `Quelle: ${s.source} · Wahlperiode ${s.term}, Sitzung ${s.number} · ID ${s.id}`;
    $("download").disabled = false;
    $("print").disabled = false;
  } catch (e) {
    if (e.name !== "AbortError")
      $("speech-title").textContent = "Rede nicht verfügbar: " + e.message;
  }
}
$("close-dialog").addEventListener("click", () => $("speech-dialog").close());
$("speech-dialog").addEventListener("close", () => detailRequest?.abort());
$("download").addEventListener("click", () => {
  if (!currentSpeech) return;
  const s = currentSpeech;
  const text = `${s.speaker}\n${s.faction} · ${s.date}\n${s.agenda}\n\n${s.text}\n\nZwischenrufe & Reaktionen\n${s.comments.join("\n")}\n\nQuelle: ${s.source} · ${s.id}\n`;
  const url = URL.createObjectURL(
    new Blob([text], { type: "text/plain;charset=utf-8" }),
  );
  const a = element("a");
  a.href = url;
  a.download = s.id.replace(/[^a-zA-Z0-9_-]/g, "_") + ".txt";
  a.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
});
$("print").addEventListener("click", () => window.print());
let timer;
$("q").addEventListener("input", () => {
  clearTimeout(timer);
  timer = setTimeout(() => {
    page = 1;
    load();
  }, 300);
});
$("filters").addEventListener("submit", (e) => {
  e.preventDefault();
  clearTimeout(timer);
  page = 1;
  load();
});
for (const id of ["faction", "from", "to", "sort"])
  $(id).addEventListener("change", () => {
    page = 1;
    load();
  });
$("reset").addEventListener("click", () => {
  clearTimeout(timer);
  $("filters").reset();
  $("sort").value = "newest";
  page = 1;
  load();
});
$("prev").addEventListener("click", () => {
  if (page > 1) {
    page--;
    load();
    $("results").focus();
  }
});
$("next").addEventListener("click", () => {
  if (page * 20 < total) {
    page++;
    load();
    $("results").focus();
  }
});
window.addEventListener("popstate", () => {
  restore();
  load(false);
});
async function init() {
  try {
    const [groups, meta] = await Promise.all([
      api("/api/factions"),
      api("/api/meta"),
    ]);
    for (const g of groups) {
      const option = element("option", g.faction);
      option.value = g.faction;
      $("faction").append(option);
    }
    $("demo").hidden = !meta.demo;
    restore();
    await load(false);
  } catch (e) {
    $("status").textContent = "Das Archiv ist nicht erreichbar: " + e.message;
  }
}
init();
