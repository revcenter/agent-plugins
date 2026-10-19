<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://www.revcenter.ai/revcenter-logo-white.svg">
    <img src="https://www.revcenter.ai/revcenter-logo.svg" alt="Revcenter" width="220">
  </picture>
</p>

<p align="center"><strong>Recruit from your AI coding agent</strong>: skills, MCP tools and the <code>revcenter</code> CLI for Claude Code, Codex and Cursor.</p>

<p align="center"><a href="https://docs.revcenter.ai">Docs</a> · <a href="GETTING_STARTED.md">Getting started</a></p>

---

Paste this into your agent:

```
Set up the Revcenter plugin by following the steps in https://github.com/revcenter/agent-plugins
```

It installs the CLI, signs you in through your browser (one click to authorize a workspace), connects
Revcenter to the agent and checks how many credits you have. Then ask for a role:

> Find a Plant Controller near Camden, NJ: CPA, 7+ years. Show me the criteria first.

> Run three searches in parallel, one sub-agent each, then export every shortlist.

## Install by hand

**Claude Code**

```
/plugin marketplace add revcenter/agent-plugins
/plugin install revcenter@revcenter-plugins
```

**Codex**

```
codex plugin marketplace add revcenter/agent-plugins
```

Then open **Plugins** and install **revcenter**.

**Any other agent:** install the CLI and let it connect your tools.

```bash
curl -fsSL https://revcenter.ai/install.sh | sh
revcenter login
revcenter setup
```

## What's inside

| Skill | For |
| --- | --- |
| `revcenter` | What Revcenter does and which skill to use |
| `setup` | Install, sign in, connect the agent |
| `searches` | Criteria, launching (a cap in credits), waiting, parallel searches |
| `shortlists` | Reading, free re-scoring, edits, CSV exports with full profiles |
| `candidates` | The workspace's candidate database, browse and export |
| `credits` | What's left, how a search is charged, choosing a cap, buying more |

The plugin runs the Revcenter MCP server (`revcenter mcp`) and checks at session start that the
CLI is installed, recent enough and signed in.

## Costs

A new search or an expansion reserves up to its cap in credits (1,000 by default) from your
workspace, is charged for the profiles it reads, and refunds the rest; everything else (reading,
re-scoring, editing, exporting) is free. Searches ask before they spend. You need a Revcenter
workspace with API access; ask your Revcenter contact.

This repository is released from Revcenter's main repository; changes made here directly are
overwritten by the next release.
