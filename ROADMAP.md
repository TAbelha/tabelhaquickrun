# Roadmap

Open items after the `v1.0.0` initial release.

- [ ] **Registry submission.** DMS has an official plugin registry/marketplace
  ([dms-plugin-registry](https://github.com/AvengeMedia/dms-plugin-registry)).
  Deliberately not submitted yet — decide whether to open that PR, and if so,
  make sure the plugin is positioned as fish-specific rather than a generic
  command runner (see README's "Why not just use a generic command runner?").
- [ ] **Screenshot.** README has no screenshot/GIF of the launcher matching in
  action — add one (`screenshot.png`, matching the convention in sibling
  TAbelha repos).
- [ ] **Retire the old zenity fallback.** `~/.config/niri/scripts/quick-run.sh`
  (the pre-plugin zenity-based implementation) is left in place, unreferenced,
  as a rollback path. Once this plugin has proven itself for a while, delete
  it and the reference in niri's bind history.
- [ ] **Consider abbreviation expansion depth.** `executeItem` currently runs
  an abbreviation's expansion verbatim (`abbr --show` output). If an
  abbreviation itself expands to another abbreviation/function call, this
  isn't tested — verify nested expansion behaves as expected.
