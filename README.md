<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset=".github/assets/salko-lockup-dark.svg">
    <img alt="Salko" src=".github/assets/salko-lockup.svg" width="300">
  </picture>
</p>

<h1 align="center">Merge faster. Break less.</h1>

<p align="center">
  A merge-risk gate for the pull requests your coding agents open.<br>
  It blocks the changes that have broken you before, and says nothing about the rest.
</p>

<p align="center">
  <a href="https://salko.dev"><b>salko.dev</b></a> ·
  <a href="https://cal.com/salko/30min">Book a call</a> ·
  <a href="#private-beta">Request access</a>
</p>

<p align="center">
  <img alt="Status: private beta" src="https://img.shields.io/badge/status-private%20beta-E8A33D?style=flat-square">
  <img alt="Reviews agent PRs" src="https://img.shields.io/badge/reviews-agent%20PRs-171B24?style=flat-square">
</p>

---

AI made writing code cheap. It made reading it expensive.

Your agents open more pull requests than your team can meaningfully read. The
existing review tools respond by commenting more, which is the opposite of what
you need. Salko reviews what your agents ship, blocks the changes that resemble
something that has already broken your production, and stays quiet everywhere
else.

```
   ]·*·······[      ]·········[      ]··*······[
    PULL REQUEST      PRODUCTION       RISK MEMORY
   ]·········[      ]····!····[      ]·*·······[

        review  ->  merge  ->  incident  ->  learn
```

## What it looks like

```
┌──────────────────────────────────────────────────────────────┐
│ PR #2841 · retry on 402 · opened by @agent           SALKO    │
├──────────────────────────────────────────────────────────────┤
│ [ BLOCKING ]                                                 │
│                                                              │
│ 1 │ Touches PaymentRetryQueue.                               │
│ 2 │ This file caused INC-284 on 14 Mar, an unbounded         │
│ 3 │ retry loop that took checkout down for 41 minutes.       │
│ 4 │                                                          │
│ 5 │ Your change adds a retry with no ceiling.                │
│                                                              │
│ └─ 3 prior failures in this file · 1 other comment suppressed │
└──────────────────────────────────────────────────────────────┘
```

Illustrative. The incident references come from your own history, not ours.

## An agent's mistake looks like senior work

Correct naming. Idiomatic structure. A confident commit message. Tests that
pass. Wrapped around a missing authorization check.

Your review process was built for code a human wrote and can explain. That
assumption no longer holds.

| | |
|---|---|
| **1 in 5** | code reviews on GitHub now involve an agent |
| **5.3x** | longer an agent's PR waits for a human to pick it up |
| **81%** | of engineering leaders report more production issues from AI-generated code, while 92% believed it was ready to ship |

## How it works

**1. Reviews the PR.** Applies each suggested fix and syntax-checks it before
posting a word, so what you see has at least been proven to compile.

**2. Learns what hurts.** Reads your repository's own history of reverts,
hotfixes and repeatedly-broken files to build a risk map. Incident tooling
connects on top of that.

**3. Blocks or shuts up.** Risk is scored from your history, not a global
threshold. When it blocks, it names the incident it learned from.

## What it won't do

- **Nitpick your formatting.** That is what your linter is for.
- **Comment on every file.** Most diffs get nothing. That is the point.
- **Guess at severity.** If it has not hurt you before, it does not block you.
- **Train on your code.** Your repository is never used to train a model.

## Connects to

| | |
|---|---|
| **Code** | GitHub · GitLab · Bitbucket · Azure Repos |
| **Incidents** | Sentry · PagerDuty · Linear |
| **Agents** | Claude Code · Codex · Cursor · Devin · Copilot agents |

## Status

Salko is in private beta and is not finished. Being straight about where the
line sits:

| | |
|---|---|
| Review pipeline, with apply-and-syntax-check validation | Working |
| Risk map from repository history | In progress |
| Incident-tool correlation | Not built |
| Blocking with a cited incident | Not built |

If you need a polished product with a signed MSA this quarter, this is not it
yet. If you want to shape what it becomes, that is exactly what the beta is
for.

## FAQ

**How is this different from CodeRabbit or Greptile?**
They score themselves on how many issues they find in a diff. Salko is built to
be judged on whether the thing it stopped was worth stopping. Different metric,
different behaviour.

**What happens on day one, before it knows anything?**
It reads your git history. Reverts, hotfixes and files that keep breaking give
it a risk map before a single incident is recorded.

**Do you store our code?**
No. Code is pulled for the duration of a review and discarded. We keep review
decisions, not source.

**How much noise should we expect?**
Most pull requests get nothing at all. Salko is built to stay quiet unless a
change resembles one that has already caused you a problem.

**Is it ready?**
No. See [Status](#status).

## Private beta

Limited seats, and we are letting teams in a few at a time.

- **Request access** — [salko.dev](https://salko.dev)
- **Talk to us first** — [30 minutes](https://cal.com/salko/30min), no deck

The call is to understand how your team reviews agent-authored pull requests
today and whether this is worth finishing. If it is not a fit, we will say so.

---

<p align="center">
  <a href="https://salko.dev">salko.dev</a>
</p>
