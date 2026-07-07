# Evaluating a skill

The `description` is the only thing that decides whether a skill auto-triggers, and
triggering is probabilistic — you can't tell from *reading* it whether it fires
reliably. Measure it. (Method distilled from `anthropics/skills`' `skill-creator`,
adapted for lightweight manual use — see the note at the end for its full harness.)

## 1. Write test prompts

2–3 realistic prompts a real user would actually type. Include **near-misses** —
prompts that should NOT trigger this skill — not just ones that should. Near-misses
catch an over-eager description.

## 2. Trigger check (the important one)

Run each prompt in a **fresh session** and see whether the skill auto-invokes.
Because triggering varies run-to-run, repeat each prompt a few times:

- Fires 3/3 on should-trigger prompts and 0/3 on near-misses → description is well-tuned.
- Inconsistent firing → the description is fuzzy. Tighten or broaden the `Use when`
  triggers and re-run. That run-it-N-times spread is the "variance" signal.

## 3. Behavior check

For prompts that do trigger, judge the output:

- **Subjective** skills (writing, design) → eyeball it qualitatively.
- **Checkable** skills → write objectively-verifiable, named assertions (e.g. "commit
  message starts with a conventional prefix", "no attribution footer") and check each.

## 4. Optimize the description, then iterate

If triggering is off, the fix is almost always the **description**, not the body —
adjust trigger phrases and the `Use when` clause, change one thing at a time, and
re-measure. Once stable, expand the prompt set and repeat at larger scale.

## If you want automation

`skill-creator` (`anthropics/skills`) has a full Python harness for this: `run_eval.py`
to run prompts, an LLM-judge grader agent, `aggregate_benchmark.py` for variance across
repeated runs, and `improve_description.py` to auto-tune triggering. This file distills
its method for manual use; reach for that harness if you need large-scale, repeatable
benchmarking.
