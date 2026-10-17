---
name: shortlists
description: Work with Revcenter shortlists — read who made it, change the cut-off, weights or requirements (free re-scoring), add or remove people, and export the shortlist as CSV with full profiles. Use for "show me the shortlist", "who scored highest", "tighten/loosen it", "remove…", "export…".
---

# Shortlists

A project's shortlist is everyone its searches scored at or above the cut-off (80 by default),
plus anyone added by hand.

## Read

- `get_shortlist` / `revcenter shortlist <project_id> --pretty`: everyone on it, best first.
- `list_people` / `revcenter people <search_id> --min-score 70 --pretty`: everyone a search scored,
  including those just under the bar.

## Refine (free)

Preview first, then apply:

- `preview_scoring` / `revcenter rescore <search_id> … --preview`: before and after counts.
- `apply_scoring` / `revcenter rescore <search_id> …`.

What can change: `shortlist_min_score` (50–85), `rubric_weights`, and requirements through
`criteria_patch` (`must_have`, `skills`, exclusions). Titles and places can't: that's a new search.

## Edit

- `add_shortlist_members` with candidate ids from `list_people` / `revcenter add <project_id> <id…>`.
- `remove_shortlist_member` with a reason / `revcenter remove <project_id> <id> --reason "…"`.

## Export

- `export_shortlist` saves a CSV to `./revcenter-exports/shortlist-<project>.csv` (or `output_path`).
- `revcenter shortlist <project_id> --csv shortlist.csv`.

Each row has the score, fit readings, signals, LinkedIn URL, and the whole profile: about,
experience history, education, skills, certifications, languages, and the profile as JSON in the
last column. Tell the user the path and the row count; offer to summarize, filter or reshape it.
