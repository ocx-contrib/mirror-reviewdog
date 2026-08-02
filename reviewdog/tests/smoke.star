# tests/smoke.star — stable across upstream reviewdog releases.
# Asserts the contract (exit code, version shape, parse/report behavior),
# never help/version prose. See ocx.mirror testing-practices.md.

REVIEWDOG = "reviewdog.exe" if ocx.target_platform.os == ocx.os.Windows else "reviewdog"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE. The digits are
# the contract — not the vendor banner, not the exact version.
r_version = ocx.run(REVIEWDOG, "-version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: parse a diagnostic from stdin via errorformat and report it with
# the local reporter. -filter-mode=nofilter keeps it hermetic (no git diff
# needed). Assert the injected token round-trips — a computed result, not
# prose.
ocx.write_file("hello.txt", "hello\nworld\n")
r_parse = ocx.run(
    REVIEWDOG,
    "-efm=%f:%l:%c: %m",
    "-reporter=local",
    "-filter-mode=nofilter",
    stdin="hello.txt:1:1: finding-token-xyz\n",
)
expect.ok(r_parse)
expect.contains(r_parse.stdout, "finding-token-xyz")

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).
