---
name: searches
description: Run Revcenter candidate searches — draft criteria for a role, launch a search (1 shortlist credit), wait for it, and report who scored 80+. Use for "find me candidates for…", "source a…", "run a search", or several roles at once (one sub-agent per role).
---

# Searches

One search finds people for one role in one place. Each project holds a role's searches and its
shortlist.

## 1. Criteria

Read the criteria reference once per session (`get_criteria_reference`, or
`revcenter reference`). The essentials:

- `title_variants`: current job titles, literal (up to 10). The first is the role.
- `metro`: "City, ST", a state, or a country.
- Often useful: `years_experience`, `must_have`, `skills_required`, `exclude_titles`,
  `employers` / `exclude_companies`, and `current_industries` (use `search_industries` /
  `revcenter industries <word>` for LinkedIn's names). The reference lists the rest.

`must_have` and `exclude_titles` are matched as literal text: short terms like "CPA", never
sentences.

Show the user the criteria and say it uses 1 shortlist credit. Launch only after they agree.

## 2. Launch and wait

MCP:

1. `create_project` (or reuse one from `list_projects`).
2. `launch_search` with `project_id` and `criteria`. It asks the user to confirm the credit; if it
   returns `pending_approval`, show the proposal and call `apply_proposal` once they agree.
3. `wait_for_search` with the `search_id`. Searches usually take a few minutes.

CLI:

```bash
revcenter project create "Controller · Camden, NJ"
revcenter search <project_id> --criteria criteria.json --wait
```

A repeated launch with the same project and criteria returns the first search; it is never charged
twice. A `429` is retried for you.

Running several searches (one per role, or one per subagent): launch them all; none is refused for
being busy. Past the platform's limit a search reads `queued` with `queue.eta_seconds` and starts as
one finishes. Call `get_capacity` first (CLI: `revcenter capacity`) and tell the person roughly when
results will arrive, then `wait_for_search` each one.

## 3. Report

`list_people` with `min_score: 80` (or `revcenter people <search_id> --min-score 80 --pretty`):
for each person, the score, why they fit (title, place, years, must-haves) and their signals.
Offer next steps: refine (shortlists skill), export, or widen with `expand_search` (1 more credit).

## Several roles at once

There's no limit on searches running together, only credits. For several roles, confirm all the
criteria with the user first (one credit each), then run one sub-agent per role, each doing steps
2 and 3 for its role. When all are done, gather a summary table (role, people found, shortlisted)
and export each shortlist (shortlists skill).

## If something stops you

- `shortlist_allocation_exhausted` / `no_active_plan`: out of credits — credits skill.
- `invalid_criteria`: fix the fields it names.
- `search_unavailable`: offer `database_only: true` (scores people already found; no credit).
