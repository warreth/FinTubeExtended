# FinTube Extended

> **⚠️ IMPORTANT WARNING**
>
> If you have the original **FinTube** plugin installed, you **MUST** uninstall it and restart your Jellyfin server before installing FinTube Extended. Failure to do so may cause conflicts.

Easily add content from YouTube to your Jellyfin installation. This is an extended fork of the original FinTube plugin.

![FinTube Logo](https://raw.githubusercontent.com/warreth/FinTubeExtended/master/Assets/logo.png)

## Dependencies

FinTube Extended requires [yt-dlp](https://github.com/yt-dlp/yt-dlp) (recommended) or YouTube-DL.
For full functionality (metadata tagging), [id3v2](https://sourceforge.net/projects/id3v2/) is also required.

### Installing Dependencies

**Debian/Ubuntu:**

```bash
sudo apt update
sudo apt install yt-dlp id3v2
```

**Arch Linux:**

```bash
sudo pacman -S yt-dlp id3v2
```

For other operating systems, please check your package manager or the official documentation for [yt-dlp](https://github.com/yt-dlp/yt-dlp).

## Installation

### 1. Add the Repository

1. Open your Jellyfin Dashboard and navigate to **Plugins**.
2. Click on the **Repositories** tab.
3. Click the **+** button to add a new repository.
4. Enter the following URL:

   ```text
   https://raw.githubusercontent.com/warreth/FinTubeExtended/master/manifest.json
   ```

5. Name it "FinTube Extended" (or whatever you prefer).

### 2. Install the Plugin

1. Switch to the **Catalog** tab.
2. Search for **FinTube** and click **Install**.
3. **Restart your Jellyfin Server** to apply changes.

## Configuration

1. Go to **Dashboard** > **Plugins** > **FinTube**.
2. Click on **Settings**.
3. Enter the path to your `yt-dlp` executable (e.g., `/usr/bin/yt-dlp`).
4. (Optional) Enter the path to your `id3v2` executable for better music tagging.
5. Save the configuration.

## Usage

Navigate to the **FinTube** page (usually found in the sidebar or under "My Media" depending on your client) to start importing content from YouTube.
