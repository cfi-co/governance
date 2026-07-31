# Verifying a governance file

Four independent checks. Each one can be run without the others, and each fails on its own
terms. You do not have to trust CFI.co to run any of them.

Replace `3.0` with the version you are checking.

## 1. The file matches its published hash

```bash
sha256sum governance/governance-v3.0.md
```

Compare the result against three places, which are maintained separately:

- `MANIFEST.md` in this repository
- <https://cfi.co/governance/> — the version and hash page
- the tag message on `v3.0` (see check 2)

If they disagree, the file you are holding is not the file that was published, or one of the
publication surfaces is stale. Either way, do not rely on it.

## 2. The signature is CFI.co's

```bash
gpg --recv-keys B497BDC19FCD487972D5D2B0876FF2AA39133BF8   # or import from cfi.co/archive/
git verify-tag v3.0
git verify-commit v3.0^{commit}
```

The fingerprint must be exactly:

```
B497 BDC1 9FCD 4879 72D5  D2B0 876F F2AA 3913 3BF8
```

Confirm that fingerprint independently before trusting it:

```bash
dig +short TXT _archive-key.cfi.co
```

A signature that verifies against a key you got only from this repository proves nothing
useful. The DNS record and <https://cfi.co/archive/> are the second and third sources.

## 3. The file existed on the date claimed

```bash
ots verify governance/governance-v3.0.md.ots -f governance/governance-v3.0.md
```

OpenTimestamps attests the file's digest into the Bitcoin blockchain. A successful verify
tells you the file existed no later than the block time it reports. It says nothing about who
made it or whether it is true — only that it is not backdated.

If the stamp is still `pending`, it has been submitted but not yet confirmed in a block.
Upgrade it and try again:

```bash
ots upgrade governance/governance-v3.0.md.ots
```

## 4. A third party saw the same hash

The version and hash page on cfi.co is captured by the Internet Archive on adoption. Find the
capture dated on or near the adoption date:

<https://web.archive.org/web/*/https://cfi.co/governance/>

The hash in that capture should equal the hash you computed in check 1. This is the check
that survives CFI.co rewriting its own site: the capture is held by someone else.

## What a full pass means

That the document you are reading is byte-for-byte the document CFI.co published, that CFI.co
signed it, that it is not backdated, and that an independent archive recorded the same hash at
the time.

## What it does not mean

It does not mean the repository's history has never been rewritten. Git history is append-only
by convention, on a repository CFI.co administers, not by construction. Checks 3 and 4 are the
answer to that: both are held by parties outside CFI.co's control, and a rewritten history
would stop matching them.

It also does not mean the file is being complied with. Verification is about the text, not the
conduct.

## Reporting a discrepancy

If any check fails, or the surfaces disagree, say so publicly and tell CFI.co via
<https://cfi.co>. A discrepancy that is real should be visible in the known-open register at
<https://cfi.co/known-open/> once it is acknowledged.
