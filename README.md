<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=7c28dc&height=200&section=header&text=VoidHub&fontSize=80&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Roblox+UI+Library&descAlignY=60&descAlign=50" />

<br/>

[![Version](https://img.shields.io/badge/version-1.0.0-7c28dc?style=for-the-badge&logo=lua&logoColor=white)](https://github.com/kakavpopee/VoidHub)
[![Roblox](https://img.shields.io/badge/Roblox-Compatible-00b2ff?style=for-the-badge&logo=roblox&logoColor=white)](https://roblox.com)
[![License](https://img.shields.io/badge/license-MIT-9b4aff?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/kakavpopee/VoidHub?style=for-the-badge&color=7c28dc&logo=github&logoColor=white)](https://github.com/kakavpopee/VoidHub/stargazers)

<br/>

**A sleek, feature-rich Roblox UI Library with a dark purple / black / white aesthetic.**
Build beautiful script hubs with multi-window support, key systems, tabs, and a full suite of UI elements.

<br/>

[🚀 Quick Start](#-quick-start) &nbsp;•&nbsp; [🔑 Key System](#-key-system) &nbsp;•&nbsp; [🪟 Window](#-window) &nbsp;•&nbsp; [📂 Tabs](#-tab) &nbsp;•&nbsp; [🧩 Elements](#-elements) &nbsp;•&nbsp; [🎨 Theming](#-theming) &nbsp;•&nbsp; [💡 Full Example](#-full-example)

<br/>

</div>

---

## ✨ Features

| Feature | Description |
|---|---|
| 🪟 **Multi-Window** | Create multiple draggable windows, each with their own tabs |
| 🔑 **Key System** | Gate your hub behind a blur-overlay password screen |
| 📂 **Tabs** | Left-sidebar tabs with animated purple indicators |
| 🔔 **Notifications** | Bottom-right toast pop-ups with progress bar and 4 types |
| 🔘 **Toggles** | Smooth animated on/off switches with get/set API |
| 🎚️ **Sliders** | Drag-to-set numeric sliders with suffix support |
| 📋 **Dropdowns** | Animated expandable option selectors |
| 🎨 **ColorPicker** | Color3 picker with hex preview swatch |
| ⌨️ **Keybind** | Click-to-listen hotkey setter |
| 📝 **TextInput** | Labeled text fields with Enter callbacks |
| 🏷️ **Labels & Sections** | Dynamic labels and visual section dividers |

---

## 🚀 Quick Start

### Load the Library

```lua
local VoidHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/kakavpopee/VoidHub/refs/heads/main/VoidHub.lua"
))()
```

### Minimal Example

```lua
local VoidHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/kakavpopee/VoidHub/refs/heads/main/VoidHub.lua"
))()

local Win  = VoidHub:Window({ Title = "My Hub" })
local Tab1 = Win:Tab({ Title = "Main" })

Tab1:Button({
    Title    = "Print Hello",
    Callback = function()
        print("Hello from VoidHub!")
    end
})
```

### How It Works

VoidHub follows a simple hierarchy:

```
VoidHub
 ├── :KeySystem()      -- optional password gate
 ├── :Notify()         -- fire a toast at any time
 └── :Window()         -- top-level draggable window
      └── :Tab()        -- left-sidebar tab
           ├── :Section()
           ├── :Label()
           ├── :Button()
           ├── :Toggle()
           ├── :Slider()
           ├── :Dropdown()
           ├── :Input()
           ├── :ColorPicker()
           └── :Keybind()
```

---

## 🔑 Key System

The Key System shows a full-screen modal with a blur effect. The player must type the correct key and press **Submit** before your hub loads.

```lua
VoidHub:KeySystem(config)
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Key` | `string` | ✅ | The secret key the player must enter |
| `Title` | `string` | ❌ | Window title |
| `SubTitle` | `string` | ❌ | Subtitle under the title |
| `Note` | `string` | ❌ | Small helper text, e.g. a Discord link |
| `Callback` | `function(success)` | ❌ | Called after the key is accepted (`success = true`) |

### Example

```lua
VoidHub:KeySystem({
    Key      = "VoidHub2025",
    Title    = "VoidHub | Key System",
    SubTitle = "Enter your key to access the hub",
    Note     = "Get a free key at discord.gg/voidhub",
    Callback = function(success)
        if not success then return end
        -- create your windows here
        local Win = VoidHub:Window({ Title = "VoidHub" })
    end
})
```

> [!TIP]
> Put all your window and element creation code **inside** the `Callback` so it only runs after the correct key is entered.

> [!WARNING]
> Never put your actual key directly in a public script. Consider obfuscating before sharing.

---

## 🪟 Window

A Window is the top-level container. It has a draggable title bar, a tab list on the left, and a scrollable content area on the right.

```lua
local Win = VoidHub:Window(config)
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | The main window title |
| `SubTitle` | `string` | ❌ | Subtitle, e.g. game name or version |
| `Size` | `UDim2` | ❌ | Window size. Default: `UDim2.fromOffset(600, 400)` |
| `MinimizeKey` | `Enum.KeyCode` | ❌ | Key that toggles the window visible/hidden |

**Returns** a Window object — call `:Tab()` on it.

### Window Controls

| Control | Action |
|---|---|
| Drag title bar | Move the window anywhere on screen |
| **—** button | Minimize — collapses to just the title bar |
| **✕** button | Close and destroy the window |
| `MinimizeKey` | Toggle the entire window visible/hidden |

### Example

```lua
local Win = VoidHub:Window({
    Title       = "VoidHub",
    SubTitle    = "Blox Fruits | v2.1",
    Size        = UDim2.fromOffset(640, 440),
    MinimizeKey = Enum.KeyCode.RightShift,
})
```

### Multiple Windows

```lua
local WinA = VoidHub:Window({ Title = "Combat"   })
local WinB = VoidHub:Window({ Title = "Visuals"  })
local WinC = VoidHub:Window({ Title = "Settings" })
```

Each window is fully independent with its own tabs and position.

---

## 📂 Tab

Tabs appear in the left sidebar of a Window. Each tab has its own scrollable page. The first tab added is always selected by default.

```lua
local MyTab = Win:Tab(config)
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label shown in the tab button |

**Returns** a Tab object — call element methods on it.

### Example

```lua
local Main     = Win:Tab({ Title = "Main"     })
local ESP      = Win:Tab({ Title = "ESP"      })
local Misc     = Win:Tab({ Title = "Misc"     })
local Settings = Win:Tab({ Title = "Settings" })
```

---

## 🔔 Notifications

Toast pop-ups that appear in the **bottom-right corner**. They auto-dismiss with a shrinking progress bar.

```lua
VoidHub:Notify(config)
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Bold header text |
| `Content` | `string` | ❌ | Body text |
| `Duration` | `number` | ❌ | Seconds before auto-dismiss. Default: `4` |
| `Type` | `string` | ❌ | `"info"` / `"success"` / `"warning"` / `"error"`. Default: `"info"` |

### Examples

```lua
-- Info (default purple)
VoidHub:Notify({
    Title   = "VoidHub",
    Content = "Hub loaded successfully.",
})

-- Success (green)
VoidHub:Notify({
    Title    = "Activated",
    Content  = "Speed boost is now ON.",
    Type     = "success",
    Duration = 3,
})

-- Warning (yellow)
VoidHub:Notify({
    Title    = "Warning",
    Content  = "Walk speed is very high, may be detected.",
    Type     = "warning",
    Duration = 6,
})

-- Error (red)
VoidHub:Notify({
    Title    = "Error",
    Content  = "Character not found. Respawn and try again.",
    Type     = "error",
    Duration = 5,
})
```

> [!NOTE]
> You can call `VoidHub:Notify()` at any time — even before a window is created. Multiple notifications stack vertically.

---

## 🧩 Elements

All elements are methods called on a **Tab object**.

---

### 🏷️ Section

A purple-accented divider with a title. Groups related elements visually.

```lua
Tab:Section("Title")
```

```lua
Main:Section("Movement")
Main:Slider({ Title = "Walk Speed", ... })
Main:Toggle({ Title = "Infinite Jump", ... })

Main:Section("Combat")
Main:Button({ Title = "Kill All", ... })
```

---

### 📄 Label

A plain text line. Returns an object so you can update the text dynamically.

```lua
local myLabel = Tab:Label("Initial text")
```

**Returns** `{ :SetText(string) }`

```lua
local StatusLabel = Tab:Label("Status: Idle")

Tab:Toggle({
    Title    = "Auto Farm",
    Callback = function(val)
        StatusLabel:SetText("Status: " .. (val and "Farming..." or "Idle"))
    end
})
```

---

### 🖱️ Button

A clickable element with an optional description and an Execute button on the right.

```lua
Tab:Button(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Main label |
| `Desc` | `string` | ❌ | Small description below the title |
| `Callback` | `function()` | ❌ | Called when clicked |

```lua
Tab:Button({
    Title    = "Teleport to Island",
    Desc     = "Instantly warps you to the starter island",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            = CFrame.new(0, 10, 0)
    end
})
```

---

### 🔘 Toggle

A smooth animated on/off switch.

```lua
local myToggle = Tab:Toggle(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Desc` | `string` | ❌ | Description below the title |
| `Default` | `boolean` | ❌ | Starting state. Default: `false` |
| `Callback` | `function(value)` | ❌ | Called with the new `boolean` on change |

**Returns** `{ :Set(bool), :Get() → bool }`

```lua
local ESPToggle = ESP:Toggle({
    Title    = "Player ESP",
    Desc     = "Shows boxes around all players",
    Default  = false,
    Callback = function(val)
        print("ESP:", val)
    end
})

print(ESPToggle:Get())   -- false
ESPToggle:Set(true)      -- turn on
```

---

### 🎚️ Slider

A drag-to-set numeric slider. The value updates live while dragging.

```lua
local mySlider = Tab:Slider(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Desc` | `string` | ❌ | Description |
| `Min` | `number` | ❌ | Minimum value. Default: `0` |
| `Max` | `number` | ❌ | Maximum value. Default: `100` |
| `Default` | `number` | ❌ | Starting value. Default: `Min` |
| `Suffix` | `string` | ❌ | Text after the value, e.g. `" spd"` |
| `Callback` | `function(value)` | ❌ | Called while dragging with the current integer |

**Returns** `{ :Set(number), :Get() → number }`

```lua
local SpeedSlider = Main:Slider({
    Title    = "Walk Speed",
    Desc     = "Sets the player walk speed",
    Min      = 16,
    Max      = 500,
    Default  = 16,
    Suffix   = " spd",
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
})

SpeedSlider:Set(100)
print(SpeedSlider:Get())  -- 100
```

> [!NOTE]
> Values are whole integers. `:Set()` clamps values outside `Min`/`Max`. The callback fires continuously while dragging — keep it lightweight.

---

### 📋 Dropdown

An animated expandable list. The player picks one option from a set.

```lua
local myDropdown = Tab:Dropdown(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Options` | `table` | ✅ | Array of strings e.g. `{"A", "B", "C"}` |
| `Default` | `string` | ❌ | Pre-selected option. Defaults to first option |
| `Callback` | `function(option)` | ❌ | Called with the selected string when changed |

**Returns** `{ :Set(string), :Get() → string }`

```lua
local IslandDrop = Main:Dropdown({
    Title    = "Select Island",
    Options  = {"Starter Island", "Middle Town", "Marine Fortress", "Upper Yard"},
    Default  = "Starter Island",
    Callback = function(island)
        print("Teleporting to:", island)
    end
})

IslandDrop:Set("Middle Town")
```

---

### 📝 TextInput

A labeled text field. The callback fires when the player presses **Enter**.

```lua
local myInput = Tab:Input(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Placeholder` | `string` | ❌ | Greyed-out hint text |
| `Default` | `string` | ❌ | Pre-filled value |
| `Callback` | `function(value)` | ❌ | Called with the string when Enter is pressed |

**Returns** `{ :Set(string), :Get() → string }`

```lua
local TargetInput = Misc:Input({
    Title       = "Target Player",
    Placeholder = "Enter player name...",
    Callback    = function(val)
        print("Targeting:", val)
    end
})

Tab:Button({
    Title    = "Teleport to Target",
    Callback = function()
        print("Going to:", TargetInput:Get())
    end
})
```

---

### 🎨 ColorPicker

Displays the current `Color3` as a colour preview swatch and hex code.

```lua
local myPicker = Tab:ColorPicker(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Default` | `Color3` | ❌ | Starting colour |
| `Callback` | `function(color)` | ❌ | Called with the new `Color3` when set |

**Returns** `{ :Set(Color3), :Get() → Color3 }`

```lua
local ESPColor = ESP:ColorPicker({
    Title    = "ESP Box Color",
    Default  = Color3.fromRGB(180, 60, 255),
    Callback = function(color)
        -- apply to your drawing objects
    end
})

-- Combine with a Dropdown for colour presets
local Presets = {
    Purple = Color3.fromRGB(180, 60, 255),
    Cyan   = Color3.fromRGB(0,  200, 255),
    Red    = Color3.fromRGB(220, 50,  80),
    White  = Color3.fromRGB(255, 255, 255),
}
ESP:Dropdown({
    Title    = "Color Preset",
    Options  = {"Purple", "Cyan", "Red", "White"},
    Callback = function(name)
        ESPColor:Set(Presets[name])
    end
})
```

---

### ⌨️ Keybind

Lets the player assign a hotkey. Click the button, then press any key to set it.

```lua
local myKeybind = Tab:Keybind(config)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `Title` | `string` | ✅ | Label |
| `Default` | `Enum.KeyCode` | ❌ | Default key |
| `Callback` | `function(key)` | ❌ | Called with new `Enum.KeyCode` when set |

**Returns** `{ :Get() → Enum.KeyCode }`

```lua
local FlyKey = Main:Keybind({
    Title    = "Toggle Fly",
    Default  = Enum.KeyCode.F,
    Callback = function(key)
        print("Fly key set to:", key.Name)
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == FlyKey:Get() then
        -- toggle fly
    end
end)
```

---

## 🎨 Theming

All colours are stored in `VoidHub.Theme`. Override any entry **before** calling `:Window()`.

### Default Colour Table

| Key | Hex | Used for |
|---|---|---|
| `Background` | `#0a0812` | Main window background |
| `Secondary` | `#140f23` | Title bar, tab bar, element backgrounds |
| `Accent` | `#7c28dc` | Buttons, active tab, toggle on, slider fill |
| `AccentDark` | `#50149a` | Button pressed state |
| `AccentGlow` | `#9b4aff` | Hover highlights |
| `TextPrimary` | `#ede8ff` | Main labels |
| `TextSecondary` | `#a090cc` | Descriptions, inactive tabs |
| `TextDim` | `#5e4d80` | Placeholders, hints |
| `Border` | `#4a2878` | Element borders |
| `BorderLight` | `#6432b4` | Window border |
| `ToggleOn` | `#7c28dc` | Toggle ON colour |
| `ToggleOff` | `#281e41` | Toggle OFF colour |
| `SliderFill` | `#8232f0` | Slider filled portion |
| `SliderBack` | `#1e1637` | Slider empty track |
| `InputBack` | `#120d20` | Text input background |
| `Success` | `#3fc98a` | Success notification |
| `Warning` | `#f0b845` | Warning notification |
| `Error` | `#e04060` | Error notification |

### Overriding Colours

```lua
local VoidHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/kakavpopee/VoidHub/refs/heads/main/VoidHub.lua"
))()

-- Change accent to blue before creating any windows
VoidHub.Theme.Accent      = Color3.fromRGB(30,  120, 220)
VoidHub.Theme.AccentDark  = Color3.fromRGB(20,  80,  160)
VoidHub.Theme.AccentGlow  = Color3.fromRGB(60,  160, 255)
VoidHub.Theme.ToggleOn    = Color3.fromRGB(30,  120, 220)
VoidHub.Theme.SliderFill  = Color3.fromRGB(40,  140, 240)
VoidHub.Theme.TabActive   = Color3.fromRGB(20,  90,  200)

local Win = VoidHub:Window({ Title = "My Hub" })
```

### Preset Themes

<details>
<summary>🔵 Blue Theme</summary>

```lua
VoidHub.Theme.Accent     = Color3.fromRGB(30,  120, 220)
VoidHub.Theme.AccentGlow = Color3.fromRGB(60,  160, 255)
VoidHub.Theme.ToggleOn   = Color3.fromRGB(30,  120, 220)
VoidHub.Theme.SliderFill = Color3.fromRGB(40,  140, 240)
VoidHub.Theme.TabActive  = Color3.fromRGB(20,  90,  200)
VoidHub.Theme.Border     = Color3.fromRGB(30,  80,  160)
```

</details>

<details>
<summary>🔴 Red Theme</summary>

```lua
VoidHub.Theme.Accent     = Color3.fromRGB(200, 30,  60)
VoidHub.Theme.AccentGlow = Color3.fromRGB(240, 60,  80)
VoidHub.Theme.ToggleOn   = Color3.fromRGB(200, 30,  60)
VoidHub.Theme.SliderFill = Color3.fromRGB(220, 50,  70)
VoidHub.Theme.TabActive  = Color3.fromRGB(160, 20,  45)
VoidHub.Theme.Border     = Color3.fromRGB(140, 30,  50)
```

</details>

<details>
<summary>🟢 Green Theme</summary>

```lua
VoidHub.Theme.Accent     = Color3.fromRGB(30,  180, 100)
VoidHub.Theme.AccentGlow = Color3.fromRGB(50,  220, 130)
VoidHub.Theme.ToggleOn   = Color3.fromRGB(30,  180, 100)
VoidHub.Theme.SliderFill = Color3.fromRGB(40,  200, 110)
VoidHub.Theme.TabActive  = Color3.fromRGB(20,  140, 75)
VoidHub.Theme.Border     = Color3.fromRGB(25,  120, 65)
```

</details>

> [!IMPORTANT]
> Theme overrides must be done **before** calling `:Window()`. Existing windows keep their original colours.

---

## 💡 Full Example

A complete hub script using every VoidHub feature. Use this as your starting template.

```lua
-- ============================================================
--   VoidHub — Full Hub Example
--   Copy this and customise for any game
-- ============================================================

local VoidHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/kakavpopee/VoidHub/refs/heads/main/VoidHub.lua"
))()

-- ── Key System ──────────────────────────────────────────────
VoidHub:KeySystem({
    Key      = "VoidHub2025",
    Title    = "VoidHub | Blox Fruits",
    SubTitle = "Enter your key to continue",
    Note     = "Get a free key at discord.gg/voidhub",

    Callback = function(success)
        if not success then return end

        -- ── Window ──────────────────────────────────────────
        local Win = VoidHub:Window({
            Title       = "VoidHub",
            SubTitle    = "Blox Fruits | v2.1",
            Size        = UDim2.fromOffset(640, 440),
            MinimizeKey = Enum.KeyCode.RightShift,
        })

        -- ── Tabs ─────────────────────────────────────────────
        local Main     = Win:Tab({ Title = "Main"     })
        local ESP      = Win:Tab({ Title = "ESP"      })
        local Misc     = Win:Tab({ Title = "Misc"     })
        local Settings = Win:Tab({ Title = "Settings" })

        -- ============================================================
        --   MAIN TAB
        -- ============================================================

        Main:Section("Movement")

        Main:Slider({
            Title    = "Walk Speed",
            Desc     = "Sets the player walk speed",
            Min      = 16, Max = 500, Default = 16,
            Suffix   = " spd",
            Callback = function(val)
                local char = game.Players.LocalPlayer.Character
                if char then char.Humanoid.WalkSpeed = val end
            end
        })

        Main:Slider({
            Title    = "Jump Power",
            Min      = 7, Max = 300, Default = 7,
            Suffix   = " jp",
            Callback = function(val)
                local char = game.Players.LocalPlayer.Character
                if char then char.Humanoid.JumpPower = val end
            end
        })

        Main:Toggle({
            Title    = "Infinite Jump",
            Default  = false,
            Callback = function(val) _G.InfJump = val end
        })

        Main:Section("Teleport")

        Main:Dropdown({
            Title    = "Select Island",
            Options  = {"Starter Island", "Middle Town", "Marine Fortress", "Upper Yard"},
            Default  = "Starter Island",
            Callback = function(island)
                print("Teleporting to:", island)
            end
        })

        Main:Button({
            Title    = "Teleport Now",
            Desc     = "Warps to the selected island instantly",
            Callback = function()
                print("Teleporting!")
            end
        })

        Main:Section("Combat")

        Main:Toggle({
            Title    = "Auto Farm",
            Desc     = "Automatically kills nearby mobs",
            Callback = function(val) _G.AutoFarm = val end
        })

        Main:Button({
            Title    = "Kill All NPCs",
            Desc     = "Eliminates all NPCs in the workspace",
            Callback = function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= game.Players.LocalPlayer.Character then
                        v.Health = 0
                    end
                end
            end
        })

        -- ============================================================
        --   ESP TAB
        -- ============================================================

        local StatusLabel = ESP:Label("ESP Status: OFF")

        ESP:Section("Players")

        local ESPColor = ESP:ColorPicker({
            Title   = "ESP Color",
            Default = Color3.fromRGB(180, 60, 255),
        })

        ESP:Toggle({
            Title    = "Player ESP",
            Desc     = "Show boxes around all players",
            Default  = false,
            Callback = function(val)
                StatusLabel:SetText("ESP Status: " .. (val and "ON" or "OFF"))
            end
        })

        ESP:Dropdown({
            Title    = "Color Preset",
            Options  = {"Purple", "Cyan", "Red", "White"},
            Callback = function(name)
                local Presets = {
                    Purple = Color3.fromRGB(180, 60, 255),
                    Cyan   = Color3.fromRGB(0,  200, 255),
                    Red    = Color3.fromRGB(220, 50,  80),
                    White  = Color3.fromRGB(255, 255, 255),
                }
                ESPColor:Set(Presets[name])
            end
        })

        ESP:Slider({
            Title    = "ESP Distance",
            Min      = 50, Max = 2000, Default = 500,
            Suffix   = " st",
            Callback = function(val) _G.ESPDistance = val end
        })

        ESP:Section("Keybinds")

        ESP:Keybind({
            Title   = "Toggle ESP",
            Default = Enum.KeyCode.E,
        })

        -- ============================================================
        --   MISC TAB
        -- ============================================================

        Misc:Section("Player")

        local TargetInput = Misc:Input({
            Title       = "Target Player",
            Placeholder = "Enter player name...",
            Callback    = function(val) print("Targeting:", val) end
        })

        Misc:Button({
            Title    = "Go to Target",
            Callback = function()
                print("Going to:", TargetInput:Get())
            end
        })

        Misc:Section("Visuals")

        Misc:Toggle({
            Title    = "No Fog",
            Callback = function(val)
                game:GetService("Lighting").FogEnd = val and 1e6 or 1000
            end
        })

        Misc:Toggle({
            Title    = "Full Bright",
            Callback = function(val)
                game:GetService("Lighting").Brightness = val and 3 or 1
            end
        })

        -- ============================================================
        --   SETTINGS TAB
        -- ============================================================

        Settings:Section("UI")

        Settings:Keybind({
            Title   = "Toggle Hub",
            Default = Enum.KeyCode.RightShift,
        })

        Settings:Section("About")

        Settings:Label("VoidHub v1.0.0")
        Settings:Label("Made for the Roblox community")
        Settings:Label("github.com/kakavpopee/VoidHub")

        -- ── Welcome Notification ─────────────────────────────
        VoidHub:Notify({
            Title    = "VoidHub Loaded",
            Content  = "Welcome! Press RightShift to toggle the hub.",
            Type     = "success",
            Duration = 5,
        })
    end
})
```

---

## 📋 API Cheatsheet

```lua
-- Library
VoidHub:KeySystem({ Key, Title, SubTitle, Note, Callback })
VoidHub:Window({ Title, SubTitle, Size, MinimizeKey })          --> Window
VoidHub:Notify({ Title, Content, Duration, Type })

-- Window
Win:Tab({ Title })                                              --> Tab

-- Tab
Tab:Section("Title")
Tab:Label("Text")                                               --> { :SetText() }
Tab:Button({ Title, Desc, Callback })
Tab:Toggle({ Title, Desc, Default, Callback })                  --> { :Set(), :Get() }
Tab:Slider({ Title, Desc, Min, Max, Default, Suffix, Callback })--> { :Set(), :Get() }
Tab:Dropdown({ Title, Options, Default, Callback })             --> { :Set(), :Get() }
Tab:Input({ Title, Placeholder, Default, Callback })            --> { :Set(), :Get() }
Tab:ColorPicker({ Title, Default, Callback })                   --> { :Set(), :Get() }
Tab:Keybind({ Title, Default, Callback })                       --> { :Get() }
```

---

## 📝 License

MIT License — free to use, modify, and distribute.
A credit to **VoidHub** in your project is always appreciated! 🟣

---

<div align="center">

Made with 💜 for the Roblox scripting community
<br/>
<a href="https://github.com/kakavpopee/VoidHub">github.com/kakavpopee/VoidHub</a>

</div>
