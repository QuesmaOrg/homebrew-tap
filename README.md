# Quesma Homebrew tap

## Quesma Shipper

The first shipper release containing Homebrew support must publish before this command is available:

```sh
brew install --cask quesmaorg/tap/quesma-shipper
```

Then run the login command from your Quesma dashboard. The background service starts automatically
and waits for enrollment. macOS 13 or newer, on Apple Silicon or Intel, is supported. With Homebrew
already installed, the shipper installation needs no administrator rights.

```sh
brew upgrade --cask quesmaorg/tap/quesma-shipper
brew uninstall --cask quesmaorg/tap/quesma-shipper
```

Homebrew owns updates; this installation does not self-update. Uninstall stops the service and keeps
enrollment and upload history. Reinstallation resumes the same machine.

If you installed the `.pkg` first, run that installation's `quesma-shipper uninstall` without
`--purge` before installing through Brew. Likewise, uninstall the cask before switching back to `.pkg`.
The service refuses to silently replace an installation owned by another method.

## Release updates

The shipper release workflow attaches `quesma-shipper.rb` to each GitHub release, pinned to the SHA-256
of the signed and notarized binaries already published at `updates.quesma.dev`. The workflow here
checks hourly and commits that cask to `main`. Run **Update Quesma Shipper** manually to import a
release sooner. Older release definitions cannot downgrade the tap.

Enable GitHub Actions and allow its `GITHUB_TOKEN` to write repository contents. No additional secret
or write access to the shipper repository is needed. Branch protection must permit this bot's pushes
to `main`. Before the first compatible shipper release, the workflow exits without creating a cask.

The legacy `git-prompt-story.rb` formula remains available and unchanged.
