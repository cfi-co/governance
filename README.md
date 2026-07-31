# CFI.co Governance

This repository holds the governance file that CFI.co operates under, as adopted, one
version at a time, never rewritten.

CFI.co is published by Magnus Publications Limited, a company registered in England and
Wales (number 08420396).

## What is here

| Path | What it is |
|---|---|
| `governance/` | Each adopted version of the governance file, as adopted. |
| `MANIFEST.md` | Every published version: date, SHA-256, signed tag, anchor status. |
| `VERIFY.md` | How to check that what you are reading is what was published. |
| `scripts/release.sh` | The tool that publishes a version: hashes it, signs it, anchors it. |

## What is *not* here

**This repository is not a record export.** The two archive repositories —
[`cfi-co/articles`](https://github.com/cfi-co/articles) and
[`cfi-co/awards`](https://github.com/cfi-co/awards) — hold per-record JSON with a schema, a
`record_sha256` per record, and a `verify.sh` that checks the set. None of that machinery
applies here, and this repository does not claim it. A governance file is one document, and
it is verified as one document: by its hash, its signature, and its anchors.

## How a version is published

1. The file is adopted under its own adoption mechanics, signed by the principals.
2. It is committed here under `governance/`, and the commit is signed.
3. The commit is tagged `vN.N`, and the tag is signed.
4. The SHA-256 of the file is recorded in `MANIFEST.md` and published on cfi.co, so the two
   can be compared without trusting either one.
5. The file is timestamped with OpenTimestamps, and the cfi.co page carrying the hash is
   captured by the Internet Archive. Both anchors are outside CFI.co's control.

Superseded versions stay. A version is never edited after publication, and never removed. If
a version is superseded, the later version is added and `MANIFEST.md` records the succession.

## The signing key

Commits and tags here are signed with the CFI.co Transparency Archive key:

```
B497 BDC1 9FCD 4879 72D5  D2B0 876F F2AA 3913 3BF8
archive@cfi.co · ed25519 · created 2026-07-10
```

The same fingerprint is published in DNS at `_archive-key.cfi.co` and on
<https://cfi.co/archive/>. Check it in both places before trusting a signature here.

## What verification proves, and what it does not

It proves that a file you hold is byte-identical to the one whose hash was published and
timestamped, and that it was signed by the holder of the key above.

It does **not** prove that this repository's history has never been rewritten. Git history is
append-only by convention, on a repository its custodian administers, not by construction.
That is what the OpenTimestamps and Internet Archive anchors are for: they are held by parties
CFI.co does not control, and a rewritten history would no longer match them.

See [`VERIFY.md`](VERIFY.md) for the commands.

## Status

**No version is published here yet.** Governance v2.0 (2 July 2026) is the version in force
and has not been published to this repository. Governance v3.0 is drafted and unadopted; an
unadopted draft is not published here, because publishing a draft as though it governed
anything is the failure this file exists to prevent.

This repository exists and is named ahead of adoption so that the address in the governance
file's adoption block is fixed and stable before it is signed.
