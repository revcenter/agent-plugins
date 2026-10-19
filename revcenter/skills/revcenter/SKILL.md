---
name: revcenter
description: Revcenter — LinkedIn candidate searches that come back as scored shortlists, run from your agent. Use whenever the user mentions Revcenter, sourcing, a candidate search, a shortlist, recruiting for a role, their candidate database or shortlist credits. Routes to the setup, searches, shortlists, candidates and credits skills.
---

# Revcenter

Revcenter finds people for a role on LinkedIn, reads their full profiles, scores each one against the
role's criteria (0–100), and keeps a live shortlist of everyone scoring 80 or more. You do the
reasoning; Revcenter does the searching, scoring and record-keeping.

Two ways in, same account and same data:

- **MCP tools** (preferred inside a chat): `list_projects`, `launch_search`, `wait_for_search`,
  `list_people`, `list_search_records`, `export_search_records`, `list_project_records`,
  `export_project_records`, `get_shortlist`, `export_shortlist`, `list_candidates`,
  `export_candidates`, `get_usage`, `create_top_up` and more. `list_actions` lists every tool and
  its cost.
- **The `revcenter` CLI**: JSON on stdout, `--pretty` for tables, documented exit codes.
  `revcenter --help` lists every command.

## Before anything

If the session start note says setup is required, or a call fails with `missing_api_key` or
`invalid_api_key`, use the **setup** skill first.

## Route the request

| The user wants to… | Skill |
| --- | --- |
| Install, sign in, connect Revcenter to this agent | setup |
| Find people for a role; run several searches at once | searches |
| See, refine, edit or export a shortlist | shortlists |
| Look through or export everyone found so far | candidates |
| Know what's left, what something costs, buy more | credits |

## Rules that always apply

- A new search, or expanding one, uses **1 shortlist credit**. Show the criteria (or the role, place
  and must-haves) and get a yes before launching. Reading, re-scoring, editing and exporting are free.
- Never print an API key. The CLI saves it; the MCP server reads it from there.
- Revcenter's own words for things: projects, searches, shortlists, credits, scores. Don't guess at
  what powers it underneath.
- Docs index for anything else: https://docs.revcenter.ai/llms.txt
