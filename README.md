<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=7c28dc&height=200&section=header&text=VoidHub&fontSize=80&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Roblox+UI+Library&descAlignY=60&descAlign=50" />

<br/>

[![Version](https://img.shields.io/badge/version-1.0.0-7c28dc?style=for-the-badge&logo=lua&logoColor=white)](https://github.com/you/VoidHub)
[![Roblox](https://img.shields.io/badge/Roblox-Compatible-00b2ff?style=for-the-badge&logo=roblox&logoColor=white)](https://roblox.com)
[![License](https://img.shields.io/badge/license-MIT-9b4aff?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/you/VoidHub?style=for-the-badge&color=7c28dc&logo=github&logoColor=white)](https://github.com/you/VoidHub/stargazers)

<br/>

**A sleek, feature-rich Roblox UI Library with a dark purple / black / white aesthetic.**  
Build beautiful script hubs with multi-window support, key systems, tabs, and a full suite of UI elements.

<br/>

[📖 Documentation](docs/) • [🚀 Quick Start](#-quick-start) • [💡 Examples](docs/examples.md) • [🎨 Theming](docs/theming.md)

<br/>

</div>

---

## ✨ Features

| Feature | Description |
|---|---|
| 🪟 **Multi-Window** | Create multiple draggable, resizable windows |
| 🔑 **Key System** | Gate your hub with a blur-overlay password screen |
| 📂 **Tabs** | Left-sidebar tabs with animated indicators |
| 🔔 **Notifications** | Toast pop-ups with progress bar & 4 types |
| 🎚️ **Sliders** | Drag-to-set numeric sliders with suffix support |
| 🔘 **Toggles** | Smooth animated on/off switches |
| 📋 **Dropdowns** | Animated expandable option selectors |
| 🎨 **ColorPicker** | Color3 picker with hex preview |
| ⌨️ **Keybind** | Click-to-listen hotkey setter |
| 📝 **TextInput** | Labeled text fields with callbacks |
| 🏷️ **Labels & Sections** | Dynamic labels + visual section dividers |

---

## 🚀 Quick Start

### Load the Library

```lua
local VoidHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/you/VoidHub/main/VoidHub.lua"
))()
```

### Create Your First Hub

```lua
-- Optional: show key system first
VoidHub:KeySystem({
    Key      = "VoidHub2025",
    Title    = "VoidHub",
    SubTitle = "Enter your key to continue",
    Note     = "Get a key at discord.gg/voidhub",
    Callback = function(success)
        if not success then return end

        -- Create a window
        local Win = VoidHub:Window({
            Title       = "VoidHub",
            SubTitle    = "Blox Fruits | v2.1",
            Size        = UDim2.fromOffset(620, 420),
            MinimizeKey = Enum.KeyCode.RightShift,
        })

        -- Add a tab
        local Main = Win:Tab({ Title = "Main" })

        -- Add elements
        Main:Section("Movement")

        Main:Slider({
            Title    = "Walk Speed",
            Min      = 16,
            Max      = 500,
            Default  = 16,
            Suffix   = " spd",
            Callback = function(val)
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
            end
        })

        Main:Toggle({
            Title    = "Infinite Jump",
            Default  = false,
            Callback = function(val)
                _G.InfJump = val
            end
        })

        -- Welcome notification
        VoidHub:Notify({
            Title   = "VoidHub Loaded",
            Content = "Welcome! Press RightShift to toggle.",
            Type    = "success",
        })
    end
})
```

---

## 📖 Documentation

| Page | Description |
|---|---|
| [Getting Started](docs/getting-started.md) | Installation, loading, first window |
| [Key System](docs/key-system.md) | Password gate with blur overlay |
| [Window](docs/window.md) | Window creation, controls, options |
| [Tab](docs/tab.md) | Tab management inside a window |
| [Notifications](docs/notifications.md) | Toast notifications |
| [Button](docs/elements/button.md) | Clickable button element |
| [Toggle](docs/elements/toggle.md) | On/off switch |
| [Slider](docs/elements/slider.md) | Numeric drag slider |
| [Dropdown](docs/elements/dropdown.md) | Option selector |
| [TextInput](docs/elements/input.md) | Text field |
| [ColorPicker](docs/elements/colorpicker.md) | Color3 picker |
| [Keybind](docs/elements/keybind.md) | Hotkey setter |
| [Label & Section](docs/elements/label-section.md) | Labels and dividers |
| [Theming](docs/theming.md) | Customizing colors |
| [Full Example](docs/examples.md) | Complete hub script |

---

## 🎨 Theme Preview

```
Background   #0a0812   ██  Deep black-purple
Secondary    #140f23   ██  Slightly lighter surface
Accent       #7c28dc   ██  Main purple
AccentGlow   #9b4aff   ██  Bright purple highlight
Text         #ede8ff   ██  Near-white text
Border       #4a2878   ██  Subtle purple border
```

---

## 📋 Element Overview

```lua
Tab:Section("Title")                -- Section divider
Tab:Label("Some text")              -- Text label
Tab:Button({ ... })                 -- Clickable button
Tab:Toggle({ ... })                 -- On/off toggle
Tab:Slider({ ... })                 -- Numeric slider
Tab:Dropdown({ ... })               -- Option dropdown
Tab:Input({ ... })                  -- Text input
Tab:ColorPicker({ ... })            -- Color picker
Tab:Keybind({ ... })                -- Hotkey binder
```

---

## 📝 License

MIT License — free to use, modify, and distribute.  
If you use VoidHub in your project, a credit is appreciated! 🟣

---

<div align="center">

Made with 💜 for the Roblox scripting community

</div>
