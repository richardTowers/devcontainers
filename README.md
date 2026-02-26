# Dev Container Features

Personal dev container features for [richardTowers](https://github.com/richardTowers).

## Features

### Claude Code CLI

Installs the [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
using the native installer — no Node.js dependency required.

#### Usage

Add to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/richardTowers/devcontainers/claude-code:1": {}
    }
}
```

#### Options

| Option    | Default    | Description                                                        |
|-----------|------------|--------------------------------------------------------------------|
| `version` | `"latest"` | Version to install: `"latest"`, `"stable"`, or a semver like `"1.0.58"` |

#### Example with pinned version

```json
{
    "features": {
        "ghcr.io/richardTowers/devcontainers/claude-code:1": {
            "version": "stable"
        }
    }
}
```

## Adding new features

1. Create a new directory under `src/` with a `devcontainer-feature.json` and `install.sh`.
2. Add tests under `test/<feature-name>/test.sh`.
3. Update the test matrix in `.github/workflows/test.yaml`.
4. Run the release workflow to publish to GHCR.

See the [dev container feature spec](https://containers.dev/implementors/features/) for details.
