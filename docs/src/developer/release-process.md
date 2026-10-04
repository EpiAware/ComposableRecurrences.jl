# [Release process](@id release-process)

Releases follow semantic versioning and are driven by the shared EpiAwarePackageTools workflows.

## Versions

- **Patch**: bug fixes and performance improvements.
- **Minor**: new operators, modifiers, couplings or keywords that keep existing calls working.
- **Major**: changes to an existing call or a removed public name.

`auto-version-increment.yaml` opens a pull request bumping the patch version after each merge to `main` that did not change the version.
A `/version major|minor|patch` comment on a pull request, from someone with write access, commits that increment to its branch instead.

## Registration

Comment `/register` on any issue or pull request, or run **Actions → Register → Run workflow**.
`Register.yml` then asks JuliaRegistrator to register `main`'s head in the General registry.
Once the registry pull request merges, TagBot creates the GitHub release and its notes, and the docs deploy for the new version.

## Before registering

- All CI passes, including the AD and documentation builds.
- New public names have docstrings, tests and a place in the documentation.
- The docs environment no longer pins EpiAwarePackageTools to its `main` branch.
