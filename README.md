# winu 🩵

Windows 11 inspired SDDM theme with Material You dynamic colors, video background support, and a declarative YAML configuration system with automatic synthesis and compositor wrapper fixing the "SDDM doesn't wake on TTY switch" issue

<div align="center">
  <table>
    <tr>
      <!-- Wallpaper source: https://r4.wallpaperflare.com/wallpaper/835/178/360/anime-vocaloid-hatsune-miku-luka-megurine-wallpaper-69c0382dc1aafd6ba6d798af40f106dd.jpg -->
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/3ba88a45-f3dd-4205-a7eb-01fde65951fd" /></td>
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/432389be-afaa-4c2a-84b8-09dde772aa75" /></td>
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/165ceeb3-a956-4e0c-8edb-d8999f7971a7" /></td>
    </tr>
    <tr>
      <!-- Wallpaper source: https://r4.wallpaperflare.com/wallpaper/109/363/694/hatsune-miku-anime-girls-vocaloid-wallpaper-38e6ed4840001c2800ec718ee8d2f43a.jpg -->
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/b2df0ac5-c571-46ab-a513-b554a72a3321" /></td>
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/c5d9b97e-b499-49f9-a093-8a51f70aac3f" /></td>
      <td><img width="1920" height="1080" src="https://github.com/user-attachments/assets/663f11a1-4edd-4176-bd17-a70c8538b41c" /></td>
    </tr>
    <tr>
      <td align="center">Clock screen</td>
      <td align="center">Login screen</td>
      <td align="center">Login spinner</td>
    </tr>
  </table>
</div>

## Quick start

```bash
git clone https://github.com/klapptnot/winu.git && cd winu

sudo bash winu setup # install selected dependencies and theme
sudo bash winu sync # synchronize your config
bash winu test # verify it is working
```

Set `Current=winu` in your SDDM theme configuration:

```ini
[Theme]
Current=winu
```

### `winu` Helper

The script uses a lightweight YAML parser written in Bash. If `yaml.sh` is missing, it is automatically fetched from [`klapptnot/kitsh`](https://github.com/klapptnot/kitsh) repository.
A configuration file can optionally be provided as the second argument; otherwise `~/.config/winu.yaml` is used if it can be resolved.

#### Commands

| Command | Description | Run as |
|:---|:---|:---|
| `setup` | Install dependencies and create theme root | root |
| `sync` | Synchronize configuration and assets | root |
| `test` | Launch SDDM greeter in a window | user |
| `help` | Show usage information | any |

## Config

`winu` uses a declarative YAML configuration to manage theme settings, assets, and dynamic color generation.
Create your configuration at `~/.config/winu.yaml`. During `sync`, the schema is validated and missing optional settings are populated with sensible defaults.

For a complete reference, see the example [`winu.yaml`](winu.yaml), which includes every available option:

* **Installation**: Theme installation path and optional setup settings
* **Dynamic theming**: `matugen` extracts color palettes from images and video frames
* **Compositor wrapper**: Automatically wakes SDDM after switching back to VT1 (Ctrl+Alt+F1)
* **Background carousel**: Rotates wallpapers at a configurable interval
* **Avatar generation**: Creates a default avatar that adapts to the current color palette
* **Fonts**: Configure the primary UI font and the required icon fonts

### Minimal configuration

The following is the minimum configuration required to synchronize the theme:

```yaml
installation:
  root: /usr/share/sddm/themes/winu
  # source: /path/to/winu # Only required by the `setup` subcommand

background:
  sources:
    - /path/to/wallpaper.jpg

fonts:
  primary: "Noto Sans"
  segoe_ui: "Segoe Fluent Icons"
  meiryo_boot: "Meiryo Boot"
```

All other settings are optional and default to sensible values when omitted.

### Required icon fonts

The theme needs two icon fonts **downloaded and installed manually** (not vendored):

| Font | Purpose | Config key |
|:---|:---|:---|
| [Segoe Fluent Icons](https://learn.microsoft.com/en-us/windows/apps/design/style/segoe-fluent-icons-font) | UI symbols, indicators | `.fonts.segoe_ui` |
| [Meiryo Boot](https://duckduckgo.com/?q=Meiryo+Boot+Font+Download) | Spinner animation | `.fonts.meiryo_boot` |

Install to `/usr/share/fonts/`, run `fc-cache -fv`, then set the **exact family name** in your config. `winu sync` validates before writing.
In case validation is not wished, disable it by setting `.fonts.trust_blindly` to `true`.

### Dependencies (`winu setup` may install them)

- Required:
  - `sddm`
  - `qt5-base`
  - `qt5-declarative`
  - `qt5-quickcontrols2`
  - `qt5-graphicaleffects`
  - `qt5-multimedia`
- Wayland Support (`wayland: true`)
  - `qt5-wayland`
- Optional Features (`optional_deps: true`)
  - `matugen`: Dynamic color generation
  - `ffmpeg`: Video frame extraction
  - `imagemagick`: Avatar generation
- Compositor Script (`compositor_deps: true` & `wayland: true`)
  - `dbus`: `SwitchToGreeter` D-Bus signal
  - `inotify-tools`: TTY monitoring
  - `procps-ng`: Process signaling
  - `util-linux`: Session management

---

<p align="center">Written QML/JS and pure bash. Stars visible at 25:00.</p>
