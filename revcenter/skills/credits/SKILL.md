---
name: credits
description: Revcenter shortlist credits — what's left, what costs a credit, and buying more from the terminal (Stripe checkout). Use for "how many credits", "what does this cost", out-of-credit errors (shortlist_allocation_exhausted, no_active_plan), or "top up".
---

# Credits

Revcenter meters in **shortlist credits**, the same ones the Revcenter app uses (plan plus top-ups).

| Uses 1 credit | Free |
| --- | --- |
| Launching a search | Reading anything |
| Expanding a search | Re-scoring, editing shortlists |
| | Exports, the candidate database |
| | `database_only` searches |

A search that fails to start gives its credit back. Repeating a launch never charges twice.

## What's left

`get_usage` / `revcenter usage`: credits remaining, searches running, requests today.

## Buy more

`create_top_up` (opens Stripe checkout in the user's browser) or `revcenter topup`
(`--amount 3000` for $3,000; $1,500 to $30,000, default $1,500). It shows how many credits the
amount buys at the workspace's plan rate. Nothing is charged until the user pays on that page;
credits arrive as soon as they do. Confirm the amount with the user before creating the link.

`top_up_needs_plan`: the workspace has no plan; send the user to `details.billing_url`
(Settings → Plan & billing in Revcenter).
