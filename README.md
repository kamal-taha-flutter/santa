# Santa — إدارة بيانات الأنشطة التجارية

A Flutter Linux desktop application for registering and managing business
activity records. The interface is Arabic and right-to-left, with local SQLite
storage and Excel export. The visual identity (blue `#006AA1`, orange
`#F58634`, green `#A8CF45`) is derived from the supplied SANTAA logo.

## Features

- Create, edit, delete, and search business registrations.
- Required-field validation with inline errors and accessible focus states.
- Conditional farm-area field (`مساحة المزرعة`) with `فدان` / `أكر` units when
  the activity type is `مزرعة`.
- Records workspace with live search, result counts, empty, loading, and error
  states.
- Export all records to a formatted `.xlsx` workbook through the native save
  dialog. Export always reads the database, not the filtered table.
- Responsive shell: a branded sidebar on wide windows and compact top
  navigation on narrow ones.
- Local-only storage. No network access or account is required.

## Requirements

- Flutter with Linux desktop support (built with Flutter 3.47.x / Dart 3.13).
- Linux build tools: `clang`, `cmake`, `ninja-build`, `pkg-config`,
  `libgtk-3-dev`, and `libx11-dev`.
- Optional: `fonts-noto-core` / `fonts-noto-arabic` for the preferred Noto
  Sans Arabic and Noto Kufi Arabic typography. The app falls back to installed
  system fonts when they are unavailable.

## Run

```bash
flutter pub get
flutter run -d linux
```

The SQLite database is created on first launch at:

```text
~/.local/share/com.example.santa/registrations.db
```

When `XDG_DATA_HOME` is set, the file lives under
`$XDG_DATA_HOME/com.example.santa/`. Existing version-1 databases are upgraded
in place with the farm-area columns; no manual migration is needed.

## Quality checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build linux --release
```

## Release bundle

```bash
flutter build linux --release
./build/linux/x64/release/bundle/santa
```

The bundle is relocatable and contains the executable, Flutter assets, the
desktop entry, and hicolor icons:

```text
build/linux/x64/release/bundle/
├── santa
├── data/
├── lib/
└── share/
    ├── applications/com.example.santa.desktop
    ├── icons/hicolor/<size>/apps/santa.png
    └── pixmaps/santa.png
```

The window icon is also published as `_NET_WM_ICON` at runtime from the
bundled 256 px artwork (scaled to 128 px to stay within the X11 request
limit), so taskbars and window switchers show the branded icon on both X11
and XWayland.

### Install the launcher for the current user

The desktop integration files become active only when they are installed
into the standard XDG directories. After building:

```bash
APP_DIR="$HOME/.local/opt/santa"
mkdir -p "$APP_DIR" "$HOME/.local/bin" "$HOME/.local/share/applications"
cp -a build/linux/x64/release/bundle/. "$APP_DIR/"
ln -sf "$APP_DIR/santa" "$HOME/.local/bin/santa"
cp "$APP_DIR/share/applications/com.example.santa.desktop" \
  "$HOME/.local/share/applications/"
cp -a "$APP_DIR/share/icons/hicolor/." "$HOME/.local/share/icons/hicolor/"
cp "$APP_DIR/share/pixmaps/santa.png" "$HOME/.local/share/pixmaps/"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
```

`~/.local/bin` must be on `PATH` because the desktop entry uses `Exec=santa`.
If it is not, replace the `Exec=` line with the absolute path to
`$APP_DIR/santa`. The launcher then appears in the desktop application menu;
under Wayland the compositor resolves the icon through the desktop entry and
`StartupWMClass=com.example.santa`.

## Branding assets

| File | Purpose |
| --- | --- |
| `assets/لوجو.png` | Original supplied artwork, never modified |
| `assets/branding/santa_mark.png` | Transparent emblem for compact UI use |
| `assets/branding/santa_logo.png` | Transparent full lockup |
| `assets/branding/app_icon.png` | 1024 px rounded launcher tile |
| `assets/branding/app_icon_256.png` | Runtime window/taskbar icon |
| `linux/icons/hicolor/*/apps/santa.png` | Installed icon-theme sizes |

Regenerate the derived assets only when the source logo changes:

```bash
python3 -m pip install pillow
python3 tool/generate_brand_assets.py
```

The generated PNGs are committed, so a normal build does not need Python or
Pillow. Theme tokens live in `lib/app/theme/app_colors.dart`,
`app_dimens.dart`, and `app_theme.dart`.

## Project layout

```text
lib/
├── app/        # shell, theme tokens, bootstrap
├── core/       # shared strings, errors, widgets
└── features/
    ├── registrations/  # domain, data, presentation for records
    └── export/         # Excel generation and save workflow
```

The registrations feature follows Clean Architecture: entities and use cases
in `domain/`, SQLite models/data sources in `data/`, and Cubits/pages/widgets
in `presentation/`.
