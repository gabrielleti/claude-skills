import { describe, expect, test } from "claude-code/testing";

const BODY = [
  "## Tests",
  "- [ ] Manuell getestet",
  "## Vor dem Merge zu entscheiden",
  "1. **Gerätetest (8 Szenarien)** — steht aus.",
  "2. ~~**`firestore.rules` deployen**~~",
  "- [x] n8n#34 mergen",
  "- [ ] SimpleCameraView abnehmen",
  "## Wie dieser Branch entstanden ist",
  "- kein Punkt",
].join("\n");

function graphql(prs: any[]) {
  return JSON.stringify({ data: { viewer: { login: "me" }, repository: { pullRequests: { nodes: prs } } } });
}

function pr(number: number, over: any = {}) {
  return {
    number, title: `PR ${number}`, url: "u", isDraft: false, mergeable: "MERGEABLE", reviewDecision: null,
    body: "", author: { login: "me" }, reviewThreads: { nodes: [] },
    commits: { nodes: [{ commit: { statusCheckRollup: { state: "SUCCESS" } } }] }, ...over,
  };
}

describe("merge-ampel", () => {
  test("band zeigt je PR die Ampel", async ($, on) => {
    on("session.start", ($, e) => ({ cwd: e.cwd }));
    on("session.cwd", () => ({ value: "/work" }));
    on("command.register", () => ({ value: null }));
    on("clock.every", () => ({ value: null }));
    on("clock.after", () => ({ value: null }));
    on("ui.open", () => ({ value: { isPlaced: true } }));
    on("process.run", ($, e) => {
      const argv = e.argv as string[];
      if (argv[1] === "repo") return { value: { exitCode: 0, stdout: "gabrielleti/Mangianni\n", stderr: "" } };
      if (argv.some((a) => a === "name=Mangianni")) {
        return { value: { exitCode: 0, stderr: "", stdout: graphql([
          pr(187, { body: BODY }),
          pr(188),
          pr(190, { author: { login: "someone" } }),
        ]) } };
      }
      return { value: { exitCode: 0, stderr: "", stdout: graphql([
        pr(32, { commits: { nodes: [{ commit: { statusCheckRollup: { state: "FAILURE" } } }] } }),
      ]) } };
    });

    await $.session.start({ surface: "terminal", isInteractive: true, cwd: "/work" } as any);
    await $.command.run({ command: "merge-ampel", args: "" } as any); // laedt den Stand
    const ui = await $.ui.mount({
      plugin: "merge-ampel",
      surface: "terminal",
      component: "AbovePrompt",
      props: { hasSurvey: false, isWorking: false, maxRows: 10, bodyColumns: 120 },
    } as any);

    expect(await ui.find({ type: "Text", text: /#187/ })).toBeDefined();
    expect(await ui.find({ type: "Text", text: /2 offen/ })).toBeDefined();
    expect(await ui.find({ type: "Text", text: /merge-bereit/ })).toBeDefined();
    expect(await ui.find({ type: "Text", text: /n8n#32/ })).toBeDefined();
    expect(await ui.find({ type: "Text", text: /CI rot/ })).toBeDefined();
    expect(await ui.find({ type: "Text", text: /#190/ })).toBeUndefined();
    await ui.unmount();

    const pane = await $.ui.mount({
      plugin: "merge-ampel",
      surface: "terminal",
      component: "Pane",
      requestId: "merge-ampel",
      props: { title: "Merge-Ampel", isFocused: true, bodyColumns: 80, placement: "dock" },
    } as any);
    expect(await pane.find({ type: "Text", text: /☐ Gerätetest \(8 Szenarien\)$/ })).toBeDefined();
    expect(await pane.find({ type: "Text", text: /☐ SimpleCameraView abnehmen/ })).toBeDefined();
    expect(await pane.find({ type: "Text", text: /firestore/ })).toBeUndefined();
    expect(await pane.find({ type: "Text", text: /n8n#34/ })).toBeUndefined();
    expect(await pane.find({ type: "Text", text: /Manuell getestet/ })).toBeUndefined();
    expect(await pane.find({ type: "Text", text: /✗ CI failure/ })).toBeDefined();
    expect(await pane.find({ type: "Text", text: /^Stand \d\d:\d\d/ })).toBeDefined();
    await pane.unmount();
  });
});
