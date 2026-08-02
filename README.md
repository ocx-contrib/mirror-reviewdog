# mirror-reviewdog

OCX mirror for [reviewdog](https://github.com/reviewdog/reviewdog). One
repository, one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [reviewdog](https://github.com/reviewdog/reviewdog) | [`reviewdog/mirror.yml`](reviewdog/mirror.yml) | `ghcr.io/ocx-contrib/reviewdog/reviewdog` | `ocx.sh/reviewdog/reviewdog` | `MIT` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/reviewdog`. `reviewdog/reviewdog` is the grouped successor —
> upstream's owner is the GitHub org `reviewdog` and the tool is `reviewdog`,
> so namespace and name coincide.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
reviewdog/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`reviewdog` publishes six platform entries: both Linux arches, both macOS
arches and both Windows arches. Upstream builds reviewdog as a pure-Go binary
without cgo, so there is one Linux build per arch and it is **fully static** —
no `PT_INTERP`, no `DT_NEEDED`, and no musl/glibc variants to choose between.
`os.features` states what an artifact requires *of the host*, so both Linux
keys are **bare**: tagging them `+libc.musl` would be a false requirement that
hid them from every glibc host. The `alpine:3.20` container leg in
`mirror-base.yml` is what turns that claim into evidence; the measurement
itself is recorded above the `assets:` block in `reviewdog/mirror.yml`.

Upstream's 32-bit (`i386`) and `armv6` tarballs are deliberately not carried —
GitHub Actions has no runner for either.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `reviewdog/mirror.yml` | hand | yes — see below |
| `reviewdog/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `reviewdog/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec reviewdog/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

Upstream's tarball is **flat** — `LICENSE`, `README.md` and the `reviewdog`
executable sit at the archive root — so with `strip_components: 0` the
executable *is* the content root and the bundle's only PATH entry is a bare
`${installPath}`. `bin_scan` only looks *below* an `${installPath}/<dir>`
entry, so `auto`/`verify` is rejected at spec load with exit 65.
`mirror-base.yml` therefore sets `bin_scan: off` and
`reviewdog/metadata.json` hand-lists `binaries: ["reviewdog"]` — the blessed
shape for this archive shape.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).
