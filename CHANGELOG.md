# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-08-23

### Added

- Launcher plugin: type a command and run it via `fish -lc`.
- Live suggestions matched against `functions -n`/`abbr --show` (exact →
  prefix → substring), each showing the function's source file or the
  abbreviation's expansion.
- Configurable trigger character and max suggestion count via
  Settings → Plugins → Quick Run.
