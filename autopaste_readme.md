# ⚡ AutoPaste

A powerful and customizable AutoHotkey script for automating repetitive text pasting. Perfect for Roblox AFK farming, chat automation, and any task requiring repeated text input.

## ✨ Features

- ⏱️ **Customizable Interval** - Set any delay between pastes (in seconds)
- 📋 **Two Paste Modes** - Use clipboard (Ctrl+V) or type custom text
- 🎮 **Chat Button Support** - Configurable prefix (default `/` for Roblox)
- 🔢 **Paste Limits** - Auto-stop after a set number of pastes
- 🎨 **Customizable UI** - Toggle countdown timer and paste counter
- ⌨️ **Configurable Hotkeys** - Set your own keys for toggle, exit, and config
- 💾 **Persistent Settings** - All settings saved to INI file
- 🪟 **Clean Status Window** - Minimal, always-on-top display

## 🚀 Quick Start

1. Download `AutoPaste.exe` from [Releases](../../releases)
2. Run the executable
3. Press **F10** to open configuration
4. Set your preferences
5. Press **F8** to start/stop

## ⌨️ Default Hotkeys

| Key | Action |
|-----|--------|
| **F8** | Toggle timer ON/OFF |
| **F9** | Exit script |
| **F10** | Open configuration window |

## ⚙️ Configuration Options

### Basic Settings
- **Interval (seconds)** - Time between each paste (default: 60)
- **Max Pastes** - Stop after X pastes (0 = unlimited)

### Paste Settings
- **Chat Button** - Character sent before paste (default: `/`)
  - Use `/` for Roblox
  - Use `t` for other games
  - Leave empty for no prefix
- **Use Clipboard** - Enable to use Ctrl+V (1 = yes, 0 = no)
- **Text to Type** - Custom text to paste (ignored if clipboard enabled)

### UI Settings
- **Show UI** - Display status window (1 = yes, 0 = no)
- **Show Countdown** - Display timer countdown (1 = yes, 0 = no)
- **Show Paste Counter** - Display paste count (1 = yes, 0 = no)

### Advanced Settings
- **Use SendInput** - Faster input method (1 = yes, 0 = no)
- **Toggle/Exit/Config Keys** - Customize hotkeys

## 📖 Usage Examples

### Roblox AFK Farming
1. Set **Chat Button** to `/`
2. Set **Text to Type** to your command (e.g., `afk farming`)
3. Set **Interval** to desired seconds
4. Press **F8** to start

### Clipboard Pasting
1. Set **Use Clipboard** to `1`
2. Copy your text to clipboard
3. Set **Chat Button** to `/` or leave empty
4. Press **F8** to start

### Simple Text Spam
1. Set **Chat Button** to empty (no prefix)
2. Set **Text to Type** to your message
3. Set **Interval** to desired seconds
4. Press **F8** to start

## 🛠️ Building from Source

Requires [AutoHotkey v2.0+](https://www.autohotkey.com/)

1. Clone this repository
2. Open `AutoPaste.ahk` in AutoHotkey
3. Or compile to EXE using Ahk2Exe

## 📝 Configuration File

Settings are automatically saved to `autopaste_config.ini` in the same folder as the script/exe.

## ⚠️ Important Notes

- Make sure the target window is in focus when the paste executes
- Some games may have anti-spam or anti-bot measures
- Use responsibly and follow the terms of service of any platforms you use this with
- The script executes immediately on first F8 press, then follows the interval

## 🐛 Troubleshooting

**Paste not working?**
- Make sure the target window is focused
- Try disabling "Use SendInput" in config
- Increase the Sleep delays if your system is slow

**Hotkeys not working?**
- Check if another program is using the same hotkeys
- Change hotkeys in the config window

**UI not showing?**
- Check that "Show UI" is set to `1`
- Try running as administrator

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## ⭐ Support

If you find this useful, please give it a star on GitHub!

---

**Note:** This tool is for automation purposes. Always ensure you're following the rules and terms of service of any platform where you use automated tools.