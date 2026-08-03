# CFI.co Governance

This repository holds the governance file that CFI.co operates under, as adopted, one
version at a time, never rewritten.

CFI.co is published by Magnus Publications Limited, a company registered in England and
Wales (number 08420396).

## What is here

| Path | What it is |
|---|---|
| `governance/` | Each adopted version of the governance file, as adopted. |
| `governance/MANIFEST.md` | Every published version: date, SHA-256, signed tag, anchor status. |
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
3. The commit is tagged after the edition — `public-edition-v1.0` for the current one — and the tag is signed.
4. The SHA-256 of the file is recorded in `MANIFEST.md` and published on cfi.co, so the two
   can be compared without trusting either one.
5. The file is timestamped with OpenTimestamps, and the cfi.co page carrying the hash is
   captured by the Internet Archive. Both anchors are outside CFI.co's control.

Superseded versions stay. When a version is superseded the later version is added alongside it,
and `MANIFEST.md` records the succession.

Rather than promise that a published version is never edited or removed, here is what would
have to fail for that to happen without you noticing. Force-pushes and branch deletions are
blocked on `main`. Each published version carries a signed tag, and its SHA-256 is recorded in
three places maintained separately — `MANIFEST.md`, the tag message, and the hash page on
cfi.co. The file is timestamped with OpenTimestamps and the hash page is captured by the
Internet Archive, both held by parties CFI.co does not control. A rewritten history would stop
matching them. That is a weaker sentence than "never", and a stronger guarantee, because you can
check it yourself.

## The signing key

Commits and tags here are signed by the publisher, on the publisher's own machine, with the
CFI.co Publisher Counter-Signature key:

```
60AE C217 836A 905D CFED  94F4 097D 7CA6 4028 F174
publisher@cfi.co · ed25519 · created 2026-07-30 · expires 2028-07-29
```

The same fingerprint is published in DNS at `_archive-publisher.cfi.co` and on
<https://cfi.co/archive/>. Check it in both places before trusting a signature here.

A second key signs elsewhere in CFI.co's record and signs **nothing** in this repository: the
CFI.co Transparency Archive key, `B497 BDC1 9FCD 4879 72D5  D2B0 876F F2AA 3913 3BF8`
(`archive@cfi.co`, anchored at `_archive-key.cfi.co`). It sits on a CFI.co server and is
driven by scheduled jobs; it signs release manifests and the daily archive automation. Nothing
published here is signed by a key CFI.co's own machines hold, and that separation is the point.
A verifier who checks a tag in this repository against the archive fingerprint will get a
mismatch, and should.

All four keys in CFI.co's record, and which machine each is held on, are listed at
<https://cfi.co/archive/> and in the custody table at <https://cfi.co/governance/>.

## What verification proves, and what it does not

It proves that a file you hold is byte-identical to the one whose hash was published and
timestamped, and that it was signed by the holder of the key above.

It does **not** prove that this repository's history has never been rewritten. Git history is
append-only by convention, on a repository its custodian administers, not by construction.
That is what the OpenTimestamps and Internet Archive anchors are for: they are held by parties
CFI.co does not control, and a rewritten history would no longer match them.

See [`VERIFY.md`](VERIFY.md) for the commands.

## Status

**Public Edition v1.0 (internal v3.0) is published here**, adopted 1 August 2026. It is the
first governance file CFI.co has published. Versions 1.0 and 2.0, both adopted 2 July 2026,
were internal; this edition supersedes them and is published in full.

The adopted text is `governance/governance-public-edition-v1.0.docx`, SHA-256
`6829072874467AB111D4A68C3A1D36FF111E5ACA52501B2EB13E287130B567CB`. A Markdown rendering is
published beside it for reading by people and machines; where the two differ, the `.docx`
governs. Both hashes are recorded in `governance/MANIFEST.md` and carried by the signed tag.

One principal's agreement is published as a separately signed statement,
`governance/step2-agreement.txt.asc`, under a key held by that principal personally and
present on no CFI.co server. Adoption was entered by the publisher on behalf of both
signatories; that statement is the part of the record which can be verified without relying
on our account of it.
