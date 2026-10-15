// Merge-Ampel: je offenem PR eine Ampel, was bis zum Merge noch fehlt.
// Band ueber dem Prompt: eine Zeile pro PR. /merge-ampel: Details im Seitenbereich.

// Repos, deren PRs neben dem aktuellen Repo mitgezeigt werden.
const EXTRA_REPOS = ["gabrielleti/n8n"];
const REFRESH_MS = 5 * 60_000;
const PANE = { id: "merge-ampel", title: "Merge-Ampel" };
const LIGHTS = {
  red: { color: "red", word: "blockiert" },
  yellow: { color: "yellow", word: "wartet" },
  green: { color: "green", word: "merge-bereit" },
};

// Vom Host gehalten, damit der Stand einen Hot-Reload ueberlebt.
const snapshot = { plugin: "merge-ampel", key: "snapshot" };

const QUERY = `query($owner: String!, $name: String!) {
  viewer { login }
  repository(owner: $owner, name: $name) {
    pullRequests(states: OPEN, first: 20, orderBy: {field: UPDATED_AT, direction: DESC}) {
      nodes {
        number title url isDraft mergeable reviewDecision body
        author { login }
        reviewThreads(first: 100) { nodes { isResolved } }
        commits(last: 1) { nodes { commit { statusCheckRollup { state } } } }
      }
    }
  }
}`;

export function register(on) {
  on("session.start", async ($, e, next) => {
    const result = await next(e);
    await $.command.register({ name: "merge-ampel", description: "Merge-Ampel aktualisieren und Details zeigen" });
    // Nicht abwarten: session.start blockiert sonst den ersten Prompt.
    await $.clock.after(0, () => refresh($));
    await $.clock.every(REFRESH_MS, () => refresh($));
    return result;
  });

  on("command.run", { command: "merge-ampel" }, async ($) => {
    const snap = await refresh($);
    const opened = await $.ui.open({ ...PANE, focus: true });
    if (opened.isPlaced) return { text: "Merge-Ampel aktualisiert" };
    return { text: summaryText(snap) };
  });

  on("ui.render", { component: "AbovePrompt" }, async ($, e, next) => {
    const { value: snap } = await $.state.get(snapshot);
    if (e.props.hasSurvey || !snap?.prs?.length) return next(e);
    const { Box, Text } = $.ui.resolve(e);
    return band(Box, Text, snap);
  });

  on("ui.render", { component: "Pane" }, async ($, e, next) => {
    if (e.requestId !== PANE.id) return next(e);
    const { value: snap } = await $.state.get(snapshot);
    const { Box, Text } = $.ui.resolve(e);
    return pane(Box, Text, snap);
  });
}

async function refresh($) {
  const cwd = await $.session.cwd();
  const own = await $.process.run(["gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner"], { cwd });
  const ownRepo = own.exitCode === 0 ? own.stdout.trim() : null;
  const repos = [...new Set([ownRepo, ...EXTRA_REPOS].filter(Boolean))];

  const prs = [];
  const errors = [];
  for (const repo of repos) {
    const [owner, name] = repo.split("/");
    const r = await $.process.run(
      ["gh", "api", "graphql", "-f", `query=${QUERY}`, "-F", `owner=${owner}`, "-F", `name=${name}`],
      { cwd, timeoutMs: 20_000 },
    );
    if (r.exitCode !== 0) {
      errors.push(`${repo}: ${r.stderr.trim().split("\n")[0]}`);
      continue;
    }
    const { data } = JSON.parse(r.stdout);
    for (const pr of data.repository.pullRequests.nodes) {
      if (pr.author?.login !== data.viewer.login) continue;
      prs.push({ ...assess(pr), label: repo === ownRepo ? `#${pr.number}` : `${name}#${pr.number}` });
    }
  }

  const snap = { checkedAt: Date.now(), prs, errors };
  await $.state.set(snapshot, snap); // zeichnet Band und Pane neu
  return snap;
}

export function assess(pr) {
  const ci = pr.commits?.nodes?.[0]?.commit?.statusCheckRollup?.state ?? null;
  const openThreads = (pr.reviewThreads?.nodes ?? []).filter((t) => !t.isResolved).length;
  const todos = preMergeItems(pr.body ?? "").filter((i) => !i.done).map((i) => i.text);

  const blockers = [];
  if (ci === "FAILURE" || ci === "ERROR") blockers.push("CI rot");
  if (pr.mergeable === "CONFLICTING") blockers.push("Merge-Konflikt");
  if (pr.reviewDecision === "CHANGES_REQUESTED") blockers.push("Änderungen angefordert");

  const waits = [];
  if (ci === "PENDING" || ci === "EXPECTED") waits.push("CI läuft");
  if (pr.isDraft) waits.push("Entwurf");
  if (openThreads > 0) waits.push(`${openThreads} Review-Thread${openThreads === 1 ? "" : "s"} offen`);

  const light = blockers.length ? "red" : waits.length || todos.length ? "yellow" : "green";
  return {
    number: pr.number,
    title: pr.title,
    url: pr.url,
    light,
    checks: [
      { ok: ci === null || ci === "SUCCESS", text: ci === null ? "keine CI" : ci === "SUCCESS" ? "CI grün" : `CI ${ci.toLowerCase()}` },
      { ok: pr.mergeable !== "CONFLICTING", text: pr.mergeable === "CONFLICTING" ? "Merge-Konflikt" : "mergebar" },
      { ok: openThreads === 0 && pr.reviewDecision !== "CHANGES_REQUESTED", text: openThreads ? `${openThreads} Threads offen` : "Reviews" },
    ],
    blockers,
    waits,
    todos,
  };
}

// Listenpunkte unter einer Ueberschrift "Vor dem Merge ...". Erledigt: [x], ~~durchgestrichen~~ oder ✅.
export function preMergeItems(body) {
  const items = [];
  let inSection = false;
  for (const line of body.split("\n")) {
    const heading = line.match(/^#{1,6}\s+(.*)/);
    if (heading) {
      inSection = /vor dem merge/i.test(heading[1]);
      continue;
    }
    const item = inSection && line.match(/^(?:[-*]|\d+\.)\s+(.*)/);
    if (!item) continue;
    let text = item[1].trim();
    const checkbox = text.match(/^\[([ xX])\]\s*/);
    const done = (checkbox && checkbox[1] !== " ") || text.startsWith("~~") || text.startsWith("✅");
    if (checkbox) text = text.slice(checkbox[0].length);
    items.push({ done, text: shorten(text) });
  }
  return items;
}

function shorten(text) {
  const plain = text.replace(/[*`~]/g, "").replace(/^✅\s*/, "");
  const head = plain.split(/\s+—\s+|:\s/)[0].replace(/[.,]$/, "");
  return head.length > 60 ? `${head.slice(0, 59)}…` : head;
}

function openCount(pr) {
  return pr.blockers.length + pr.waits.length + pr.todos.length;
}

function band(Box, Text, snap) {
  const parts = [Text({ bold: true, children: "Merge-Ampel" })];
  for (const pr of snap.prs) {
    const l = LIGHTS[pr.light];
    const detail = pr.light === "green" ? l.word : pr.blockers[0] ?? `${openCount(pr)} offen`;
    parts.push(Text({ color: l.color, children: `  ● ${pr.label}` }));
    parts.push(Text({ dimColor: true, children: ` ${detail}` }));
  }
  return Box({ flexDirection: "row", paddingX: 1, children: parts });
}

function pane(Box, Text, snap) {
  if (!snap) return Text({ dimColor: true, children: "Noch kein Stand. /merge-ampel lädt ihn." });
  const rows = [];
  if (!snap.prs.length) rows.push(Text({ dimColor: true, children: "Keine offenen PRs von dir." }));
  for (const pr of snap.prs) {
    const l = LIGHTS[pr.light];
    rows.push(Box({
      flexDirection: "row",
      children: [
        Text({ color: l.color, bold: true, children: `● ${pr.label} ${l.word}` }),
        Text({ children: `  ${pr.title}` }),
      ],
    }));
    rows.push(Text({ children: "   " + pr.checks.map((c) => `${c.ok ? "✓" : "✗"} ${c.text}`).join("   ") }));
    for (const text of [...pr.blockers, ...pr.waits.filter((w) => !w.endsWith("offen"))]) {
      rows.push(Text({ color: l.color, children: `   ! ${text}` }));
    }
    for (const text of pr.todos) rows.push(Text({ children: `   ☐ ${text}` }));
    rows.push(Text({ children: " " }));
  }
  for (const err of snap.errors) rows.push(Text({ color: "red", children: `Fehler ${err}` }));
  const at = new Date(snap.checkedAt).toLocaleTimeString("de-AT", { hour: "2-digit", minute: "2-digit" });
  rows.push(Text({ dimColor: true, children: `Stand ${at} · alle 5 min neu · /merge-ampel sofort` }));
  return Box({ flexDirection: "column", paddingX: 1, children: rows });
}

function summaryText(snap) {
  if (!snap.prs.length) return "Keine offenen PRs von dir.";
  return snap.prs
    .map((pr) => {
      const lines = [`● ${pr.label} ${LIGHTS[pr.light].word} — ${pr.title}`];
      for (const t of [...pr.blockers, ...pr.waits, ...pr.todos]) lines.push(`   ☐ ${t}`);
      return lines.join("\n");
    })
    .join("\n");
}
