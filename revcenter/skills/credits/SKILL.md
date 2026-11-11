---
name: credits
description: Revcenter credits — the balance, what a search costs, choosing a search's cap, what it was charged, and buying more from the terminal (Stripe checkout). Use for "how many credits", "what does this cost", "how much did that search use", out-of-credit errors (shortlist_allocation_exhausted, no_active_plan), or "top up".
---

# Credits

Revcenter meters in **credits**, the same ones the Revcenter app uses (plan plus top-ups). 3 credits
per profile delivered. People you already have are free. The workspace's own numbers are in
`get_usage` / `revcenter usage` under `credit_terms`: its limit per search
(`max_credits_per_search`, what a search reserves when it names no cap) and per project, and
`credits_per_profile`. Quote those, never a fixed number.

| Uses credits | Free |
| --- | --- |
| Launching a search | Reading anything |
| Expanding a search | Re-scoring, editing shortlists |
| `database_only` searches (3 credits per profile delivered) | Exports, the candidate database |

## How a search is charged

1. **Cap.** Every `launch_search` and `expand_search` takes `max_credits`, any whole number from 250
   up to the workspace's limit per search (left out, the search reserves that limit; under 250 is refused with
   `max_credits_too_low`). The CLI flag is
   `--max-credits`.
2. **Reserve.** The cap is held from the balance when the search starts (`credits_reserved` in the
   response). If the balance can't cover it, the launch is refused with
   `shortlist_allocation_exhausted` and nothing runs.
3. **Charge.** The search spends 3 credits for each profile it delivers
   (`credit_terms.credits_per_profile`), and stops at its cap. People the workspace already has are
   free; results pages, lookups and AI screening cost nothing. When few people match, it stops early
   and says so. When it finishes, it is charged profiles × 3, never more than the cap, and the
   rest comes back. `get_search` / `revcenter status <search_id>` shows `credits_charged` once it has
   finished (null while it runs) and `credits_breakdown.line`, the arithmetic.
4. **Refund.** A search that fails, or never starts, gets every credit back. Repeating a launch
   never charges twice.

## Company searches

A search for companies that are hiring is charged per company, for the data the person chose: 2
credits for each company listed, 5 more for each with hiring signals (leaders who left or joined,
title moves), 3 more for each with decision makers (up to 6 named people). All three are 10 a
company; a list that finds any company is charged at least 100. Hiring signals and decision makers
are charged only for a company where some turned up. Companies already in the workspace's
results and staffing agencies left out are free. `get_search` shows the spend per action under
`credits_breakdown.companies` (`found`, `hiring_signals`, `decision_makers`, `list_minimum`) and
`credits_breakdown.companies.line`, e.g. "Finding 60 · Hiring signals 150 · Decision makers 90".

## Choosing a cap

- Leave `max_credits` out for the workspace's limit per search; that suits most roles.
- 500 for a quick look at a narrow, well-defined role.
- A bigger cap (up to the limit) for broad roles, several places, or as many people as possible. A
  bigger cap only lets the search deliver more; unused credits come back.
- Say the cap when you show the user the criteria ("reserves up to N credits; unused credits come
  back"), and get their yes before launching.

## What's left

`get_usage` / `revcenter usage`: `credits_remaining` (what a new search can reserve now), searches
running, requests today. Credits held by running searches aren't in `credits_remaining` until those
searches finish and give back what they didn't use.

## Buy more

`create_top_up` (opens Stripe checkout in the user's browser) or `revcenter topup`
(`--amount 3000` for $3,000; $1,500 to $30,000, default $1,500). It shows how many credits the
amount buys at the workspace's plan rate. Nothing is charged until the user pays on that page;
credits arrive as soon as they do. Confirm the amount with the user before creating the link.

`shortlist_allocation_exhausted`: not enough credits for that cap. Offer a smaller `max_credits`
or a top-up. `trial_used_up`: the free trial is used up; the user chooses a plan to keep searching.

`database_pass_needs_credits`: the search has finished and its credits are settled, so a database
pass can't add people. Offer `expand_search` instead.

`top_up_needs_plan`: the workspace has no plan; send the user to `details.billing_url`
(Settings → Plan & billing in Revcenter).
