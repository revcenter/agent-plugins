---
name: candidates
description: Browse and export a Revcenter workspace's candidate database — everyone its searches have found, across projects, with full profiles. Use for "who have we found for…", "search our candidates", "export everyone", "find people we already have who…".
---

# Candidate database

Everyone any of the workspace's searches found, newest first, as the Candidates tab in Revcenter
shows them. Only this workspace's people.

## Look

- `list_candidates` with `q`, `project_id`, `title`, `company` or `location`.
- `revcenter candidates --q controller --pretty` (`--project`, `--title`, `--company`,
  `--location`, `--limit`, `--cursor`).

Follow `cursor` for more; `total` says how many match.

## Export

- `export_candidates` saves `./revcenter-exports/candidates.csv` (or `output_path`), with the same
  filters.
- `revcenter candidates --csv candidates.csv`.

Up to 5,000 people, every profile field, the profile as JSON last. Free.

## Score people you already have

To score the workspace's existing candidates against a new role without buying a search, launch
with `database_only: true` (no credit), or run `run_database_pass` on an existing search.
