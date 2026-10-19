---
name: searches
description: Run Revcenter candidate searches — draft criteria for a role, launch a search (reserves up to 1,000 credits by default), wait for it, and report who scored 80+. Use for "find me candidates for…", "source a…", "run a search", or several roles at once (one launch_searches call, then one sub-agent per search).
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

Show the user the criteria and the cap: "reserves up to 1,000 credits; unused credits come back".
Pick a bigger `max_credits` (2500, 5000) for broad roles or many places, a smaller one (500) for a
quick look; the credits skill says more. Launch only after they agree.

## 2. Launch and wait

MCP:

1. `create_project` (or reuse one from `list_projects`).
2. `launch_search` with `project_id`, `criteria` and, if not the default, `max_credits` (at least
   250). It asks the user to Accept or Decline the cap in one sentence; if it returns
   `pending_approval` (their client can't ask, or they didn't answer in time), show the proposal
   and call `apply_proposal` once they agree.
3. `wait_for_search` with the `search_id`. Searches usually take a few minutes.

CLI:

```bash
revcenter project create "Controller · Camden, NJ"
revcenter search <project_id> --criteria criteria.json --max-credits 1000 --wait
```

A repeated launch with the same project and criteria returns the first search; it is never charged
twice. So if a `launch_search` call times out while the user is answering the prompt, call it again
with exactly the same arguments: the idempotency key is derived from the request, so you get the
same search back (no second prompt, nothing more reserved). Don't change the criteria or the cap
on a retry; that is a new search. A `429` is retried for you.

Running several searches (one per role, or one per subagent): launch them all; none is refused for
being busy. Past the platform's limit a search reads `queued` with `queue.eta_seconds` and starts as
one finishes. Call `get_capacity` first (CLI: `revcenter capacity`) and tell the person roughly when
results will arrive, then `wait_for_search` each one.

## 3. Report

`list_people` with `min_score: 80` (or `revcenter people <search_id> --min-score 80 --pretty`):
for each person, the score, why they fit (title, place, years, must-haves) and their signals.
Say what it was charged (`credits_charged` on `get_search`). Offer next steps: refine (shortlists
skill), export, or widen with `expand_search` (reserves its own `max_credits`, 1,000 by default).

## Every record a search returned

`list_people` and the shortlist hold only the people a search scored. When the user wants "all the
raw profiles", "everyone it found" or to work the whole result set themselves, use the records:

- `list_search_records` with the `search_id` (or `revcenter records <search_id>`): one record per
  person the search returned, in order, each with `status` — `scored` (read and scored here, with
  its `score`), `known` (already in the workspace from another search, not read again) or
  `not_read` (listed, never read) — plus name, title, company, location, LinkedIn URL, summary, and
  the full `profile` for anyone the workspace has read. Page with `cursor` (up to 500 a page;
  `include_profile: false` / `--no-profile` for a lighter list).
- `export_search_records` saves them all to `./revcenter-exports/<search_id>-records.csv` (CLI:
  `revcenter records <search_id> --csv records.csv`): one row per record, read profiles as text
  columns and as numbered columns (experience 1 to 10, education 1 to 5, months). Tell the user
  the path and row count.
- With `format: "jsonl"` (CLI `--jsonl records.jsonl`) it saves JSON Lines instead: one record per
  line, the whole profile. For an AI agent, JSONL is lossless; CSV is for spreadsheets. To work the profiles yourself, read the
  JSONL; hand the CSV to a person.

For a whole project (every search in it, expansions and follow-up passes included), use the project
records instead of looping over search ids:

- `list_project_records` with the `project_id` (CLI: `revcenter records --project <project_id>`):
  one record per person across the project's searches, `status` rolled up (scored anywhere beats
  known beats not_read), the best `score`, plus `first_search_id` and `search_ids`.
- `export_project_records` saves `./revcenter-exports/<project_id>-records.csv` (CLI:
  `revcenter records --project <project_id> --csv project-records.csv`), or JSON Lines with
  `format: "jsonl"` (CLI `--jsonl`).

For everyone across the whole workspace, from every project, use the candidate database
(`list_candidates` / `export_candidates`, CLI `revcenter candidates`; candidates skill).

All free. A database-only search has no records. No contact details.

## Several roles at once

There's no limit on searches running together, only credits. For several roles (a batch of client
requests, an inbox triage):

1. Draft every role's criteria and confirm them all with the user in one table (each reserves its
   own cap, 1,000 credits by default).
2. Make the projects (`create_project`, one per role).
3. Launch them all in **one** call, so the user approves once:
   - MCP: `launch_searches` with `launches: [{project_id, criteria, max_credits?}, ...]` (up to 25).
     One prompt lists every search and the total; one Accept launches them all side by side. Each
     comes back with its `outcome`: `launched` (with `search.search_id`), `declined`,
     `pending_approval` (show it, then `apply_proposal` with its `proposal_id`) or `failed` (fix
     what the error says and call `launch_searches` again with just those; a launch that already
     ran comes back, never paid twice).
   - CLI: write the list to a file and run `revcenter launch batch.json` (add `--wait` to wait for
     all of them). Each line of the output has its `outcome`; the exit code is non-zero if any failed.
4. Then fan out: one sub-agent per launched search, each doing `wait_for_search` and step 3 for its
   role (and whatever follows, like drafting the client's reply). Sub-agents can run in parallel.
   For a reply to the client, take the project's link from `get_share_link` (CLI:
   `revcenter share <project_id>`) and paste its `url` into the draft. It is the same link every
   time and shows the live shortlist, so take off anyone who shouldn't be seen first
   (`remove_shortlist_member`), and don't send it while `shortlisted` is 0.
5. When all are done, gather a summary table (role, people found, shortlisted) and export each
   shortlist (shortlists skill).

Don't have each sub-agent launch its own search: the launches still reach the user as one prompt,
but `launch_searches` lets you report every outcome in one place and retry only the failures.

## Results delivered without an agent (webhooks)

When the user wants results to reach their own system as searches finish (an ATS sync, a pipeline,
a nightly job), instead of an agent waiting on them, add a webhook endpoint:

- `create_webhook` with their public `https://` URL and the events they want, usually
  `search.completed` and `shortlist.changed` (or leave events out for all of them). CLI:
  `revcenter webhooks create <url> --events search.completed,shortlist.changed`.
- The response carries the signing secret **once**. Tell the user to store it where their endpoint
  can read it, and don't repeat it afterwards; their endpoint checks each delivery's
  `Revcenter-Signature` with it (examples at https://docs.revcenter.ai/guides/webhooks).
- `test_webhook` sends a signed test event and says what their endpoint answered.
  `list_webhook_deliveries` shows what was sent and why anything failed; `redeliver_webhook` sends
  one again.

Events carry ids, counts and links, not profiles: their system reads the people through the links
with its own API key. Free; a workspace has up to 10 endpoints.

## If something stops you

- `shortlist_allocation_exhausted`: not enough credits for that cap — a smaller `max_credits`, or
  the credits skill. `no_active_plan`: credits skill.
- `max_credits_too_low`: the cap is under 250, too small to buy one page of results and read it.
  Use 250 or more (500 for a quick look).
- `invalid_max_credits`: a whole number from 250 to 20,000.
- A search that ends with `stop_reason` `cap_too_small` bought nothing and was refunded in full:
  launch again with a bigger `max_credits`.
- `invalid_criteria`: fix the fields it names.
- `invalid_webhook_url`: the endpoint must be public HTTPS; private and local addresses are refused.
- `search_unavailable`: offer `database_only: true` (scores people already found; no credits).
