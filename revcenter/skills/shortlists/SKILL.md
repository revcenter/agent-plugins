---
name: shortlists
description: Work with Revcenter shortlists — read who made it, change the cut-off or requirements (free re-scoring), add or remove people, and export the shortlist as CSV with full profiles. Use for "show me the shortlist", "who scored highest", "tighten/loosen it", "remove…", "export…".
---

# Shortlists

A project's shortlist is everyone its searches scored at or above the cut-off (80 by default),
plus anyone added by hand.

## Read

- `get_shortlist` / `revcenter shortlist <project_id> --pretty`: everyone on it, best first.
- `list_people` / `revcenter people <search_id> --min-score 70 --pretty`: everyone a search scored,
  including those just under the bar.
- `list_search_records` / `revcenter records <search_id>`: everyone the search returned, scored or
  not (see the searches skill); `export_search_records` for all of them as CSV.
  `list_project_records` / `export_project_records` (`revcenter records --project <project_id>`) do
  the same for every search in the project at once.

## Refine (free)

Preview first, then apply:

- `preview_scoring` / `revcenter rescore <search_id> … --preview`: before and after counts.
- `apply_scoring` / `revcenter rescore <search_id> …`.

What can change: `shortlist_min_score` (50–85) and requirements through `criteria_patch`
(`must_have`, `skills`, exclusions). Titles and places can't: that's a new search. Scoring weights
are a workspace setting an admin changes in Settings, Scoring, not per search.

## Edit

- `add_shortlist_members` with candidate ids from `list_people` / `revcenter add <project_id> <id…>`.
- `remove_shortlist_member` with a reason / `revcenter remove <project_id> <id> --reason "…"`.

## Export

- `export_shortlist` saves a CSV to `./revcenter-exports/shortlist-<project>.csv` (or `output_path`);
  `format: "jsonl"` saves JSON Lines instead.
- `revcenter shortlist <project_id> --csv shortlist.csv`, or `--jsonl shortlist.jsonl`.

For an AI agent, JSONL is lossless; CSV is for spreadsheets. Read the JSONL when you work the
people yourself; give the CSV to a person who opens it in Excel or Sheets (it is UTF-8 with a byte
order mark, so accents and "·" show as written).

Each CSV row has the score, fit readings (each column, and all of them in score_breakdown), why
they fit, signals, LinkedIn URL, and the whole profile: about, experience history, education,
skills, certifications, languages, the career as numbered columns (experience 1 to 10 with title,
company, dates and months; education 1 to 5), and the profile as JSON in the last column. Tell the user the path and the row count; offer to summarize, filter or reshape it.
