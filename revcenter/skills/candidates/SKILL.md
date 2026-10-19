---
name: candidates
description: Browse and export a Revcenter workspace's candidate database — everyone its searches have found, across projects, with full profiles. Use for "who have we found for…", "search our candidates", "export everyone", "find people we already have who…".
---

# Candidate database

Everyone any of the workspace's searches found, newest first, as the Candidates tab in Revcenter
shows them. Only this workspace's people. This is the place for "everyone across the workspace";
for every record one search returned, read or not, use `list_search_records`, and for every
search in one project at once, `list_project_records` (searches skill).

## Look

- `list_candidates` with `q`, `project_id`, `title`, `company` or `location`.
- `revcenter candidates --q controller --pretty` (`--project`, `--title`, `--company`,
  `--location`, `--limit`, `--cursor`).

Follow `cursor` for more; `total` says how many match.

## Export

- `export_candidates` saves `./revcenter-exports/candidates.csv` (or `output_path`), with the same
  filters; `format: "jsonl"` saves `candidates.jsonl` instead.
- `revcenter candidates --csv candidates.csv`, or `revcenter candidates --jsonl candidates.jsonl`.

Up to 5,000 people. The CSV has every profile field as text and as numbered columns (experience 1
to 10, education 1 to 5, total and current-role months), the profile as JSON last; the JSON Lines
file has one person per line with the whole profile. For an AI agent, JSONL is lossless; CSV is for spreadsheets. Free.

## Score people you already have

To score the workspace's existing candidates against a new role without buying a search, launch
with `database_only: true` (no credit), or run `run_database_pass` on an existing search.
