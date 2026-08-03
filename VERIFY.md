# Verifying a governance file

Four independent checks. Each one can be run without the others, and each fails on its own
terms. You do not have to trust CFI.co to run any of them.

The current published version is **Public Edition v1.0** (internal v3.0), adopted 1 August
2026. Its files are named `governance-public-edition-v1.0.*` and its tag is
`public-edition-v1.0`. Substitute the corresponding names for any later version.

The `.docx` is the adopted text and governs. The `.md` is a rendering of it for reading by
people and machines, published with its own hash; where they differ, the `.docx` governs and
the difference is a defect.

## 1. The file matches its published hash

```bash
sha256sum governance/governance-public-edition-v1.0.docx
sha256sum governance/governance-public-edition-v1.0.md
```

Compare the results against three places, which are maintained separately:

- `governance/MANIFEST.md` in this repository
- <https://cfi.co/governance/> — the version and hash page
- the tag message on `public-edition-v1.0` (see check 2)

If they disagree, the file you are holding is not the file that was published, or one of the
publication surfaces is stale. Either way, do not rely on it.

## 2. The signature is CFI.co's

Commits and tags in this repository are signed by the **publisher**, on the publisher's own
machine — not by any key held on a CFI.co server.

```bash
gpg --recv-keys 60AEC217836A905DCFED94F4097D7CA64028F174   # or import from cfi.co/archive/
git verify-tag public-edition-v1.0
git verify-commit public-edition-v1.0^{commit}
```

The fingerprint must be exactly:

```
60AE C217 836A 905D CFED  94F4 097D 7CA6 4028 F174
publisher@cfi.co · ed25519 · created 2026-07-30 · expires 2028-07-29
```

Confirm that fingerprint independently before trusting it:

```bash
dig +short TXT _archive-publisher.cfi.co
```

A signature that verifies against a key you got only from this repository proves nothing
useful. The DNS record and <https://cfi.co/archive/> are the second and third sources.

**Do not check a tag here against the Transparency Archive key.** A different key,
`B497 BDC1 9FCD 4879 72D5  D2B0 876F F2AA 3913 3BF8` (`archive@cfi.co`, anchored at
`_archive-key.cfi.co`), appears elsewhere in CFI.co's record and signs **nothing** in this
repository. That key sits on a CFI.co server and is driven by scheduled jobs; it signs release
manifests and daily archive automation. Releases here are signed off the estate, by a person.
The two keys are deliberately different, and a verifier who checks a tag here against the
archive fingerprint will get a mismatch and should. All four CFI.co keys, and which machine
each is held on, are listed at <https://cfi.co/archive/> and <https://cfi.co/governance/>.

**GitHub's green “Verified” badge is a convenience, not the check.** It appears because the
signing key is registered against a GitHub account, and it means GitHub verified the signature
for you. That is GitHub vouching for GitHub: it tells you nothing if GitHub is the party you
are trying not to rely on, and it would disappear if the key were ever unregistered, without
anything about the commit changing. The commands above are the check. Run them, and confirm
the fingerprint somewhere other than here.

## 3. The file existed on the date claimed

The OpenTimestamps proof covers `MANIFEST.sha256`, which carries the hash of every published
governance file. It is served from cfi.co rather than held in this repository:

```bash
curl -O https://cfi.co/archive-data/governance/MANIFEST.sha256
curl -O https://cfi.co/archive-data/governance/MANIFEST.sha256.ots
ots verify MANIFEST.sha256.ots -f MANIFEST.sha256
```

Check that the hash of the file you are holding appears in `MANIFEST.sha256`. That chains the
file to the timestamp: the manifest is stamped, and the manifest names the file's digest.

OpenTimestamps attests the digest into the Bitcoin blockchain. A successful verify tells you
the manifest existed no later than the block time it reports. It says nothing about who made
it or whether it is true — only that it is not backdated. Full verification reads the
blockchain, so it needs a Bitcoin node; without one, `ots` will still report the calendar
attestations it holds.

If the stamp is still `pending`, it has been submitted but not yet confirmed in a block.
Upgrade it and try again:

```bash
ots upgrade MANIFEST.sha256.ots
```

A detached signature over the same manifest, `MANIFEST.sha256.asc`, is published alongside it
and is made with the Transparency Archive key. It proves the manifest came from CFI.co; the
timestamp proves when. Neither is sufficient alone, which is why both are published.

## 4. A third party saw the same hash

The version and hash page on cfi.co is captured by the Internet Archive on adoption. Find the
capture dated on or near the adoption date:

<https://web.archive.org/web/*/https://cfi.co/governance/>
