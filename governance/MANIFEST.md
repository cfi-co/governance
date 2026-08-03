# MANIFEST — CFI.co Governance, Public Edition v1.0 (internal v3.0)

Adopted 1 August 2026.

## What is published here, and which one governs

| file | SHA-256 | what it is |
|---|---|---|
| `governance-public-edition-v1.0.docx` | `6829072874467AB111D4A68C3A1D36FF111E5ACA52501B2EB13E287130B567CB` | **the adopted text.** This is the file both principals put their names to. |
| `governance-public-edition-v1.0.md` | `ECB54D801065DCB2E4CF398E7FD1A08C0387FC42BF009ED6943D37DC88901938` | a rendering of the above, for reading by people and machines. Not a second version. |
| `step2-agreement.txt.asc` | `E7180A7E6F91AC9CDBA1F089A053D319AA459056800A3E892DE433C2CC9F1445` | a principal's signed agreement to the adoption, over the `.docx` hash. |

Where the rendering and the `.docx` differ, the `.docx` governs and the difference is a
defect to be corrected. The `.docx` was hashed as supplied; a Word file is a zip archive
whose bytes change on every save, so that number identifies this file rather than being
reproducible from the text. That is why the rendering carries its own hash: it is the
artefact a reader can regenerate and compare.

The hash recorded for the signed statement is the hash of the file **as stored in this
repository**. It was corrected on 1 August 2026, within the hour of publication. The statement
was signed on a Windows machine and carried CRLF line endings; git normalised them to LF when
it was committed, which moved the file's hash without altering a character of its content. The
first manifest published the pre-normalisation number, which no reader could have reproduced
from the file served here. The signature itself was never affected — OpenPGP canonicalises line
endings before hashing the text, so it verifies against either form — and `.gitattributes` now
stops signed files being normalised in future.

## Checking it yourself

    sha256sum governance-public-edition-v1.0.docx
    sha256sum governance-public-edition-v1.0.md
    gpg --verify step2-agreement.txt.asc

The third command needs the signing key. It is published in two places maintained
separately, so that neither CFI.co alone nor a keyserver alone is the source of truth:

    dig +short TXT _principal-mark.cfi.co
    https://keys.openpgp.org/vks/v1/by-fingerprint/C5FD92210CCF0D31271EA4BC6B681CAAA8BAA1FE

## Keys, and where each one lives

| fingerprint | identity | custody |
|---|---|---|
| `C5FD92210CCF0D31271EA4BC6B681CAAA8BAA1FE` | Marten Mark `<mma@cfi.co>` | held by the principal personally, on a machine CFI.co does not operate |
| `60AEC217836A905DCFED94F4097D7CA64028F174` | CFI.co Publisher Counter-Signature `<publisher@cfi.co>` | held by the publisher; not on any CFI.co server |
| `DAA22F2408ADD091E9D800B36046432BC2896172` | CFI.co Archive Custodian `<custodian@cfi.co>` | held by the custodian personally, on a machine CFI.co does not operate |
| `B497BDC19FCD487972D5D2B0876FF2AA39133BF8` | CFI.co Transparency Archive `<archive@cfi.co>` | on the CFI.co server, driven by scheduled jobs; the key is not passphrase-protected, so its signature attests to the estate rather than to any person |

The distinction is deliberate. One of these keys sits on a CFI.co server and can be operated
by automation; the other three are held by people, on machines CFI.co does not operate. Two of
those three — the principal key and the custodian key — are in the same principal's custody.
Four keys, two people, one server. A reader who wants to know whether something was produced
by a single actor can establish it from the signatures rather than being told.

## How adoption was entered

The adoption block records that the publisher signed on 1 August 2026, and that the second
principal's name was entered by the publisher on that principal's written authority of the
same date. That is stated in the file itself rather than disclosed here for the first time.
`step2-agreement.txt.asc` is that written authority, signed under a key the publisher does
not hold, so the part of the record that rests on one person's account of another's agreement
can be checked independently.

The signed statement says in terms what it does and does not prove. It is not offered as
evidence that two people independently exercised judgement.

## Not yet done, and dated

The commencement schedule inside the file lists every provision that depends on a published
artefact, with a deadline for each. Four commence on adoption because their artefact already
exists. The rest carry dates between 3 August and 30 October 2026. Nothing in that schedule is
blank except the Commenced column, which cannot be completed inside a file at the moment that
file is hashed.

The known-open register at https://cfi.co/known-open/ records what CFI.co has found wrong in
its own published claims, including four entries added on the day of adoption.
