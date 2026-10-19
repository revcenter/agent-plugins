---
name: credits
description: Revcenter credits — the balance, what a search costs, choosing a search's cap, what it was charged, and buying more from the terminal (Stripe checkout). Use for "how many credits", "what does this cost", "how much did that search use", out-of-credit errors (shortlist_allocation_exhausted, no_active_plan), or "top up".
---

# Credits

Revcenter meters in **credits**, the same ones the Revcenter app uses (plan plus top-ups). A
standard search is about 1,000 credits, so a balance of 37,000 is roughly 37 searches.

| Uses credits | Free |
| --- | --- |
| Launching a search | Reading anything |
| Expanding a search | Re-scoring, editing shortlists |
| | Exports, the candidate database |
| | `database_only` searches |

## How a search is charged

1. **Cap.** Every `launch_search` and `expand_search` takes `max_credits`: 500, 1000, 2500 or 5000
   (any whole number from 100 to 20,000; 1,000 if you leave it out). The CLI flag is
   `--max-credits`.
2. **Reserve.** The cap is held from the balance when the search starts (`credits_reserved` in the
   response). If the balance can't cover it, the launch is refused with
   `shortlist_allocation_exhausted` and nothing runs.
3. **Charge.** The search spends credits as it reads profiles and stops at its cap. When it
   finishes, it is charged what it used, never more than the cap, and the rest comes back.
   `get_search` / `revcenter status <search_id>` shows `credits_charged` once it has finished
   (null while it runs).
4. **Refund.** A search that fails, or never starts, gets every credit back. Repeating a launch
   never charges twice.

## Choosing a cap

- 1,000 (the default) suits most single-place roles.
- 500 for a quick look at a narrow, well-defined role.
- 2,500 or 5,000 for broad roles, several places, or when the user wants as many people as
  possible. A bigger cap only lets the search read more; unused credits come back.
- Say the cap when you show the user the criteria ("reserves up to 1,000 credits; unused credits
  come back"), and get their yes before launching.

## What's left

`get_usage` / `revcenter usage`: `credits_remaining` (what a new search can reserve now), searches
running, requests today. Credits held by running searches aren't in `credits_remaining` until those
searches finish and give back what they didn't use.

## Buy more

`create_top_up` (opens Stripe checkout in the user's browser) or `revcenter topup`
(`--amount 3000` for $3,000; $1,500 to $30,000, default $1,500). It shows how many credits the
amount buys at the workspace's plan rate. Nothing is charged until the user pays on that page;
credits arrive as soon as they do. Confirm the amount with the user before creating the link.

`shortlist_allocation_exhausted`: not enough credits for that cap. Offer a smaller `max_credits`,
a top-up, or `database_only: true`.

`top_up_needs_plan`: the workspace has no plan; send the user to `details.billing_url`
(Settings → Plan & billing in Revcenter).
