export type MergeAmpelCheck = { ok: boolean; text: string };
export type MergeAmpelPr = {
  number: number;
  label: string;
  title: string;
  url: string;
  light: "red" | "yellow" | "green";
  checks: MergeAmpelCheck[];
  blockers: string[];
  waits: string[];
  todos: string[];
};
export type MergeAmpelSnapshot = { checkedAt: number; prs: MergeAmpelPr[]; errors: string[] };

declare module "claude-code" {
  interface PluginState {
    "merge-ampel": { snapshot: MergeAmpelSnapshot };
  }
}
