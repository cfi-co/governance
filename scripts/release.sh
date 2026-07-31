#!/usr/bin/env bash
#
# Publish an adopted governance version: place, hash, sign, tag, anchor.
#
#   scripts/release.sh <version> <path-to-adopted-file> [--dry-run]
#
# Example:
#   scripts/release.sh 3.0 /root/governance-v3.0-review/governance-v3.0-adopted.md
#
# Refuses to run twice for the same version: a published version is never rewritten.
# --dry-run does everything except commit, tag, push and stamp, and prints what it would do.
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEY_FPR="B497BDC19FCD487972D5D2B0876FF2AA39133BF8"
OTS="${OTS:-/root/cfi-ots-venv/bin/ots}"
HASH_PAGE="https://cfi.co/governance/"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[ $# -ge 2 ] || die "usage: $0 <version> <path-to-adopted-file> [--dry-run]"
VERSION="$1"; SRC="$2"; DRY=0
[ "${3:-}" = "--dry-run" ] && DRY=1

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+$ ]] || die "version must look like 3.0, got '$VERSION'"
[ -f "$SRC" ] || die "source file not found: $SRC"
[ "${SRC##*.}" = "md" ] || die "source must be markdown (.md), got '${SRC##*.}'. \
The published form is text a reader can hash, diff and read without proprietary software. \
Export the adopted document to markdown first."

DEST="governance/governance-v${VERSION}.md"
cd "$REPO_ROOT"

[ -e "$DEST" ] && die "$DEST already exists. A published version is never rewritten. \
If this version was superseded, publish the next version instead."
git rev-parse -q --verify "refs/tags/v${VERSION}" >/dev/null 2>&1 \
    && die "tag v${VERSION} already exists"

# The key must be the published one, or the signature is worthless to a reader who
# checked _archive-key.cfi.co first.
gpg --list-secret-keys "$KEY_FPR" >/dev/null 2>&1 \
    || die "signing key $KEY_FPR not present in this keyring"

DNS_FPR="$(dig +short TXT _archive-key.cfi.co 2>/dev/null | tr -d '"' \
           | sed -n 's/.*cfi-archive-pgp-fpr=\([0-9A-F]*\).*/\1/p' | head -1)"
if [ -n "$DNS_FPR" ] && [ "$DNS_FPR" != "$KEY_FPR" ]; then
    die "published fingerprint at _archive-key.cfi.co ($DNS_FPR) does not match \
the signing key ($KEY_FPR). Fix the mismatch before publishing."
fi
[ -z "$DNS_FPR" ] && printf 'warning: could not read _archive-key.cfi.co; continuing\n' >&2

# Hash the source directly: a dry run must not write anything into the tree.
SHA="$(sha256sum "$SRC" | awk '{print $1}')"
DATE="$(date -u +%Y-%m-%d)"
BYTES="$(wc -c < "$SRC" | tr -d ' ')"

printf '\n  version   v%s\n  file      %s\n  bytes     %s\n  sha256    %s\n  date      %s (UTC)\n\n' \
    "$VERSION" "$DEST" "$BYTES" "$SHA" "$DATE"

TAGMSG="$(printf 'CFI.co governance v%s\n\nAdopted %s (UTC).\nFile: %s\nSHA-256: %s\n\nPublished hash: %s\nKey fingerprint: %s\n' \
    "$VERSION" "$DATE" "$DEST" "$SHA" "$HASH_PAGE" "$KEY_FPR")"

if [ "$DRY" = "1" ]; then
    printf 'DRY RUN — nothing written, committed, tagged, stamped or pushed.\n\n'
    printf 'Would place:   %s -> %s\n' "$SRC" "$DEST"
    printf 'Would append to MANIFEST.md:\n'
    printf '  | v%s | %s | %s | `%s` | `v%s` | OpenTimestamps + Internet Archive |\n' \
        "$VERSION" "$DATE" "$BYTES" "$SHA" "$VERSION"
    printf 'Would tag:     v%s (signed, %s)\n' "$VERSION" "$KEY_FPR"
    printf 'Would stamp:   %s  (OpenTimestamps -> %s.ots)\n' "$DEST" "$DEST"
    printf '\nTag message would be:\n---\n%s\n---\n' "$TAGMSG"
    printf '\nWould publish on %s:\n' "$HASH_PAGE"
    printf '  Governance v%s — adopted %s — SHA-256 %s\n\n' "$VERSION" "$DATE" "$SHA"
    exit 0
fi

cp "$SRC" "$DEST"

# MANIFEST is append-only in practice: new rows go on the end, old rows are never touched.
if [ ! -f MANIFEST.md ]; then
    cat > MANIFEST.md <<'HDR'
# Published versions

Every version of the CFI.co governance file published in this repository. Rows are added,
never edited or removed. See [VERIFY.md](VERIFY.md) for how to check any row.

| Version | Adopted (UTC) | Bytes | SHA-256 | Signed tag | Anchored |
|---|---|---|---|---|---|
HDR
fi
printf '| v%s | %s | %s | `%s` | `v%s` | OpenTimestamps + Internet Archive |\n' \
    "$VERSION" "$DATE" "$BYTES" "$SHA" "$VERSION" >> MANIFEST.md

git add "$DEST" MANIFEST.md
git commit -S -q -m "governance: publish v${VERSION} (sha256 ${SHA})"
git tag -s "v${VERSION}" -m "$TAGMSG"

# Anchor. OpenTimestamps first — the stamp covers the file's bytes, so it must be
# created from the exact published file and committed alongside it.
if [ -x "$OTS" ]; then
    "$OTS" stamp "$DEST" || printf 'warning: ots stamp failed; anchor by hand\n' >&2
    if [ -f "${DEST}.ots" ]; then
        git add "${DEST}.ots"
        git commit -S -q -m "governance: OpenTimestamps stamp for v${VERSION}"
    fi
else
    printf 'warning: %s not found; OpenTimestamps stamp NOT created\n' "$OTS" >&2
fi

git verify-commit HEAD >/dev/null 2>&1 && printf 'commit signature: OK\n'
git verify-tag "v${VERSION}" >/dev/null 2>&1 && printf 'tag signature:    OK\n'

cat <<EOF

Committed and tagged locally. Not pushed — push deliberately:

    git push origin main
    git push origin v${VERSION}

Then, in order:

  1. Publish the hash on ${HASH_PAGE}:
         Governance v${VERSION} — adopted ${DATE} — SHA-256 ${SHA}
  2. Capture that page: https://web.archive.org/save/${HASH_PAGE}
  3. In a few hours, upgrade the timestamp once it is in a block:
         ${OTS} upgrade ${DEST}.ots
     then commit and push the upgraded stamp.

EOF
