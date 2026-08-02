# NOTICE

This repository packages and redistributes upstream software published by the
[reviewdog](https://github.com/reviewdog) organisation. The Apache-2.0 license
in [`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `reviewdog` | `ghcr.io/ocx-contrib/reviewdog/reviewdog` | `MIT` |

---

## `reviewdog`

Upstream: <https://github.com/reviewdog/reviewdog>
Published to `ghcr.io/ocx-contrib/reviewdog/reviewdog`.

| Component | SPDX | Holder |
|---|---|---|
| reviewdog (`reviewdog`) | **MIT** | Copyright (c) 2016 haya14busa and the reviewdog contributors |

Permissive; redistribution of the compiled binary is granted provided the
copyright notice and permission notice are retained. Upstream's release
tarballs ship their own `LICENSE` file alongside the executable, and it is
republished with it; the terms are those of
<https://github.com/reviewdog/reviewdog/blob/master/LICENSE>. The published
binaries statically link third-party Go modules under permissive licenses,
enumerated in upstream's `go.mod`.

The reviewdog name is used for catalog identification under nominative fair
use. The logo shipped with this package is an OCX-authored lettermark, not an
official reviewdog mark.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
