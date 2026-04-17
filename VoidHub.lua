--[[
    VoidHub UI Library
    Version: 1.0.0
    Theme: Purple / Black / White
    Inspired by Turtle UI Library style
    
    Features:
    - Multiple Windows with Tabs
    - Key System
    - Buttons, Toggles, Sliders, Dropdowns, ColorPickers, TextInputs, Labels
    - Notifications
    - Window Management (drag, minimize, close)
]]

local VoidHub = {}
VoidHub.__index = VoidHub

-- =====================
--    SERVICES
-- =====================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- =====================
--    THEME
-- =====================
VoidHub.Theme = {
    Background      = Color3.fromRGB(12, 10, 20),
    Secondary       = Color3.fromRGB(20, 15, 35),
    Accent          = Color3.fromRGB(120, 40, 220),
    AccentDark      = Color3.fromRGB(80, 20, 160),
    AccentGlow      = Color3.fromRGB(150, 60, 255),
    TextPrimary     = Color3.fromRGB(240, 235, 255),
    TextSecondary   = Color3.fromRGB(160, 140, 200),
    TextDim         = Color3.fromRGB(100, 85, 135),
    Border          = Color3.fromRGB(70, 40, 120),
    BorderLight     = Color3.fromRGB(100, 60, 180),
    TabActive       = Color3.fromRGB(100, 30, 200),
    TabInactive     = Color3.fromRGB(25, 18, 45),
    ToggleOn        = Color3.fromRGB(120, 40, 220),
    ToggleOff       = Color3.fromRGB(40, 30, 65),
    SliderFill      = Color3.fromRGB(130, 50, 240),
    SliderBack      = Color3.fromRGB(30, 22, 55),
    InputBack       = Color3.fromRGB(18, 13, 32),
    Notification    = Color3.fromRGB(22, 16, 40),
    Shadow          = Color3.fromRGB(5, 3, 12),
    White           = Color3.fromRGB(255, 255, 255),
    Success         = Color3.fromRGB(50, 200, 120),
    Warning         = Color3.fromRGB(255, 180, 40),
    Error           = Color3.fromRGB(220, 60, 80),
}

-- =====================
--    UTILITIES
-- =====================
local function Tween(obj, props, duration, style, direction)
    style     = style     or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    duration  = duration  or 0.2
    local info = TweenInfo.new(duration, style, direction)
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function CreateInstance(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function AddStroke(parent, color, thickness)
    return CreateInstance("UIStroke", {
        Color     = color or VoidHub.Theme.Border,
        Thickness = thickness or 1.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, parent)
end

local function AddPadding(parent, top, bottom, left, right)
    return CreateInstance("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
        PaddingRight  = UDim.new(0, right  or 8),
    }, parent)
end

-- =====================
--    KEY SYSTEM
-- =====================
function VoidHub:KeySystem(config)
    --[[
        config = {
            Key = "MySecretKey123",
            Title = "VoidHub | Key System",
            SubTitle = "Enter your key to continue",
            Note = "Get a key at discord.gg/voiHub",
            Callback = function(success) end
        }
    ]]
    config = config or {}
    local T = self.Theme

    local ScreenGui = CreateInstance("ScreenGui", {
        Name           = "VoidHub_KeySystem",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Blur
    local Blur = CreateInstance("BlurEffect", {Size = 0}, game:GetService("Lighting"))
    Tween(Blur, {Size = 20}, 0.4)

    -- Overlay
    local Overlay = CreateInstance("Frame", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
    }, ScreenGui)

    -- Main Frame
    local Main = CreateInstance("Frame", {
        Size             = UDim2.fromOffset(420, 260),
        Position         = UDim2.fromScale(0.5, 0.5),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.Background,
    }, ScreenGui)
    AddCorner(Main, 12)
    AddStroke(Main, T.BorderLight, 2)
    MakeDraggable(Main)

    -- Glow shadow
    local Shadow = CreateInstance("ImageLabel", {
        Size             = UDim2.new(1, 40, 1, 40),
        Position         = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://5028857084",
        ImageColor3      = T.Accent,
        ImageTransparency = 0.6,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(24, 24, 276, 276),
        ZIndex           = 0,
    }, Main)

    -- Header
    local Header = CreateInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = T.Secondary,
    }, Main)
    AddCorner(Header, 12)

    -- Fix bottom corners of header
    CreateInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 12),
        Position         = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.Secondary,
    }, Header)

    -- Accent bar
    local AccentBar = CreateInstance("Frame", {
        Size             = UDim2.new(0, 3, 1, -16),
        Position         = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = T.Accent,
    }, Header)
    AddCorner(AccentBar, 4)

    CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 28),
        Position         = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text             = config.Title or "VoidHub | Key System",
        TextColor3       = T.TextPrimary,
        TextSize         = 18,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, Header)

    CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 18),
        Position         = UDim2.new(0, 14, 0, 36),
        BackgroundTransparency = 1,
        Text             = config.SubTitle or "Enter your key to continue",
        TextColor3       = T.TextSecondary,
        TextSize         = 13,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, Header)

    -- Note
    local NoteLabel = CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -30, 0, 20),
        Position         = UDim2.new(0, 15, 0, 70),
        BackgroundTransparency = 1,
        Text             = config.Note or "Get a key at our Discord",
        TextColor3       = T.TextDim,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, Main)

    -- Input Box
    local InputBox = CreateInstance("Frame", {
        Size             = UDim2.new(1, -30, 0, 40),
        Position         = UDim2.new(0, 15, 0, 100),
        BackgroundColor3 = T.InputBack,
    }, Main)
    AddCorner(InputBox, 8)
    AddStroke(InputBox, T.Border)

    local TextInput = CreateInstance("TextBox", {
        Size             = UDim2.new(1, -16, 1, 0),
        Position         = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text             = "",
        PlaceholderText  = "Enter key here...",
        TextColor3       = T.TextPrimary,
        PlaceholderColor3 = T.TextDim,
        TextSize         = 14,
        Font             = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, InputBox)

    -- Submit Button
    local SubmitBtn = CreateInstance("TextButton", {
        Size             = UDim2.new(1, -30, 0, 42),
        Position         = UDim2.new(0, 15, 0, 155),
        BackgroundColor3 = T.Accent,
        Text             = "Submit Key",
        TextColor3       = T.White,
        TextSize         = 15,
        Font             = Enum.Font.GothamBold,
    }, Main)
    AddCorner(SubmitBtn, 8)

    -- Status label
    local StatusLabel = CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -30, 0, 20),
        Position         = UDim2.new(0, 15, 0, 205),
        BackgroundTransparency = 1,
        Text             = "",
        TextColor3       = T.TextDim,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Center,
    }, Main)

    -- Button hover
    SubmitBtn.MouseEnter:Connect(function()
        Tween(SubmitBtn, {BackgroundColor3 = T.AccentGlow}, 0.15)
    end)
    SubmitBtn.MouseLeave:Connect(function()
        Tween(SubmitBtn, {BackgroundColor3 = T.Accent}, 0.15)
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        local entered = TextInput.Text
        if entered == (config.Key or "") then
            StatusLabel.TextColor3 = T.Success
            StatusLabel.Text = "✓ Key accepted! Loading..."
            Tween(Blur, {Size = 0}, 0.5)
            task.wait(1.2)
            ScreenGui:Destroy()
            if config.Callback then config.Callback(true) end
        else
            StatusLabel.TextColor3 = T.Error
            StatusLabel.Text = "✗ Invalid key. Please try again."
            Tween(SubmitBtn, {BackgroundColor3 = T.Error}, 0.1)
            task.wait(0.3)
            Tween(SubmitBtn, {BackgroundColor3 = T.Accent}, 0.2)
        end
    end)

    -- Entrance animation
    Main.Position = UDim2.new(0.5, 0, 0.6, 0)
    Main.BackgroundTransparency = 1
    Tween(Main, {Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back)
end

-- =====================
--    NOTIFICATION
-- =====================
local NotifHolder

local function GetNotifHolder()
    if NotifHolder and NotifHolder.Parent then return NotifHolder end
    local sg = Instance.new("ScreenGui")
    sg.Name = "VoidHub_Notifs"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local holder = CreateInstance("Frame", {
        Size             = UDim2.fromOffset(300, 0),
        Position         = UDim2.new(1, -315, 1, -20),
        AnchorPoint      = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        AutomaticSize    = Enum.AutomaticSize.Y,
    }, sg)

    local layout = CreateInstance("UIListLayout", {
        SortOrder    = Enum.SortOrder.LayoutOrder,
        Padding      = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, holder)

    NotifHolder = holder
    return holder
end

function VoidHub:Notify(config)
    --[[
        config = {
            Title    = "VoidHub",
            Content  = "Hello World",
            Duration = 4,
            Type     = "info" | "success" | "warning" | "error"
        }
    ]]
    config = config or {}
    local T       = self.Theme
    local holder  = GetNotifHolder()
    local nType   = config.Type or "info"
    local duration = config.Duration or 4

    local accentColor = (nType == "success" and T.Success)
        or (nType == "warning" and T.Warning)
        or (nType == "error"   and T.Error)
        or T.Accent

    local notif = CreateInstance("Frame", {
        Size             = UDim2.fromOffset(300, 72),
        BackgroundColor3 = T.Notification,
        ClipsDescendants = true,
    }, holder)
    AddCorner(notif, 10)
    AddStroke(notif, accentColor, 1.5)

    -- Left bar
    local bar = CreateInstance("Frame", {
        Size             = UDim2.new(0, 4, 1, -12),
        Position         = UDim2.new(0, 0, 0, 6),
        BackgroundColor3 = accentColor,
    }, notif)
    AddCorner(bar, 4)

    CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 20),
        Position         = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text             = config.Title or "VoidHub",
        TextColor3       = T.TextPrimary,
        TextSize         = 14,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, notif)

    CreateInstance("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 30),
        Position         = UDim2.new(0, 14, 0, 32),
        BackgroundTransparency = 1,
        Text             = config.Content or "",
        TextColor3       = T.TextSecondary,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
    }, notif)

    -- Progress bar
    local progress = CreateInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 3),
        Position         = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = accentColor,
    }, notif)

    -- Slide in
    notif.Position = UDim2.new(1, 10, 0, 0)
    Tween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)

    -- Shrink progress
    Tween(progress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, 10, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        notif:Destroy()
    end)
end

-- =====================
--    WINDOW
-- =====================
local WindowClass = {}
WindowClass.__index = WindowClass

function VoidHub:Window(config)
    --[[
        config = {
            Title    = "VoidHub",
            SubTitle = "v1.0",
            Size     = UDim2.fromOffset(560, 380),
            MinimizeKey = Enum.KeyCode.RightShift,
        }
    ]]
    config = config or {}
    local T = self.Theme
    local self_window = setmetatable({}, WindowClass)
    self_window.Library = self
    self_window.Tabs     = {}
    self_window.ActiveTab = nil

    -- ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name           = "VoidHub_" .. (config.Title or "Window"),
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self_window.ScreenGui = ScreenGui

    local windowSize = config.Size or UDim2.fromOffset(600, 400)

    -- Main Window
    local Win = CreateInstance("Frame", {
        Size             = windowSize,
        Position         = UDim2.fromScale(0.5, 0.5),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.Background,
        ClipsDescendants = false,
    }, ScreenGui)
    AddCorner(Win, 10)
    AddStroke(Win, T.BorderLight, 1.5)
    MakeDraggable(Win)
    self_window.Win = Win

    -- Shadow
    CreateInstance("ImageLabel", {
        Size             = UDim2.new(1, 60, 1, 60),
        Position         = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://5028857084",
        ImageColor3      = T.Accent,
        ImageTransparency = 0.7,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(24, 24, 276, 276),
        ZIndex           = 0,
    }, Win)

    -- ============ TOP BAR ============
    local TopBar = CreateInstance("Frame", {
        Name             = "TopBar",
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = T.Secondary,
    }, Win)
    AddCorner(TopBar, 10)
    -- Fill bottom corners
    CreateInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 10),
        Position         = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = T.Secondary,
    }, TopBar)

    -- Accent left line
    local TopAccent = CreateInstance("Frame", {
        Size             = UDim2.new(0, 3, 0, 36),
        Position         = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = T.Accent,
    }, TopBar)
    AddCorner(TopAccent, 4)

    -- Logo / Title
    CreateInstance("TextLabel", {
        Size             = UDim2.new(0, 200, 0, 28),
        Position         = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text             = config.Title or "VoidHub",
        TextColor3       = T.TextPrimary,
        TextSize         = 20,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, TopBar)

    CreateInstance("TextLabel", {
        Size             = UDim2.new(0, 200, 0, 18),
        Position         = UDim2.new(0, 12, 0, 32),
        BackgroundTransparency = 1,
        Text             = config.SubTitle or "v1.0",
        TextColor3       = T.TextDim,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, TopBar)

    -- Minimize button
    local MinBtn = CreateInstance("TextButton", {
        Size             = UDim2.fromOffset(28, 28),
        Position         = UDim2.new(1, -64, 0, 12),
        BackgroundColor3 = T.TabInactive,
        Text             = "—",
        TextColor3       = T.TextSecondary,
        TextSize         = 14,
        Font             = Enum.Font.GothamBold,
    }, TopBar)
    AddCorner(MinBtn, 6)

    -- Close button
    local CloseBtn = CreateInstance("TextButton", {
        Size             = UDim2.fromOffset(28, 28),
        Position         = UDim2.new(1, -30, 0, 12),
        BackgroundColor3 = Color3.fromRGB(160, 30, 60),
        Text             = "✕",
        TextColor3       = T.White,
        TextSize         = 14,
        Font             = Enum.Font.GothamBold,
    }, TopBar)
    AddCorner(CloseBtn, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Win, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local minimized = false
    local originalSize = windowSize

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Win, {Size = UDim2.fromOffset(windowSize.X.Offset, 52)}, 0.3)
        else
            Tween(Win, {Size = originalSize}, 0.3)
        end
    end)

    -- Keybind minimize
    if config.MinimizeKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == config.MinimizeKey then
                Win.Visible = not Win.Visible
            end
        end)
    end

    -- ============ TAB BAR (left side) ============
    local TabBar = CreateInstance("Frame", {
        Name             = "TabBar",
        Size             = UDim2.new(0, 140, 1, -52),
        Position         = UDim2.new(0, 0, 0, 52),
        BackgroundColor3 = T.Secondary,
    }, Win)

    -- Fix right top corner
    CreateInstance("Frame", {
        Size             = UDim2.new(0, 10, 0, 10),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = T.Secondary,
    }, TabBar)

    local TabList = CreateInstance("Frame", {
        Size             = UDim2.new(1, 0, 1, -10),
        Position         = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
    }, TabBar)

    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 4),
    }, TabList)
    AddPadding(TabList, 4, 4, 6, 6)

    -- ============ CONTENT AREA ============
    local ContentArea = CreateInstance("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, -140, 1, -52),
        Position         = UDim2.new(0, 140, 0, 52),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, Win)
    self_window.ContentArea = ContentArea
    self_window.TabList      = TabList

    -- Entrance animation
    Win.Size = UDim2.fromOffset(0, 0)
    Tween(Win, {Size = windowSize}, 0.4, Enum.EasingStyle.Back)

    -- ============ AddTab ============
    function self_window:Tab(tabConfig)
        tabConfig = tabConfig or {}
        local lib  = self.Library
        local T2   = lib.Theme
        local tab  = {}
        tab.Window = self

        -- Tab Button
        local TabBtn = CreateInstance("TextButton", {
            Size             = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T2.TabInactive,
            Text             = "",
            AutoButtonColor  = false,
        }, self.TabList)
        AddCorner(TabBtn, 7)

        CreateInstance("TextLabel", {
            Size             = UDim2.new(1, -10, 1, 0),
            Position         = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text             = tabConfig.Title or "Tab",
            TextColor3       = T2.TextSecondary,
            TextSize         = 13,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            Name             = "Label",
        }, TabBtn)

        -- Tab indicator
        local Indicator = CreateInstance("Frame", {
            Size             = UDim2.new(0, 3, 0, 20),
            Position         = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = T2.Accent,
            Visible          = false,
        }, TabBtn)
        AddCorner(Indicator, 4)

        -- Tab page (scroll)
        local Page = CreateInstance("ScrollingFrame", {
            Size             = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = T2.Accent,
            CanvasSize       = UDim2.fromOffset(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible          = false,
        }, self.ContentArea)

        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 6),
        }, Page)
        AddPadding(Page, 10, 10, 10, 10)

        tab.Page = Page
        tab.Button = TabBtn

        -- Select tab function
        function tab:Select()
            local win = self.Window
            -- Deactivate all tabs
            for _, t in ipairs(win.Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {BackgroundColor3 = T2.TabInactive}, 0.15)
                t.Button.Label.TextColor3 = T2.TextSecondary
                t.Button:FindFirstChild("Frame").Visible = false  -- indicator
            end
            -- Activate this tab
            self.Page.Visible = true
            Tween(self.Button, {BackgroundColor3 = T2.TabActive}, 0.15)
            self.Button.Label.TextColor3 = T2.TextPrimary
            Indicator.Visible = true
            win.ActiveTab = self
        end

        TabBtn.MouseButton1Click:Connect(function()
            tab:Select()
        end)

        TabBtn.MouseEnter:Connect(function()
            if self.ActiveTab ~= tab then
                Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(35, 25, 60)}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if self.ActiveTab ~= tab then
                Tween(TabBtn, {BackgroundColor3 = T2.TabInactive}, 0.15)
            end
        end)

        table.insert(self.Tabs, tab)

        -- Auto select first tab
        if #self.Tabs == 1 then
            tab:Select()
        end

        -- ============ ELEMENTS ============

        -- Section
        function tab:Section(title)
            local sect = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 28),
                BackgroundTransparency = 1,
            }, self.Page)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(0, 200, 1, 0),
                BackgroundTransparency = 1,
                Text             = title or "Section",
                TextColor3       = T2.Accent,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, sect)

            local line = CreateInstance("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = T2.Border,
            }, sect)
        end

        -- Label
        function tab:Label(text)
            local lbl = CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -20, 0, 26),
                BackgroundTransparency = 1,
                Text             = text or "",
                TextColor3       = T2.TextSecondary,
                TextSize         = 13,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
            }, self.Page)
            return {
                SetText = function(_, newText)
                    lbl.Text = newText
                end
            }
        end

        -- Button
        function tab:Button(btnConfig)
            --[[
                btnConfig = {
                    Title    = "Click Me",
                    Desc     = "Does something cool",
                    Callback = function() end
                }
            ]]
            btnConfig = btnConfig or {}
            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 50),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -110, 0, 22),
                Position         = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text             = btnConfig.Title or "Button",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            if btnConfig.Desc then
                CreateInstance("TextLabel", {
                    Size             = UDim2.new(1, -110, 0, 16),
                    Position         = UDim2.new(0, 12, 0, 30),
                    BackgroundTransparency = 1,
                    Text             = btnConfig.Desc,
                    TextColor3       = T2.TextDim,
                    TextSize         = 11,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                }, holder)
            end

            local Btn = CreateInstance("TextButton", {
                Size             = UDim2.fromOffset(80, 30),
                Position         = UDim2.new(1, -92, 0.5, -15),
                BackgroundColor3 = T2.Accent,
                Text             = "Execute",
                TextColor3       = T2.White,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
            }, holder)
            AddCorner(Btn, 6)

            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = T2.AccentGlow}, 0.15)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = T2.Accent}, 0.15)
            end)
            Btn.MouseButton1Click:Connect(function()
                if btnConfig.Callback then btnConfig.Callback() end
                Tween(Btn, {BackgroundColor3 = T2.AccentDark}, 0.1)
                task.wait(0.15)
                Tween(Btn, {BackgroundColor3 = T2.Accent}, 0.15)
            end)
        end

        -- Toggle
        function tab:Toggle(toggleConfig)
            --[[
                toggleConfig = {
                    Title    = "My Toggle",
                    Desc     = "Turns something on/off",
                    Default  = false,
                    Callback = function(value) end
                }
            ]]
            toggleConfig = toggleConfig or {}
            local state = toggleConfig.Default or false

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 50),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -70, 0, 22),
                Position         = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text             = toggleConfig.Title or "Toggle",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            if toggleConfig.Desc then
                CreateInstance("TextLabel", {
                    Size             = UDim2.new(1, -70, 0, 16),
                    Position         = UDim2.new(0, 12, 0, 30),
                    BackgroundTransparency = 1,
                    Text             = toggleConfig.Desc,
                    TextColor3       = T2.TextDim,
                    TextSize         = 11,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                }, holder)
            end

            local ToggleBG = CreateInstance("Frame", {
                Size             = UDim2.fromOffset(44, 24),
                Position         = UDim2.new(1, -56, 0.5, -12),
                BackgroundColor3 = state and T2.ToggleOn or T2.ToggleOff,
            }, holder)
            AddCorner(ToggleBG, 12)

            local Knob = CreateInstance("Frame", {
                Size             = UDim2.fromOffset(18, 18),
                Position         = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
                BackgroundColor3 = T2.White,
            }, ToggleBG)
            AddCorner(Knob, 9)

            local Clickable = CreateInstance("TextButton", {
                Size             = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text             = "",
            }, holder)

            Clickable.MouseButton1Click:Connect(function()
                state = not state
                Tween(ToggleBG, {BackgroundColor3 = state and T2.ToggleOn or T2.ToggleOff}, 0.2)
                Tween(Knob, {Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)}, 0.2, Enum.EasingStyle.Back)
                if toggleConfig.Callback then toggleConfig.Callback(state) end
            end)

            return {
                Set = function(_, val)
                    state = val
                    Tween(ToggleBG, {BackgroundColor3 = state and T2.ToggleOn or T2.ToggleOff}, 0.2)
                    Tween(Knob, {Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)}, 0.2)
                end,
                Get = function(_) return state end,
            }
        end

        -- Slider
        function tab:Slider(sliderConfig)
            --[[
                sliderConfig = {
                    Title    = "Speed",
                    Desc     = "Player walk speed",
                    Min      = 0,
                    Max      = 100,
                    Default  = 16,
                    Suffix   = "",
                    Callback = function(value) end
                }
            ]]
            sliderConfig = sliderConfig or {}
            local min     = sliderConfig.Min     or 0
            local max     = sliderConfig.Max     or 100
            local current = sliderConfig.Default or min
            local suffix  = sliderConfig.Suffix  or ""

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 62),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -80, 0, 22),
                Position         = UDim2.new(0, 12, 0, 6),
                BackgroundTransparency = 1,
                Text             = sliderConfig.Title or "Slider",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            local ValLabel = CreateInstance("TextLabel", {
                Size             = UDim2.fromOffset(70, 22),
                Position         = UDim2.new(1, -82, 0, 6),
                BackgroundTransparency = 1,
                Text             = tostring(current) .. suffix,
                TextColor3       = T2.Accent,
                TextSize         = 13,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Right,
            }, holder)

            if sliderConfig.Desc then
                CreateInstance("TextLabel", {
                    Size             = UDim2.new(1, -20, 0, 14),
                    Position         = UDim2.new(0, 12, 0, 28),
                    BackgroundTransparency = 1,
                    Text             = sliderConfig.Desc,
                    TextColor3       = T2.TextDim,
                    TextSize         = 11,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                }, holder)
            end

            local Track = CreateInstance("Frame", {
                Size             = UDim2.new(1, -24, 0, 8),
                Position         = UDim2.new(0, 12, 1, -20),
                BackgroundColor3 = T2.SliderBack,
            }, holder)
            AddCorner(Track, 4)

            local pct = (current - min) / (max - min)
            local Fill = CreateInstance("Frame", {
                Size             = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = T2.SliderFill,
            }, Track)
            AddCorner(Fill, 4)

            local Handle = CreateInstance("Frame", {
                Size             = UDim2.fromOffset(16, 16),
                Position         = UDim2.new(pct, -8, 0.5, -8),
                BackgroundColor3 = T2.White,
            }, Track)
            AddCorner(Handle, 8)
            AddStroke(Handle, T2.Accent, 2)

            local sliding = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX     = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    current = math.floor(min + (max - min) * relX)
                    ValLabel.Text = tostring(current) .. suffix
                    Tween(Fill,   {Size     = UDim2.new(relX, 0, 1, 0)}, 0.05)
                    Tween(Handle, {Position = UDim2.new(relX, -8, 0.5, -8)}, 0.05)
                    if sliderConfig.Callback then sliderConfig.Callback(current) end
                end
            end)

            return {
                Set = function(_, val)
                    val = math.clamp(val, min, max)
                    current = val
                    local r = (val - min) / (max - min)
                    ValLabel.Text = tostring(val) .. suffix
                    Tween(Fill,   {Size     = UDim2.new(r, 0, 1, 0)}, 0.15)
                    Tween(Handle, {Position = UDim2.new(r, -8, 0.5, -8)}, 0.15)
                end,
                Get = function(_) return current end,
            }
        end

        -- Dropdown
        function tab:Dropdown(dropConfig)
            --[[
                dropConfig = {
                    Title    = "Gamemode",
                    Options  = {"Option1", "Option2"},
                    Default  = "Option1",
                    Callback = function(option) end
                }
            ]]
            dropConfig = dropConfig or {}
            local selected = dropConfig.Default or (dropConfig.Options and dropConfig.Options[1]) or "None"
            local open     = false

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 50),
                BackgroundColor3 = T2.Secondary,
                ClipsDescendants = false,
                ZIndex           = 5,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -130, 0, 22),
                Position         = UDim2.new(0, 12, 0, 14),
                BackgroundTransparency = 1,
                Text             = dropConfig.Title or "Dropdown",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
            }, holder)

            local SelBtn = CreateInstance("TextButton", {
                Size             = UDim2.fromOffset(130, 30),
                Position         = UDim2.new(1, -142, 0.5, -15),
                BackgroundColor3 = T2.InputBack,
                Text             = selected,
                TextColor3       = T2.TextSecondary,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                ZIndex           = 5,
            }, holder)
            AddCorner(SelBtn, 6)
            AddStroke(SelBtn, T2.Border)

            -- Arrow
            local Arrow = CreateInstance("TextLabel", {
                Size             = UDim2.fromOffset(16, 16),
                Position         = UDim2.new(1, -20, 0.5, -8),
                BackgroundTransparency = 1,
                Text             = "▾",
                TextColor3       = T2.TextDim,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
                ZIndex           = 6,
            }, SelBtn)

            -- Dropdown list
            local List = CreateInstance("Frame", {
                Size             = UDim2.new(0, 130, 0, 0),
                Position         = UDim2.new(1, -142, 1, 4),
                BackgroundColor3 = T2.Secondary,
                ClipsDescendants = true,
                ZIndex           = 10,
                Visible          = false,
            }, holder)
            AddCorner(List, 8)
            AddStroke(List, T2.BorderLight)

            local ListLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 2),
            }, List)
            AddPadding(List, 4, 4, 4, 4)

            local opts = dropConfig.Options or {}
            for _, opt in ipairs(opts) do
                local optBtn = CreateInstance("TextButton", {
                    Size             = UDim2.new(1, -8, 0, 28),
                    BackgroundColor3 = T2.TabInactive,
                    Text             = opt,
                    TextColor3       = T2.TextSecondary,
                    TextSize         = 12,
                    Font             = Enum.Font.Gotham,
                    ZIndex           = 11,
                }, List)
                AddCorner(optBtn, 5)

                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = T2.TabActive}, 0.1)
                    optBtn.TextColor3 = T2.TextPrimary
                end)
                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = T2.TabInactive}, 0.1)
                    optBtn.TextColor3 = T2.TextSecondary
                end)
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    SelBtn.Text = opt
                    open = false
                    List.Visible = false
                    if dropConfig.Callback then dropConfig.Callback(opt) end
                end)
            end

            local listHeight = #opts * 30 + 8

            SelBtn.MouseButton1Click:Connect(function()
                open = not open
                List.Visible = open
                if open then
                    List.Size = UDim2.new(0, 130, 0, 0)
                    Tween(List, {Size = UDim2.new(0, 130, 0, listHeight)}, 0.2, Enum.EasingStyle.Back)
                    Tween(Arrow, {Rotation = 180}, 0.2)
                else
                    Tween(List, {Size = UDim2.new(0, 130, 0, 0)}, 0.15)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    task.wait(0.15)
                    List.Visible = false
                end
            end)

            return {
                Set = function(_, val)
                    selected = val
                    SelBtn.Text = val
                end,
                Get = function(_) return selected end,
            }
        end

        -- TextInput
        function tab:Input(inputConfig)
            --[[
                inputConfig = {
                    Title       = "Script Name",
                    Placeholder = "Enter value...",
                    Default     = "",
                    Numeric     = false,
                    Callback    = function(value) end
                }
            ]]
            inputConfig = inputConfig or {}

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 62),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -20, 0, 20),
                Position         = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text             = inputConfig.Title or "Input",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            local InputFrame = CreateInstance("Frame", {
                Size             = UDim2.new(1, -24, 0, 28),
                Position         = UDim2.new(0, 12, 0, 30),
                BackgroundColor3 = T2.InputBack,
            }, holder)
            AddCorner(InputFrame, 6)
            AddStroke(InputFrame, T2.Border)

            local TextBox = CreateInstance("TextBox", {
                Size             = UDim2.new(1, -12, 1, 0),
                Position         = UDim2.new(0, 6, 0, 0),
                BackgroundTransparency = 1,
                Text             = inputConfig.Default or "",
                PlaceholderText  = inputConfig.Placeholder or "Enter value...",
                TextColor3       = T2.TextPrimary,
                PlaceholderColor3 = T2.TextDim,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                ClearTextOnFocus = false,
            }, InputFrame)

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    if inputConfig.Callback then inputConfig.Callback(TextBox.Text) end
                end
            end)
            TextBox.Focused:Connect(function()
                Tween(InputFrame, {}, 0.1)
                AddStroke(InputFrame, T2.AccentGlow, 1.5)
            end)
            TextBox.FocusLost:Connect(function()
                AddStroke(InputFrame, T2.Border, 1)
            end)

            return {
                Set = function(_, val) TextBox.Text = tostring(val) end,
                Get = function(_) return TextBox.Text end,
            }
        end

        -- ColorPicker (simplified)
        function tab:ColorPicker(cpConfig)
            --[[
                cpConfig = {
                    Title    = "ESP Color",
                    Default  = Color3.fromRGB(255, 0, 0),
                    Callback = function(color) end
                }
            ]]
            cpConfig = cpConfig or {}
            local currentColor = cpConfig.Default or Color3.fromRGB(255, 100, 220)

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 50),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -80, 0, 22),
                Position         = UDim2.new(0, 12, 0, 14),
                BackgroundTransparency = 1,
                Text             = cpConfig.Title or "Color",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            local Preview = CreateInstance("Frame", {
                Size             = UDim2.fromOffset(36, 24),
                Position         = UDim2.new(1, -50, 0.5, -12),
                BackgroundColor3 = currentColor,
            }, holder)
            AddCorner(Preview, 6)
            AddStroke(Preview, T2.Border)

            local hexLabel = CreateInstance("TextLabel", {
                Size             = UDim2.fromOffset(80, 20),
                Position         = UDim2.new(1, -136, 0.5, -10),
                BackgroundTransparency = 1,
                Text             = "#" .. string.format("%02X%02X%02X",
                    math.floor(currentColor.R*255),
                    math.floor(currentColor.G*255),
                    math.floor(currentColor.B*255)),
                TextColor3       = T2.TextDim,
                TextSize         = 11,
                Font             = Enum.Font.Code,
                TextXAlignment   = Enum.TextXAlignment.Right,
            }, holder)

            return {
                Set = function(_, color)
                    currentColor = color
                    Preview.BackgroundColor3 = color
                    hexLabel.Text = "#" .. string.format("%02X%02X%02X",
                        math.floor(color.R*255),
                        math.floor(color.G*255),
                        math.floor(color.B*255))
                    if cpConfig.Callback then cpConfig.Callback(color) end
                end,
                Get = function(_) return currentColor end,
            }
        end

        -- Keybind
        function tab:Keybind(kbConfig)
            --[[
                kbConfig = {
                    Title    = "Toggle ESP",
                    Default  = Enum.KeyCode.E,
                    Callback = function(key) end
                }
            ]]
            kbConfig = kbConfig or {}
            local currentKey = kbConfig.Default or Enum.KeyCode.Unknown
            local listening  = false

            local holder = CreateInstance("Frame", {
                Size             = UDim2.new(1, -20, 0, 50),
                BackgroundColor3 = T2.Secondary,
            }, self.Page)
            AddCorner(holder, 8)
            AddStroke(holder, T2.Border)

            CreateInstance("TextLabel", {
                Size             = UDim2.new(1, -100, 0, 22),
                Position         = UDim2.new(0, 12, 0, 14),
                BackgroundTransparency = 1,
                Text             = kbConfig.Title or "Keybind",
                TextColor3       = T2.TextPrimary,
                TextSize         = 14,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
            }, holder)

            local KeyBtn = CreateInstance("TextButton", {
                Size             = UDim2.fromOffset(80, 28),
                Position         = UDim2.new(1, -92, 0.5, -14),
                BackgroundColor3 = T2.InputBack,
                Text             = currentKey.Name,
                TextColor3       = T2.Accent,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
            }, holder)
            AddCorner(KeyBtn, 6)
            AddStroke(KeyBtn, T2.Border)

            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = T2.Warning
            end)

            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeyBtn.Text = currentKey.Name
                        KeyBtn.TextColor3 = T2.Accent
                        listening = false
                        if kbConfig.Callback then kbConfig.Callback(currentKey) end
                    end
                end
            end)

            return {
                Get = function(_) return currentKey end,
            }
        end

        return tab
    end

    return self_window
end

return VoidHub
