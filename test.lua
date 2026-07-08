-- Original by joestar._3 on discord
-- Refined by minifishy for catsgg
-- https://discord.gg/c5rTVxP5KD

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower

    local RectNew = Rect.new

    Library = {
        Flags = { },

        MenuKeybind = tostring(Enum.KeyCode.Z), 

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        -- Central motion config: named presets resolved to cached TweenInfo via Library:GetMotion.
        -- Populated lazily by the resolver; rebuilt whenever MotionScale changes.
        Motion = { },
        MotionScale = 1,

        Folders = {
            Directory = "zoophack",
            Configs = "zoophack/Configs",
            Assets = "zoophack/Assets",
            Themes = "zoophack/Themes"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        Themes = { },
        
        CurrentFrames = { },

        ThemeColorpickers = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        UnusedHolder = nil,
        NotifHolder = nil,
        Font = nil,
        BoldFont = nil,
    }

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = ")",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "/",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracket",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    Library.__index = Library

    Library.Pages.__index = Library.Pages
    Library.Sections.__index = Library.Sections

    -- Files
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    for Index, Image in Library.Images do
        if not isfile(Library.Folders.Assets .. "/" .. Image[1]) then
            writefile(Library.Folders.Assets .. "/" .. Image[1], game:HttpGet(Image[2]))
        end
    end

    local Themes = {
		["Default"] = {
		    -- Layered dark surfaces. Background is the base canvas; Inline
		    -- is the recessed area sections float inside; Element is the
		    -- one-step-up interactive surface (toggles, dropdowns, buttons).
		    -- Border is deliberately brighter than the 2020-era hairline
		    -- convention so edges stay legible against near-black.
		    ["Background"] = FromRGB(12, 12, 16),
		    ["Inline"]     = FromRGB(7, 7, 10),
		    ["Element"]    = FromRGB(21, 21, 29),
		    ["Border"]     = FromRGB(44, 42, 58),

		    -- Slightly-cool off-white. Pure #FFF on OLED-black surfaces
		    -- vibrates; nudging text toward 235-ish reads calmer while
		    -- still hitting 4.5:1 body-text contrast against Background.
		    ["Text"]       = FromRGB(235, 234, 240),
		    ["MutedText"]  = FromRGB(160, 160, 175),
		    ["FaintText"]  = FromRGB(112, 112, 128),
		    ["Image"]      = FromRGB(255, 255, 255),

		    -- Brand violet. Keeping the identity color; only its uses have
		    -- been reworked so it stops being sprayed across every surface.
		    ["Accent"]         = FromRGB(158, 110, 255),
		    ["Light Accent"]   = FromRGB(200, 172, 255),
		    ["Muted Accent"]   = FromRGB(90, 68, 148),

		    -- Semantic state colors — used by notifications and any host
		    -- code that wants status-tinted controls without hardcoding.
		    ["Success"] = FromRGB(78, 205, 148),
		    ["Warning"] = FromRGB(255, 190, 92),
		    ["Danger"]  = FromRGB(238, 96, 96),
		    ["Info"]    = FromRGB(96, 156, 255),
		}
    }

    Library.Theme = TableClone(Themes["Default"])
    Library.Themes = Themes

    -- ════════════════════════════════════════════════════
    -- Device detection (mobile / touch vs desktop)
    -- ════════════════════════════════════════════════════
    -- Prefer the platform hint from UserInputService. Some emulators expose
    -- both TouchEnabled and MouseEnabled; only classify as mobile when there
    -- is no mouse available AND touch is present.
    Library.IsTouch  = UserInputService.TouchEnabled == true
    Library.IsMobile = (UserInputService.TouchEnabled == true) and (UserInputService.MouseEnabled == false)

    -- Allow manual override for testing (before Library:Window is called).
    -- Users can call Library.ForceMobile = true to simulate mobile on desktop.
    Library.ForceMobile = false

    Library.IsMobileMode = function(self)
        if self.ForceMobile then
            return true
        end
        return self.IsMobile
    end

    -- ════════════════════════════════════════════════════
    -- Visual tokens & UX presets
    -- ════════════════════════════════════════════════════

    -- Corner radius scale. Kept lean — three utility values plus a Pill
    -- sentinel. Nothing should reach for arbitrary values off this scale.
    Library.Radius = {
        Xs     = 3,
        Small  = 4,
        Medium = 6,
        Large  = 10,
        Pill   = 999,
    }

    -- Spacing scale. Roblox pixel-space rather than rem, but the intent
    -- mirrors an 8-point-ish rhythm.
    Library.Spacing = {
        Hair   = 2,
        Tight  = 4,
        Snug   = 6,
        Normal = 8,
        Loose  = 12,
        Wide   = 16,
        Huge   = 24,
    }

    -- Type scale. Deliberately compact — product register wants a tight
    -- ratio (~1.15) so multi-element rows don't shout.
    Library.Text = {
        Micro   = 11,   -- tiniest label (ESC hint, keypad key)
        Small   = 12,   -- secondary labels, notif body, tooltips
        Body    = 13,   -- default control label
        Title   = 14,   -- section titles, main labels
        Head    = 15,   -- window / notification titles
    }

    -- Semantic z-index scale. Every layer above content sits on a bucket:
    -- controls and their strokes live in Base/Elevated, popovers and
    -- dropdowns claim Popover, the search backdrop sits in Modal, watermarks
    -- and keybind lists ride Toast, tooltips top everything else. No more
    -- "ZIndex = 2500" magic numbers scattered through the file.
    Library.Z = {
        Base     = 1,     -- section content
        Elevated = 20,    -- controls above section chrome
        Popover  = 250,   -- dropdown option lists, colorpicker window
        Modal    = 500,   -- search overlay backdrop + frame
        Toast    = 2000,  -- watermark, keybind list, notifications
        Tooltip  = 3000,  -- floating tooltip
        Overlay  = 5000,  -- reserved for anything that must beat everything
    }

    -- Notification type styling. Icon glyphs are single-character so they
    -- render in the shared Inter/InterBold fonts without needing an icon
    -- font. Colors reuse the semantic theme tokens above so a host that
    -- swaps the theme automatically restyles notifications too.
    Library.NotifTypes = {
        Info    = { Color = FromRGB(96, 156, 255),  Icon = "i", Theme = "Info"    },
        Success = { Color = FromRGB(78, 205, 148),  Icon = "+", Theme = "Success" },
        Warning = { Color = FromRGB(255, 190, 92),  Icon = "!", Theme = "Warning" },
        Error   = { Color = FromRGB(238, 96, 96),   Icon = "x", Theme = "Danger"  },
    }

    -- Notification queue/visibility limits
    Library.MaxNotifications  = 5
    Library.NotificationQueue = { }
    Library.ActiveNotifications = { }

    -- Global search registry (Ctrl+F across pages/subpages/sections)
    Library.SearchIndex = { }
    Library.SearchOverlayData = {
        Built = false,
        Frame = nil,
        Input = nil,
        Results = nil,
        Layout = nil,
        Visible = false,
        Window = nil,
    }

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        -- Active-tween registry: instance -> { [propName] = tweenWrapper }.
        -- Weak keys (__mode = "k") so destroyed instances don't leak registry entries.
        Tween.Active = setmetatable({}, { __mode = "k" })

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            -- Resolve motion (preset name / TweenInfo / nil) to a cached TweenInfo.
            Info = Library:GetMotion(Info)

            -- Cancel any existing tween on the same properties for this instance,
            -- so rapid/overlapping animations replace rather than stack.
            local Bucket = Tween.Active[Item]
            if Bucket then
                for Property in pairs(Goal) do
                    local Existing = Bucket[Property]
                    if Existing and Existing.Tween then
                        Existing.Tween:Cancel()
                    end
                    Bucket[Property] = nil
                end
            else
                Bucket = { }
                Tween.Active[Item] = Bucket
            end

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            setmetatable(NewTween, Tween)

            -- Register the new tween wrapper for each property in the bucket.
            for Property in pairs(Goal) do
                Bucket[Property] = NewTween
            end

            NewTween.Tween:Play()

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            self:Pause()

            -- Remove our own entries from the active-tween registry so we don't
            -- leak references. Only clear entries that still point to THIS wrapper,
            -- so a newer tween that replaced us on the same property is preserved.
            local Bucket = self.Item and Tween.Active[self.Item]
            if Bucket and self.Goal then
                for Property in pairs(self.Goal) do
                    if Bucket[Property] == self then
                        Bucket[Property] = nil
                    end
                end
            end

            self.Tween = nil
            self.Item = nil
            self.Goal = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local RawGui = self
            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            -- Target position updated on input events; a single guarded
            -- RenderStepped loop lerps toward it. This removes the previous
            -- per-frame tween allocation while dragging (Req 2.1, 2.3, 5.1).
            local Target = Gui.Position
            local SMOOTH = 0.35 -- 0 = instant follow, 1 = heavy smoothing

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    Target = Gui.Position

                    RawGui.Debounce = true 
                end
            end)

            self:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false

                    RawGui.Debounce = false 

                    -- Snap to the final target so the window settles exactly
                    -- with no residual motion (Req 2.4).
                    Gui.Position = Target
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        RawGui.Debounce = true 

                        local DragDelta = Input.Position - DragStart
                        Target = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function(dt)
                if not Dragging then 
                    return
                end

                local Alpha = 1 - (SMOOTH ^ (dt * 60)) -- frame-rate-independent lerp factor
                Gui.Position = Gui.Position:Lerp(Target, Alpha)
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local RawGui = self
            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            -- Target size updated on input events; a single guarded
            -- RenderStepped loop lerps toward it. This removes the previous
            -- per-frame tween allocation while resizing (Req 2.2, 2.3, 5.1).
            local Target = Gui.Size
            local SMOOTH = 0.35 -- 0 = instant follow, 1 = heavy smoothing

            local ResizeButton = Instances:Create("TextButton", {
                Parent = Gui,
                AnchorPoint = Vector2New(1, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 10, 0, 10),
                Position = UDim2New(1, 0, 1, 0),
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                ZIndex = Library.Z.Popover,
                Visible = true,
                Text = ""
            })

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                    Target = Gui.Size
                end
            end)

            ResizeButton:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false

                    -- Snap to the final target so the window settles exactly
                    -- with no residual motion (Req 2.4).
                    Gui.Size = Target
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Resizing and not RawGui.Debounce then
					ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

					Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
					Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

					Target = Delta
                end
            end)

            Library:Connect(RunService.RenderStepped, function(dt)
                if not Resizing then 
                    return
                end

                local Alpha = 1 - (SMOOTH ^ (dt * 60)) -- frame-rate-independent lerp factor
                Gui.Size = Gui.Size:Lerp(Target, Alpha)
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Inter", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
        })

        CustomFont:New("InterBold", 200, "Bold", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterBold.ttf"
        })

        Library.Font = CustomFont:Get("Inter")
        Library.BoldFont = CustomFont:Get("InterBold")
    end

    -- Library
    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        Enabled = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        BorderColor3 = FromRGB(0, 0, 0),
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2New(0, 15, 0, 55),
        Size = UDim2New(0, 0, 1, -55),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Padding = UDimNew(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    }) 

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    -- ════════════════════════════════════════════════════
    -- Convenience helpers
    -- ════════════════════════════════════════════════════
    Library.AutoHideScrollbar = function(self, Scroller, Hover)
        local Inst = Scroller.Instance or Scroller
        local HoverInst = (Hover and (Hover.Instance or Hover)) or Inst

        Inst.ScrollBarImageTransparency = 1

        Library:Connect(HoverInst.MouseEnter, function()
            Tween:Create(Inst, "Default", {ScrollBarImageTransparency = 0}, true)
        end)

        Library:Connect(HoverInst.MouseLeave, function()
            Tween:Create(Inst, "Panel", {ScrollBarImageTransparency = 1}, true)
        end)
    end

    Library.AddDropShadow = function(self, Parent, Options)
        Options = Options or { }

        local Shadow = Instances:Create("ImageLabel", {
            Parent = Parent.Instance or Parent,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Image = "rbxassetid://112971167999062",
            ImageColor3 = Options.Color or FromRGB(0, 0, 0),
            ImageTransparency = Options.Transparency or 0.55,
            Position = UDim2New(0.5, 0, 0.5, 0),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
            SliceScale = Options.SliceScale or 0.6,
            Size = UDim2New(1, Options.Padding or 36, 1, Options.Padding or 36),
            ZIndex = Options.ZIndex or -1,
            BackgroundColor3 = FromRGB(255, 255, 255),
        })

        if Options.AccentTinted then 
            Shadow:AddToTheme({ImageColor3 = "Accent"})
        end

        return Shadow
    end

    Library.AddFocusGlow = function(self, Stroke, Trigger)
        local StrokeInst = Stroke.Instance or Stroke
        local TriggerInst = Trigger.Instance or Trigger
        local Original = StrokeInst.Color

        if TriggerInst:IsA("TextBox") then 
            Library:Connect(TriggerInst.Focused, function()
                Stroke:ChangeItemTheme({Color = "Accent"})
                Tween:Create(StrokeInst, nil, {Color = Library.Theme.Accent, Thickness = 1.4}, true)
            end)

            Library:Connect(TriggerInst.FocusLost, function()
                Stroke:ChangeItemTheme({Color = "Border"})
                Tween:Create(StrokeInst, nil, {Color = Library.Theme.Border, Thickness = 1}, true)
            end)
        else
            Library:Connect(TriggerInst.MouseEnter, function()
                Tween:Create(StrokeInst, "Hover", {Color = Library.Theme.Accent}, true)
            end)
            Library:Connect(TriggerInst.MouseLeave, function()
                Tween:Create(StrokeInst, "Hover", {Color = Original}, true)
            end)
        end
    end

    -- Motion preset base specifications { duration, easingStyle, easingDirection }.
    -- Library.Motion holds the cached, scale-applied TweenInfo objects built from these.
    -- Durations sit in the 80-260 ms band for interactive feedback; product
    -- register work stays clear of the 300-500 ms "cinematic" range that
    -- makes tools feel sluggish. Quart / Quint out curves throughout — no
    -- bounce, no elastic (both explicitly banned by the design system).
    local MotionPresets = {
        Instant = { 0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out },
        Hover   = { 0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out },
        Default = { 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out },
        Slide   = { 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out },
        Panel   = { 0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out },
        Slow    = { 0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out },
        Linear  = { 1.00, Enum.EasingStyle.Linear, Enum.EasingDirection.Out },
    }

    local MotionScaleApplied = nil

    local function RebuildMotion()
        local Scale = Library.MotionScale or 1
        if Scale <= 0 then
            Scale = 1
        end

        for Name, Spec in pairs(MotionPresets) do
            Library.Motion[Name] = TweenInfo.new(Spec[1] * Scale, Spec[2], Spec[3])
        end

        MotionScaleApplied = Library.MotionScale
    end

    -- Resolve a motion request to a cached TweenInfo.
    --  * preset name string -> cached preset (rebuilt only if MotionScale changed)
    --  * TweenInfo          -> returned as-is (backward compat with inline callers)
    --  * nil / unknown name -> Default preset
    -- DurationOverride builds a fresh scaled TweenInfo using the resolved preset's easing
    -- (e.g. the Linear progress-bar tween that scales its duration).
    Library.GetMotion = function(self, NameOrInfo, DurationOverride)
        if MotionScaleApplied ~= self.MotionScale then
            RebuildMotion()
        end

        if typeof(NameOrInfo) == "TweenInfo" then
            return NameOrInfo
        end

        local PresetName = "Default"
        if type(NameOrInfo) == "string" and MotionPresets[NameOrInfo] then
            PresetName = NameOrInfo
        end

        if DurationOverride then
            local Spec = MotionPresets[PresetName]
            local Scale = self.MotionScale or 1
            if Scale <= 0 then
                Scale = 1
            end

            return TweenInfo.new(DurationOverride * Scale, Spec[2], Spec[3])
        end

        return self.Motion[PresetName]
    end

    Library.Ripple = function(self, Host, X, Y, Color)
        local HostInst = Host.Instance or Host
        if not HostInst or not HostInst.Parent then 
            return
        end

        local OldClips = HostInst.ClipsDescendants
        HostInst.ClipsDescendants = true

        local AbsPos = HostInst.AbsolutePosition
        local AbsSize = HostInst.AbsoluteSize

        local LocalX = (X or (AbsPos.X + AbsSize.X / 2)) - AbsPos.X
        local LocalY = (Y or (AbsPos.Y + AbsSize.Y / 2)) - AbsPos.Y

        local MaxDistance = math.sqrt(AbsSize.X * AbsSize.X + AbsSize.Y * AbsSize.Y)

        local Ripple = InstanceNew("Frame")
        Ripple.Name = "\0"
        Ripple.AnchorPoint = Vector2New(0.5, 0.5)
        Ripple.Position = UDim2New(0, LocalX, 0, LocalY)
        Ripple.Size = UDim2New(0, 0, 0, 0)
        Ripple.BackgroundColor3 = Color or FromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.7
        Ripple.BorderSizePixel = 0
        Ripple.ZIndex = (HostInst.ZIndex or 1) + 1
        Ripple.Parent = HostInst

        local Corner = InstanceNew("UICorner")
        Corner.CornerRadius = UDimNew(1, 0)
        Corner.Parent = Ripple

        Tween:Create(Ripple, "Slow", {
            Size = UDim2New(0, MaxDistance * 2, 0, MaxDistance * 2),
            BackgroundTransparency = 1,
        }, true)

        task.delay(0.5, function()
            if Ripple and Ripple.Parent then 
                Ripple:Destroy()
            end
            if HostInst and HostInst.Parent then 
                HostInst.ClipsDescendants = OldClips
            end
        end)
    end

    -- Consistent hover feedback: tween an instance toward HoverGoal on MouseEnter and
    -- back toward RestGoal on MouseLeave, routed through the Hover preset (or Preset).
    -- Inst may be an Instances wrapper (has .Instance) or a raw Roblox GUI instance.
    Library.Hover = function(self, Inst, HoverGoal, RestGoal, Preset)
        local RawInst = Inst and (Inst.Instance or Inst)
        if not RawInst or not HoverGoal or not RestGoal then 
            return
        end

        local PresetName = Preset or "Hover"

        local EnterConnection = Library:Connect(RawInst.MouseEnter, function()
            if not RawInst or not RawInst.Parent then 
                return
            end
            Tween:Create(RawInst, PresetName, HoverGoal, true)
        end)

        local LeaveConnection = Library:Connect(RawInst.MouseLeave, function()
            if not RawInst or not RawInst.Parent then 
                return
            end
            Tween:Create(RawInst, PresetName, RestGoal, true)
        end)

        return EnterConnection, LeaveConnection
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance or Frame

        local AbsolutePosition = Frame.AbsolutePosition
        local AbsoluteSize = Frame.AbsoluteSize

        if Mouse.X >= AbsolutePosition.X and Mouse.X <= AbsolutePosition.X + AbsoluteSize.X and Mouse.Y >= AbsolutePosition.Y and Mouse.Y <= AbsolutePosition.Y + AbsoluteSize.Y then    
            return true
        end

        return false 
    end

    Library.GetDescription = function(self, Data)
        if type(Data) ~= "table" then 
            return nil
        end

        local Description = Data.Desc or Data.Description or Data.desc or Data.description
        if type(Description) == "string" and Description ~= "" then 
            return Description
        end

        return nil
    end

    -- ════════════════════════════════════════════════════
    -- Tooltips
    -- ════════════════════════════════════════════════════
    Library.TooltipData = {
        Built = false,
        Frame = nil,
        Label = nil,
        Shown = false,
        Connection = nil,
    }

    Library.BuildTooltip = function(self)
        if self.TooltipData.Built then
            return
        end
        self.TooltipData.Built = true

        local Frame = Instances:Create("Frame", {
            Parent = self.Holder.Instance,
            Name = "\0",
            BackgroundColor3 = self.Theme.Inline,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2New(0, 0, 0, 0),
            ZIndex = self.Z.Tooltip
        })  Frame:AddToTheme({BackgroundColor3 = "Inline"})

        Instances:Create("UICorner", {
            Parent = Frame.Instance,
            CornerRadius = UDimNew(0, self.Radius.Small)
        })

        Instances:Create("UIStroke", {
            Parent = Frame.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        Instances:Create("UIPadding", {
            Parent = Frame.Instance,
            PaddingTop    = UDimNew(0, 6),
            PaddingBottom = UDimNew(0, 6),
            PaddingLeft   = UDimNew(0, 10),
            PaddingRight  = UDimNew(0, 10)
        })

        local Label = Instances:Create("TextLabel", {
            Parent = Frame.Instance,
            FontFace = self.Font,
            Text = "",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2New(0, 0, 0, 0),
            TextSize = self.Text.Small,
            ZIndex = self.Z.Tooltip + 1
        })  Label:AddToTheme({TextColor3 = "Text"})

        Instances:Create("UISizeConstraint", {
            Parent = Label.Instance,
            MaxSize = Vector2New(280, math.huge)
        })

        self.TooltipData.Frame = Frame
        self.TooltipData.Label = Label
    end

    Library.ShowTooltip = function(self, Text)
        self:BuildTooltip()

        local Data = self.TooltipData
        Data.Label.Instance.Text = tostring(Text or "")
        Data.Shown = true
        Data.Frame.Instance.Visible = true

        if not Data.Connection then 
            Data.Connection = self:Connect(RunService.RenderStepped, function()
                if not Data.Shown then 
                    return
                end

                local Location = UserInputService:GetMouseLocation()
                local FrameSize = Data.Frame.Instance.AbsoluteSize
                local Viewport = Camera.ViewportSize

                local X = Location.X + 16
                local Y = Location.Y + 12

                if X + FrameSize.X > Viewport.X then 
                    X = Location.X - FrameSize.X - 8
                end

                if Y + FrameSize.Y > Viewport.Y then 
                    Y = Location.Y - FrameSize.Y - 8
                end

                Data.Frame.Instance.Position = UDim2New(0, X, 0, Y)
            end)
        end
    end

    Library.HideTooltip = function(self)
        local Data = self.TooltipData
        Data.Shown = false

        if Data.Frame then 
            Data.Frame.Instance.Visible = false
        end
    end

    Library.BindTooltip = function(self, Wrapper, Text)
        if not Wrapper or type(Text) ~= "string" or Text == "" then 
            return
        end

        local Instance = Wrapper.Instance or Wrapper

        self:Connect(Instance.MouseEnter, function()
            self:ShowTooltip(Text)
        end)

        self:Connect(Instance.MouseLeave, function()
            self:HideTooltip()
        end)
    end

    -- Subtle hover highlight for box style controls (Element coloured)
    Library.AddBoxHover = function(self, Wrapper)
        if not Wrapper or not Wrapper.Instance then 
            return
        end

        self:Connect(Wrapper.Instance.MouseEnter, function()
            Wrapper:Tween("Hover", {BackgroundColor3 = FromRGB(28, 28, 38)})
        end)

        self:Connect(Wrapper.Instance.MouseLeave, function()
            Wrapper:Tween("Hover", {BackgroundColor3 = self.Theme.Element})
        end)
    end

    -- ════════════════════════════════════════════════════
    -- Watermark / status bar
    -- ════════════════════════════════════════════════════
    Library.WatermarkData = {
        Built = false,
        Frame = nil,
        Label = nil,
        Enabled = false,
        Title = "CATS.GG",
        Frames = 0,
        FPS = 60,
        Clock = 0,
        Connection = nil,
    }

    Library.BuildWatermark = function(self)
        if self.WatermarkData.Built then
            return
        end
        self.WatermarkData.Built = true

        local Frame = Instances:Create("Frame", {
            Parent = self.Holder.Instance,
            Name = "\0",
            BackgroundColor3 = self.Theme.Background,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2New(0, 16, 0, 16),
            Size = UDim2New(0, 0, 0, 28),
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = self.Z.Toast,
            Visible = false
        })  Frame:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UICorner", {
            Parent = Frame.Instance,
            CornerRadius = UDimNew(0, self.Radius.Medium)
        })

        Instances:Create("UIStroke", {
            Parent = Frame.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        -- Status dot next to the title. Replaces the previous 2px left-edge
        -- stripe with a filled accent circle — reads as a live-status
        -- indicator rather than as a border decoration. Sized so it aligns
        -- visually with the baseline of the surrounding text.
        local StatusDot = Instances:Create("Frame", {
            Parent = Frame.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0, 0.5),
            Position = UDim2New(0, 12, 0.5, 0),
            Size = UDim2New(0, 7, 0, 7),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = self.Z.Toast + 1,
            BackgroundColor3 = self.Theme.Accent
        })  StatusDot:AddToTheme({BackgroundColor3 = "Accent"})

        Instances:Create("UICorner", {
            Parent = StatusDot.Instance,
            CornerRadius = UDimNew(1, 0)
        })

        local Label = Instances:Create("TextLabel", {
            Parent = Frame.Instance,
            FontFace = self.Font,
            Text = "CATS.GG",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2New(0, 0, 1, 0),
            Position = UDim2New(0, 26, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = self.Text.Body,
            ZIndex = self.Z.Toast + 1
        })  Label:AddToTheme({TextColor3 = "Text"})

        Instances:Create("UIPadding", {
            Parent = Frame.Instance,
            PaddingRight = UDimNew(0, 14)
        })

        Frame:MakeDraggable()

        self.WatermarkData.Frame = Frame
        self.WatermarkData.Label = Label
    end

    Library.Watermark = function(self, Title)
        self:BuildWatermark()

        if Title then 
            self.WatermarkData.Title = tostring(Title)
        end

        self.WatermarkData.Enabled = true
        self.WatermarkData.Frame.Instance.Visible = true

        if not self.WatermarkData.Connection then 
            self.WatermarkData.Connection = self:Connect(RunService.RenderStepped, function(dt)
                local WD = self.WatermarkData
                WD.Frames = WD.Frames + 1
                WD.Clock = WD.Clock + dt

                if WD.Clock >= 0.5 then 
                    WD.FPS = MathFloor(WD.Frames / WD.Clock + 0.5)
                    WD.Frames = 0
                    WD.Clock = 0

                    local Ping = 0
                    pcall(function()
                        Ping = MathFloor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                    end)

                    if WD.Label and WD.Enabled then 
                        WD.Label.Instance.Text = StringFormat("%s  |  %d fps  |  %d ms  |  %s", WD.Title, WD.FPS, Ping, os.date("%H:%M:%S"))
                    end
                end
            end)
        end

        return self.WatermarkData
    end

    Library.SetWatermarkVisible = function(self, Bool)
        self:BuildWatermark()
        self.WatermarkData.Enabled = Bool and true or false
        self.WatermarkData.Frame.Instance.Visible = self.WatermarkData.Enabled
    end

    -- ════════════════════════════════════════════════════
    -- Active keybind list
    -- ════════════════════════════════════════════════════
    Library.KeybindListData = {
        Built = false,
        Frame = nil,
        Container = nil,
        Title = nil,
        Enabled = true,
        Entries = { },
        Connection = nil,
        Clock = 0,
    }

    Library.BuildKeybindList = function(self)
        if self.KeybindListData.Built then
            return
        end
        self.KeybindListData.Built = true

        local Frame = Instances:Create("Frame", {
            Parent = self.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(1, 0),
            Position = UDim2New(1, -16, 0, 16),
            Size = UDim2New(0, 180, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = self.Theme.Background,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = self.Z.Toast,
            Visible = false
        })  Frame:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UICorner", {
            Parent = Frame.Instance,
            CornerRadius = UDimNew(0, self.Radius.Medium)
        })

        Instances:Create("UIStroke", {
            Parent = Frame.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        local Title = Instances:Create("TextLabel", {
            Parent = Frame.Instance,
            FontFace = self.BoldFont,
            Text = "Keybinds",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, -20, 0, 16),
            Position = UDim2New(0, 10, 0, 6),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = self.Text.Body,
            ZIndex = self.Z.Toast + 1
        })  Title:AddToTheme({TextColor3 = "Text"})

        Instances:Create("Frame", {
            Parent = Frame.Instance,
            Size = UDim2New(1, -20, 0, 1),
            Position = UDim2New(0, 10, 0, 26),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = self.Z.Toast + 1,
            BackgroundTransparency = 0.4,
            BackgroundColor3 = self.Theme.Border
        }):AddToTheme({BackgroundColor3 = "Border"})

        local Container = Instances:Create("Frame", {
            Parent = Frame.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2New(0, 0, 0, 30),
            Size = UDim2New(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = self.Z.Toast + 1
        })

        Instances:Create("UIListLayout", {
            Parent = Container.Instance,
            Padding = UDimNew(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Instances:Create("UIPadding", {
            Parent = Container.Instance,
            PaddingTop    = UDimNew(0, 4),
            PaddingBottom = UDimNew(0, 8),
            PaddingLeft   = UDimNew(0, 10),
            PaddingRight  = UDimNew(0, 10)
        })

        self.KeybindListData.Frame = Frame
        self.KeybindListData.Container = Container
        self.KeybindListData.Title = Title

        -- Throttled driver so entries reflect live toggle state without
        -- editing every keybind callback path.
        self.KeybindListData.Connection = self:Connect(RunService.RenderStepped, function(dt)
            local KD = self.KeybindListData
            KD.Clock = KD.Clock + dt
            if KD.Clock < 0.15 then 
                return
            end
            KD.Clock = 0

            for _, Entry in KD.Entries do 
                Entry:Update()
            end

            self:UpdateKeybindListVisibility()
        end)
    end

    Library.UpdateKeybindListVisibility = function(self)
        local KD = self.KeybindListData
        if not KD.Built then 
            return
        end

        local AnyShown = false
        for _, Entry in KD.Entries do 
            if Entry.Shown then 
                AnyShown = true
                break
            end
        end

        KD.Frame.Instance.Visible = KD.Enabled and AnyShown
    end

    Library.SetKeybindListVisible = function(self, Bool)
        self:BuildKeybindList()
        self.KeybindListData.Enabled = Bool and true or false
        self:UpdateKeybindListVisibility()
    end

    Library.RegisterKeybindEntry = function(self, Getter)
        self:BuildKeybindList()

        local KD = self.KeybindListData

        local Row = Instances:Create("Frame", {
            Parent = KD.Container.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2New(1, 0, 0, 16),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Visible = false,
            ZIndex = self.Z.Toast + 2
        })

        local NameLabel = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = self.Font,
            Text = "",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, -55, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextSize = self.Text.Body,
            ZIndex = self.Z.Toast + 2
        })  NameLabel:AddToTheme({TextColor3 = "Text"})

        -- Key is rendered as a tabular badge — bold monospace-ish weight so
        -- multiple keybind rows align cleanly vertically.
        local KeyLabel = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = self.BoldFont,
            Text = "",
            TextColor3 = self.Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            AnchorPoint = Vector2New(1, 0),
            Position = UDim2New(1, 0, 0, 0),
            Size = UDim2New(0, 55, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextSize = self.Text.Small,
            ZIndex = self.Z.Toast + 2
        })  KeyLabel:AddToTheme({TextColor3 = "Accent"})

        local Entry = {
            Row = Row,
            NameLabel = NameLabel,
            KeyLabel = KeyLabel,
            Shown = false,
        }

        function Entry:Update()
            local Info = Getter()
            if type(Info) ~= "table" then 
                Entry.Shown = false
                Row.Instance.Visible = false
                return
            end

            local Bound = Info.Key ~= nil and Info.Key ~= "None" and Info.Key ~= ""
            local Active = Info.Active == true

            Entry.Shown = Bound and Active

            if Entry.Shown then 
                NameLabel.Instance.Text = tostring(Info.Name or "Keybind")
                KeyLabel.Instance.Text = tostring(Info.Key)
            end

            Row.Instance.Visible = Entry.Shown
        end

        function Entry:Remove()
            Entry.Shown = false
            Row:Clean()

            local Index = TableFind(KD.Entries, Entry)
            if Index then 
                TableRemove(KD.Entries, Index)
            end

            Library:UpdateKeybindListVisibility()
        end

        TableInsert(KD.Entries, Entry)
        return Entry
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            if Value.Connection then
                Value.Connection:Disconnect()
            end
        end

        for Index, Value in self.Threads do 
            pcall(coroutine.close, Value)
        end

        for Instance, Bucket in pairs(Tween.Active) do
            for Property, Wrapper in pairs(Bucket) do
                if Wrapper and Wrapper.Tween then
                    pcall(function()
                        Wrapper.Tween:Cancel()
                    end)
                end
            end
        end

        if self.Holder then 
            self.Holder:Clean()
        end
        
        getgenv().Library = nil
        Library = nil 
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error!", "Error caught in function, report this to the devs:\n"..Result, 5)
            return false, Result
        end

        return Success, Result
    end

    Library.Connect = function(self, Event, Callback, Name)
        self.UnnamedConnections += 1
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        NewConnection.Connection = Event:Connect(Callback)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                if Connection.Connection then
                    Connection.Connection:Disconnect()
                end
                break
            end
        end
    end

    Library.NextFlag = function(self)
        self.UnnamedFlags += 1
        local FlagNumber = self.UnnamedFlags
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = self:SafeCall(function()
            for Index, Value in self.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = self:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = self.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(self.Folders.Configs .. "/" .. Config) then 
            delfile(self.Folders.Configs .. "/" .. Config)
            self:Notification("Success", "Deleted config " .. Config, 5)
        end
    end

    Library.SaveConfig = function(self, Config)
        writefile(self.Folders.Configs .. "/" .. Config, self:GetConfig())
        self:Notification("Success", "Saved config " .. Config, 5)
    end

    Library.RefreshConfigsList = function(self, Element)
        self._CurrentConfigList = self._CurrentConfigList or { }
        local CurrentList = self._CurrentConfigList
        local List = { }

        local ConfigFolderName = StringGSub(self.Folders.Configs, self.Folders.Directory .. "/", "")

        for Index, Value in listfiles(self.Folders.Configs) do
            local FileName = StringGSub(Value, self.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= #CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        end

        if IsNew then
            self._CurrentConfigList = List
            Element:Refresh(List)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return {"BackgroundTransparency"}
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed, Delay)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local Info = TweenInfo.new(
            Speed or Library.Tween.Time,
            Library.Tween.Style,
            Library.Tween.Direction,
            0,
            false,
            tonumber(Delay) or 0
        )

        local NewTween = Tween:Create(Item, Info, {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    -- ════════════════════════════════════════════════════
    -- Notifications (typed, queued, with progress + handle)
    -- ════════════════════════════════════════════════════
    Library._BuildNotification = function(self, Options)
        local TypeData = self.NotifTypes[Options.Type] or self.NotifTypes.Info

        local Items = { }

        -- Card. No side stripe. Type is carried by the icon badge and the
        -- timeout fill; the surface itself stays neutral so a wall of five
        -- notifications doesn't read as five colored bars.
        Items["Notification"] = Instances:Create("Frame", {
            Parent = self.NotifHolder.Instance,
            Name = "\0",
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2New(0, 305, 0, 0),
            ClipsDescendants = true,
            BackgroundColor3 = self.Theme.Inline
        })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Inline"})

        Instances:Create("UICorner", {
            Parent = Items["Notification"].Instance,
            CornerRadius = UDimNew(0, self.Radius.Large)
        })

        Instances:Create("UIStroke", {
            Parent = Items["Notification"].Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        Instances:Create("UIPadding", {
            Parent = Items["Notification"].Instance,
            PaddingTop    = UDimNew(0, 12),
            PaddingBottom = UDimNew(0, 14),
            PaddingLeft   = UDimNew(0, 14),
            PaddingRight  = UDimNew(0, 14),
        })

        -- Type badge: a round, filled dot with the type glyph inset. No
        -- external halo — the color is already the loudest thing on the
        -- card and doesn't need a second decoration to be legible.
        Items["IconRing"] = Instances:Create("Frame", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            Size = UDim2New(0, 20, 0, 20),
            Position = UDim2New(0, 0, 0, 1),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = self.Z.Base + 4,
            BackgroundColor3 = TypeData.Color,
        })

        Instances:Create("UICorner", {
            Parent = Items["IconRing"].Instance,
            CornerRadius = UDimNew(1, 0)
        })

        Items["IconText"] = Instances:Create("TextLabel", {
            Parent = Items["IconRing"].Instance,
            Name = "\0",
            FontFace = self.BoldFont,
            Text = TypeData.Icon,
            TextColor3 = FromRGB(20, 20, 26),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, 0, 1, 0),
            TextSize = self.Text.Body,
            ZIndex = self.Z.Base + 5,
        })

        -- Title + body live to the right of the badge. Both indent under
        -- the same content column so wrapping stays clean.
        local ContentInset = 30  -- badge width (20) + gap (10)

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["Notification"].Instance,
            FontFace = self.BoldFont,
            TextColor3 = self.Theme.Text,
            BorderColor3 = FromRGB(0, 0, 0),
            Text = tostring(Options.Title or ""),
            Name = "\0",
            Position = UDim2New(0, ContentInset, 0, 1),
            Size = UDim2New(1, -ContentInset, 0, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = self.Text.Title,
            BackgroundColor3 = FromRGB(255, 255, 255),
            ZIndex = self.Z.Base + 2,
        })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["Description"] = Instances:Create("TextLabel", {
            Parent = Items["Notification"].Instance,
            FontFace = self.Font,
            TextWrapped = true,
            Name = "====sa0dSA=DSAJGjmsaM",
            TextColor3 = self.Theme.MutedText,
            Text = tostring(Options.Description or ""),
            Position = UDim2New(0, ContentInset, 0, 22),
            Size = UDim2New(1, -ContentInset, 0, 14),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = self.Text.Small,
            BackgroundColor3 = FromRGB(255, 255, 255),
            ZIndex = self.Z.Base + 2,
        })  Items["Description"]:AddToTheme({TextColor3 = "MutedText"})

        -- Timeout indicator: a thin colored line pinned to the very bottom
        -- of the card. Spills through the padding via negative offsets so
        -- it reaches edge-to-edge (ClipsDescendants keeps it inside the
        -- rounded corners).
        Items["ProgressTrack"] = Instances:Create("Frame", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0, 1),
            Position = UDim2New(0, -14, 1, 14),
            Size = UDim2New(1, 28, 0, 2),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            BackgroundTransparency = 0.75,
            ZIndex = self.Z.Base + 3,
            BackgroundColor3 = self.Theme.Border,
        })  Items["ProgressTrack"]:AddToTheme({BackgroundColor3 = "Border"})

        Items["ProgressFill"] = Instances:Create("Frame", {
            Parent = Items["ProgressTrack"].Instance,
            Name = "\0",
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, 0, 1, 0),
            ZIndex = self.Z.Base + 4,
            BackgroundColor3 = TypeData.Color,
        })

        -- Legacy alias so external code that referenced Items["Strip"]
        -- keeps a target. It's a zero-size invisible frame; we no longer
        -- render a side stripe.
        Items["Strip"] = Instances:Create("Frame", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            Size = UDim2New(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            BorderColor3 = FromRGB(0, 0, 0),
            BackgroundColor3 = TypeData.Color,
        })

        return Items, TypeData
    end

    Library._ShowNotificationFromQueue = function(self)
        if #self.NotificationQueue == 0 then 
            return
        end

        if #self.ActiveNotifications >= self.MaxNotifications then 
            return
        end

        local Entry = TableRemove(self.NotificationQueue, 1)
        if not Entry then 
            return
        end

        Entry:_Show()
    end

    Library.Notification = function(self, ...)
        local Args = { ... }
        local Options

        if type(Args[1]) == "table" then 
            Options = Args[1]
        else
            Options = {
                Title       = Args[1],
                Description = Args[2],
                Duration    = Args[3],
                Type        = Args[4],
            }
        end

        Options.Title       = tostring(Options.Title or "Notification")
        Options.Description = tostring(Options.Description or "")
        Options.Duration    = tonumber(Options.Duration) or 5
        Options.Type        = Options.Type or "Info"

        -- Heuristic: pick a sensible default type from the title so legacy
        -- callsites like Library:Notification("Success", ...) auto-style.
        if Options.Type == "Info" then 
            local LowerTitle = StringLower(Options.Title)
            if StringFind(LowerTitle, "error") or StringFind(LowerTitle, "fail") then 
                Options.Type = "Error"
            elseif StringFind(LowerTitle, "warn") then 
                Options.Type = "Warning"
            elseif StringFind(LowerTitle, "success") or StringFind(LowerTitle, "saved") or StringFind(LowerTitle, "loaded") then 
                Options.Type = "Success"
            end
        end

        if not self.NotifTypes[Options.Type] then 
            Options.Type = "Info"
        end

        local Notification = {
            Options = Options,
            Items = nil,
            TypeData = nil,
            Closed = false,
            Shown = false,
            ProgressTween = nil,
            CloseThread = nil,
        }

        function Notification:_Show()
            if Notification.Shown or Notification.Closed then 
                return
            end
            Notification.Shown = true

            local Items, TypeData = Library:_BuildNotification(Options)
            Notification.Items = Items
            Notification.TypeData = TypeData

            TableInsert(Library.ActiveNotifications, Notification)

            local Frame = Items["Notification"].Instance

            -- Initial hidden state for slide+fade in
            Frame.BackgroundTransparency = 1
            Frame.Position = UDim2New(0, -20, 0, 0)
            for _, Descendant in Frame:GetDescendants() do 
                if Descendant:IsA("UIStroke") then 
                    Descendant.Transparency = 1
                elseif Descendant:IsA("TextLabel") then 
                    Descendant.TextTransparency = 1
                elseif Descendant:IsA("Frame") then 
                    Descendant.BackgroundTransparency = 1
                end
            end

            Library:Thread(function()
                Items["Notification"]:Tween(nil, {BackgroundTransparency = 0})
                Tween:Create(Frame, "Panel", {Position = UDim2New(0, 0, 0, 0)}, true)

                task.wait(0.05)

                for _, Descendant in Frame:GetDescendants() do 
                    if Descendant:IsA("UIStroke") then 
                        Tween:Create(Descendant, nil, {Transparency = 0}, true)
                    elseif Descendant:IsA("TextLabel") then 
                        if Descendant.Name == "====sa0dSA=DSAJGjmsaM" then 
                            Tween:Create(Descendant, nil, {TextTransparency = 0.45}, true)
                        else
                            Tween:Create(Descendant, nil, {TextTransparency = 0}, true)
                        end
                    elseif Descendant:IsA("Frame") then 
                        if Descendant == Items["ProgressTrack"].Instance then 
                            Tween:Create(Descendant, nil, {BackgroundTransparency = 0.7}, true)
                        else
                            Tween:Create(Descendant, nil, {BackgroundTransparency = 0}, true)
                        end
                    end
                end

                -- Drive progress bar from full → empty
                Notification.ProgressTween = Tween:Create(
                    Items["ProgressFill"].Instance,
                    Library:GetMotion("Linear", Options.Duration),
                    {Size = UDim2New(0, 0, 1, 0)},
                    true
                )

                Notification.CloseThread = task.delay(Options.Duration, function()
                    Notification:Close()
                end)
            end)
        end

        function Notification:Close()
            if Notification.Closed then 
                return
            end
            Notification.Closed = true

            local Index = TableFind(Library.ActiveNotifications, Notification)
            if Index then 
                TableRemove(Library.ActiveNotifications, Index)
            end

            if not Notification.Shown or not Notification.Items then 
                Library:_ShowNotificationFromQueue()
                return
            end

            if Notification.ProgressTween then 
                Notification.ProgressTween:Pause()
                Notification.ProgressTween = nil
            end

            local Items = Notification.Items
            local Frame = Items["Notification"].Instance

            Library:Thread(function()
                for _, Descendant in Frame:GetDescendants() do 
                    if Descendant:IsA("UIStroke") then 
                        Tween:Create(Descendant, nil, {Transparency = 1}, true)
                    elseif Descendant:IsA("TextLabel") then 
                        Tween:Create(Descendant, nil, {TextTransparency = 1}, true)
                    elseif Descendant:IsA("Frame") then 
                        Tween:Create(Descendant, nil, {BackgroundTransparency = 1}, true)
                    end
                end

                task.wait(0.06)

                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1})
                Tween:Create(Frame, nil, {Position = UDim2New(0, -30, 0, 0), Size = UDim2New(0, 0, 0, 0)}, true)

                task.wait(0.4)
                Items["Notification"]:Clean()

                Library:_ShowNotificationFromQueue()
            end)
        end

        function Notification:SetTitle(Text)
            Options.Title = tostring(Text or "")
            if Notification.Items and Notification.Items["Title"] then 
                Notification.Items["Title"].Instance.Text = Options.Title
            end
        end

        function Notification:SetDescription(Text)
            Options.Description = tostring(Text or "")
            if Notification.Items and Notification.Items["Description"] then 
                Notification.Items["Description"].Instance.Text = Options.Description
            end
        end

        function Notification:Update(Patch)
            if type(Patch) ~= "table" then 
                return
            end
            if Patch.Title ~= nil then 
                Notification:SetTitle(Patch.Title)
            end
            if Patch.Description ~= nil then 
                Notification:SetDescription(Patch.Description)
            end
            if Patch.Type ~= nil and Library.NotifTypes[Patch.Type] and Notification.Items then 
                local NewType = Library.NotifTypes[Patch.Type]
                Notification.TypeData = NewType
                Notification.Items["Strip"]:Tween(nil, {BackgroundColor3 = NewType.Color})
                Notification.Items["IconRing"]:Tween(nil, {BackgroundColor3 = NewType.Color})
                Notification.Items["IconText"].Instance.Text = NewType.Icon
                Notification.Items["ProgressFill"]:Tween(nil, {BackgroundColor3 = NewType.Color})
            end
        end

        function Notification:SetProgress(Value)
            -- Manual progress 0..1 (pauses auto-deplete)
            if Notification.ProgressTween then 
                Notification.ProgressTween:Pause()
                Notification.ProgressTween = nil
            end

            if Notification.Items and Notification.Items["ProgressFill"] then 
                local Clamped = MathClamp(tonumber(Value) or 0, 0, 1)
                Notification.Items["ProgressFill"]:Tween(nil, {Size = UDim2New(Clamped, 0, 1, 0)})
            end
        end

        TableInsert(self.NotificationQueue, Notification)
        self:_ShowNotificationFromQueue()

        return Notification
    end

    Library.CreateColorpicker = function(self, Data)
        Data = Data or { }
        
        local Colorpicker = {
            Window = Data.Window,
            Tab = Data.Tab,
            Section = Data.Section,

            Flag = Data.Flag,

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            Color = FromRGB(0, 0, 0),
            HexValue = "",
            
            IsOpen = false,
        }

        Library.Flags[Colorpicker.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                BorderSizePixel = 0,
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 15, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            local CalculateCount = function(Index)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - ButtonSize.X
            
                -- Colorpicker chips are offset further left when attached
                -- to a toggle so they clear the new wider 28px pill switch.
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, Data.IsToggle and -XPosition - 32 or -XPosition, 0.5, 0)
            end

            CalculateCount(Data.Count)

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 25, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 243, 0, 213),
                Visible = false,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ImageTransparency = 0.35,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.7,
                Name = "\0",
                Size = UDim2New(1, 80, 1, 80),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -60),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0, 10),
                Size = UDim2New(0, 8, 0, 8),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Position = UDim2New(0, 0, 1, -35),
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 14),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Alpha"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Checkers"].Instance,
                CornerRadius = UDimNew(0, 6)
            }) 

            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 2),
                Size = UDim2New(0, 10, 0, 10),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["AlphaDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, -40),
                Size = UDim2New(1, 0, 0, 14),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 15, 0, 2),
                Size = UDim2New(0, 10, 0, 10),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 8),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            }) 

            Items["RainbowToggle"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["RainbowToggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "Rainbow",
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            -- Rainbow toggle. Mirrors the main Toggle pill exactly — same
            -- rest/active colors, same sliding thumb, no halo.
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RainbowToggle"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 28, 0, 15),
                ZIndex = Library.Z.Base + 4,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Indicator"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            Items["Thumb"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 2, 0.5, 0),
                Size = UDim2New(0, 11, 0, 11),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 6,
                BackgroundColor3 = Library.Theme.FaintText
            })  Items["Thumb"]:AddToTheme({BackgroundColor3 = "FaintText"})

            Instances:Create("UICorner", {
                Parent = Items["Thumb"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            -- Legacy aliases — Items["Check"] used to be the checkmark
            -- render, Items["Shadow"] the accent halo. Both are now
            -- invisible zero-size stubs kept for API compatibility.
            Items["Check"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Shadow"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })
        end

        local SlidingPalette = false 
        local SlidingHue = false 
        local SlidingAlpha = false

        local Debounce = false

        local OnRainbowToggled

        local IsRainbow = false

        local SetRainbow = function(Bool)
            IsRainbow = Bool

            if OnRainbowToggled then 
                OnRainbowToggled(IsRainbow)
            end

            Library.Flags[Data.Flag .. "RainbowToggle"] = IsRainbow

            if IsRainbow then
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Muted Accent"})
                Items["Thumb"]:ChangeItemTheme({BackgroundColor3 = "Image"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Items["Thumb"]:Tween("Slide", {Position = UDim2New(1, -13, 0.5, 0), BackgroundColor3 = Library.Theme.Image})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Muted Accent"]})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})
                Items["Thumb"]:ChangeItemTheme({BackgroundColor3 = "FaintText"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                Items["Thumb"]:Tween("Slide", {Position = UDim2New(0, 2, 0.5, 0), BackgroundColor3 = Library.Theme.FaintText})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end
        end

        Items["RainbowToggle"]:Connect("MouseButton1Down", function()
            SetRainbow(not IsRainbow)
        end)

        Library.SetFlags[Data.Flag .. "RainbowToggle"] = SetRainbow

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return 
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY
            
            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.95)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["PaletteDragger"]:Tween("Hover", {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return 
            end

            local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Hue = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.95)

            Items["HueDragger"]:Tween("Hover", {Position = UDim2New(SlideX, 0, 0, 2)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then
                return 
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.95)

            Items["AlphaDragger"]:Tween("Hover", {Position = UDim2New(SlideX, 0, 0, 2)})
            self:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            Items["ColorpickerButton"]:Tween("Default", {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween("Default", {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween("Default", {BackgroundColor3 = self.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                local ColorTable = Color
                Color = FromRGB(ColorTable[1], ColorTable[2], ColorTable[3])
                Alpha = ColorTable[4]
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.95)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.91)

            Items["PaletteDragger"]:Tween("Default", {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})

            local HuePositionX = MathClamp(self.Hue, 0, 0.95)

            Items["HueDragger"]:Tween("Default", {Position = UDim2New(HuePositionX, 0, 0, 2)})

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.95)

            Items["AlphaDragger"]:Tween("Default", {Position = UDim2New(AlphaPositionX, 0, 0, 2)})
            self:Update()
        end

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Alpha
        end

        function Colorpicker:SetVisibility(Bool)
            Items["ColorpickerButton"].Instance.Visible = Bool
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 25, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 15)
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if Colorpicker.IsOpen then
                    if not StringFind(Value.ClassName, "UI") then
                        Value.ZIndex = Library.Z.Popover + 1
                    end
                else
                    if not StringFind(Value.ClassName, "UI") then
                        Value.ZIndex = Library.Z.Base
                    end
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Colorpicker.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Colorpicker.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Bool
            end)
        end

        local OldColor = Colorpicker.Color

        OnRainbowToggled = function(Bool)
            if Bool then
                OldColor = Colorpicker.Color
                Library:Thread(function()
                    while task.wait() do 
                        local RainbowHue = MathAbs(MathSin(tick() * 0.32))
                        local Color = FromHSV(RainbowHue, 1, 1)

                        Colorpicker:Set(Color, Colorpicker.Alpha)

                        if not IsRainbow then
                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                            break
                        end
                    end
                end)
            end
        end

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false
                    end
                end)
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                SlidingHue = true
                Colorpicker:SlideHue(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false
                    end
                end)
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingAlpha = false
                    end
                end)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then 
                    Colorpicker:SlidePalette(Input)
                elseif SlidingHue then 
                    Colorpicker:SlideHue(Input)
                elseif SlidingAlpha then 
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Colorpicker.IsOpen and not Debounce and not Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker
    end

    -- ════════════════════════════════════════════════════
    -- Global element search (Ctrl+F across pages)
    -- ════════════════════════════════════════════════════
    Library.BuildSearchOverlay = function(self)
        if self.SearchOverlayData.Built then 
            return
        end
        self.SearchOverlayData.Built = true

        local Backdrop = Instances:Create("TextButton", {
            Parent = self.Holder.Instance,
            Name = "\0",
            AutoButtonColor = false,
            Text = "",
            BackgroundColor3 = FromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, 0, 1, 0),
            Position = UDim2New(0, 0, 0, 0),
            ZIndex = self.Z.Modal,
            Visible = false,
        })

        -- Fit the overlay comfortably inside the current viewport. On phones
        -- 420x300 spills over the edges, so clamp to viewport-minus-margin.
        local OverlayW = MathClamp(Camera.ViewportSize.X - 24, 300, 440)
        local OverlayH = MathClamp(Camera.ViewportSize.Y - 120, 240, 320)

        local Frame = Instances:Create("Frame", {
            Parent = Backdrop.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0),
            Position = UDim2New(0.5, 0, 0, self:IsMobileMode() and 40 or 90),
            Size = UDim2New(0, OverlayW, 0, OverlayH),
            BackgroundColor3 = self.Theme.Background,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = self.Z.Modal + 10,
            ClipsDescendants = true,
        })  Frame:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UICorner", {
            Parent = Frame.Instance,
            CornerRadius = UDimNew(0, self.Radius.Large)
        })

        Instances:Create("UIStroke", {
            Parent = Frame.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        self:AddDropShadow(Frame, { Padding = 60, Transparency = 0.4, ZIndex = self.Z.Modal + 5 })

        local Input = Instances:Create("TextBox", {
            Parent = Frame.Instance,
            FontFace = self.Font,
            ClearTextOnFocus = false,
            PlaceholderColor3 = self.Theme.FaintText,
            PlaceholderText = "Search every toggle, slider, dropdown...",
            Text = "",
            Name = "\0",
            TextColor3 = self.Theme.Text,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = self.Theme.Inline,
            Position = UDim2New(0, 14, 0, 14),
            Size = UDim2New(1, -28, 0, 34),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = self.Text.Title,
            ZIndex = self.Z.Modal + 11,
        })  Input:AddToTheme({BackgroundColor3 = "Inline", TextColor3 = "Text", PlaceholderColor3 = "FaintText"})

        Instances:Create("UICorner", {
            Parent = Input.Instance,
            CornerRadius = UDimNew(0, self.Radius.Medium)
        })

        local InputStroke = Instances:Create("UIStroke", {
            Parent = Input.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })  InputStroke:AddToTheme({Color = "Border"})

        Instances:Create("UIPadding", {
            Parent = Input.Instance,
            PaddingLeft = UDimNew(0, 14),
            PaddingRight = UDimNew(0, 42)
        })

        -- Trailing hint chip inside the input showing the dismiss shortcut.
        -- Feels like Raycast's escape hint — teaches the shortcut without a
        -- persistent instruction line.
        local EscChip = Instances:Create("Frame", {
            Parent = Input.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(1, 0.5),
            Position = UDim2New(1, 30, 0.5, 0),
            Size = UDim2New(0, 28, 0, 16),
            BackgroundColor3 = self.Theme.Element,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = self.Z.Modal + 12,
        })  EscChip:AddToTheme({BackgroundColor3 = "Element"})

        Instances:Create("UICorner", {
            Parent = EscChip.Instance,
            CornerRadius = UDimNew(0, self.Radius.Xs)
        })

        Instances:Create("UIStroke", {
            Parent = EscChip.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        Instances:Create("TextLabel", {
            Parent = EscChip.Instance,
            FontFace = self.BoldFont,
            Text = "ESC",
            TextColor3 = self.Theme.MutedText,
            TextSize = self.Text.Micro,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, 0, 1, 0),
            ZIndex = self.Z.Modal + 13,
        }):AddToTheme({TextColor3 = "MutedText"})

        local Hint = Instances:Create("TextLabel", {
            Parent = Frame.Instance,
            FontFace = self.Font,
            Text = "Type to filter. Click a result to jump.",
            TextColor3 = self.Theme.MutedText,
            TextTransparency = 0.1,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            Position = UDim2New(0, 16, 0, 54),
            Size = UDim2New(1, -32, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = self.Text.Small,
            ZIndex = self.Z.Modal + 11,
        })  Hint:AddToTheme({TextColor3 = "MutedText"})

        local Results = Instances:Create("ScrollingFrame", {
            Parent = Frame.Instance,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 2,
            CanvasSize = UDim2New(0, 0, 0, 0),
            ScrollBarImageColor3 = self.Theme.Accent,
            MidImage = self:GetImage("Scrollbar"),
            TopImage = self:GetImage("Scrollbar"),
            BottomImage = self:GetImage("Scrollbar"),
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 10, 0, 76),
            Size = UDim2New(1, -20, 1, -86),
            ZIndex = self.Z.Modal + 11,
            BackgroundColor3 = FromRGB(255, 255, 255),
        })  Results:AddToTheme({ScrollBarImageColor3 = "Accent"})

        local Layout = Instances:Create("UIListLayout", {
            Parent = Results.Instance,
            Padding = UDimNew(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Instances:Create("UIPadding", {
            Parent = Results.Instance,
            PaddingLeft = UDimNew(0, 4),
            PaddingRight = UDimNew(0, 4),
            PaddingTop = UDimNew(0, 4),
            PaddingBottom = UDimNew(0, 4)
        })

        self:AutoHideScrollbar(Results, Frame)

        self.SearchOverlayData.Backdrop = Backdrop
        self.SearchOverlayData.Frame = Frame
        self.SearchOverlayData.Input = Input
        self.SearchOverlayData.Results = Results
        self.SearchOverlayData.Layout = Layout
        self.SearchOverlayData.Hint = Hint

        Backdrop:Connect("MouseButton1Down", function()
            self:CloseSearchOverlay()
        end)

        Input:Connect("Changed", function(Property)
            if Property ~= "Text" then 
                return
            end
            self:RefreshSearchOverlay()
        end)

        self:AddFocusGlow(InputStroke, Input)
    end

    Library.RegisterSearchEntry = function(self, Entry)
        if type(Entry) ~= "table" or not Entry.Name then 
            return
        end
        TableInsert(self.SearchIndex, Entry)
    end

    Library.IndexElement = function(self, Element, Kind)
        if not Element or type(Element) ~= "table" or not Element.Name then 
            return
        end
        local SubPage = Element.Page
        local Page = SubPage and SubPage.Page or SubPage
        if SubPage == Page then 
            SubPage = nil
        end
        self:RegisterSearchEntry({
            Kind = Kind or "Item",
            Name = Element.Name,
            Section = Element.Section,
            SubPage = SubPage,
            Page = Page,
        })
    end

    Library._JumpToSearchEntry = function(self, Entry)
        local TargetPage    = Entry.Page
        local TargetSubPage = Entry.SubPage

        if TargetPage and TargetPage.Window and TargetPage.Window.Pages then 
            for _, OtherPage in TargetPage.Window.Pages do 
                OtherPage:Turn(OtherPage == TargetPage)
            end
        end

        if TargetSubPage and TargetSubPage.Window and TargetSubPage.Window.SubPages then 
            for _, OtherSub in TargetSubPage.Window.SubPages do 
                if OtherSub.Page == TargetSubPage.Page then 
                    OtherSub:Turn(OtherSub == TargetSubPage)
                end
            end
        end

        -- Try to scroll the section into view & pulse-highlight it
        local SectionFrame = Entry.Section and Entry.Section.Items and Entry.Section.Items["Section"]
        if SectionFrame and SectionFrame.Instance then 
            local Inst = SectionFrame.Instance
            local Parent = Inst.Parent
            if Parent and Parent:IsA("ScrollingFrame") then 
                local TargetY = math.max(0, Inst.AbsolutePosition.Y - Parent.AbsolutePosition.Y - 8)
                Tween:Create(Parent, "Panel", {CanvasPosition = Vector2New(0, TargetY)}, true)
            end

            local Stroke = Inst:FindFirstChildOfClass("UIStroke")
            if Stroke then 
                local Original = Stroke.Color
                Tween:Create(Stroke, "Slide", {Color = self.Theme.Accent, Thickness = 1.6}, true)
                task.delay(0.9, function()
                    Tween:Create(Stroke, "Slow", {Color = Original, Thickness = 1}, true)
                end)
            end
        end

        self:CloseSearchOverlay()
    end

    Library._ClearSearchResults = function(self)
        local Results = self.SearchOverlayData.Results
        if not Results then 
            return
        end

        for _, Child in Results.Instance:GetChildren() do 
            if Child:IsA("TextButton") then 
                Child:Destroy()
            end
        end
    end

    Library._BuildSearchResultRow = function(self, Entry)
        local Results = self.SearchOverlayData.Results
        local Row = Instances:Create("TextButton", {
            Parent = Results.Instance,
            FontFace = self.Font,
            Text = "",
            TextColor3 = self.Theme.Text,
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundTransparency = 0,
            BackgroundColor3 = self.Theme.Inline,
            Size = UDim2New(1, 0, 0, 40),
            ZIndex = self.Z.Modal + 12,
        })  Row:AddToTheme({BackgroundColor3 = "Inline"})

        Instances:Create("UICorner", {
            Parent = Row.Instance,
            CornerRadius = UDimNew(0, self.Radius.Medium)
        })

        local Stroke = Instances:Create("UIStroke", {
            Parent = Row.Instance,
            Color = self.Theme.Border,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })  Stroke:AddToTheme({Color = "Border"})

        Instances:Create("UIPadding", {
            Parent = Row.Instance,
            PaddingLeft = UDimNew(0, 14),
            PaddingRight = UDimNew(0, 14),
        })

        local Title = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = self.BoldFont,
            Text = tostring(Entry.Name or ""),
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2New(1, -70, 0, 16),
            Position = UDim2New(0, 0, 0, 5),
            TextSize = self.Text.Body,
            ZIndex = self.Z.Modal + 13,
        })  Title:AddToTheme({TextColor3 = "Text"})

        local Path = { }
        if Entry.Page and Entry.Page.Name then TableInsert(Path, Entry.Page.Name) end
        if Entry.SubPage and Entry.SubPage.Name then TableInsert(Path, Entry.SubPage.Name) end
        if Entry.Section and Entry.Section.Name then TableInsert(Path, Entry.Section.Name) end

        local Crumbs = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = self.Font,
            Text = TableConcat(Path, "  ›  "),
            TextColor3 = self.Theme.FaintText,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2New(1, -70, 0, 14),
            Position = UDim2New(0, 0, 0, 22),
            TextSize = self.Text.Micro,
            ZIndex = self.Z.Modal + 13,
        })  Crumbs:AddToTheme({TextColor3 = "FaintText"})

        local Tag = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = self.BoldFont,
            Text = tostring(Entry.Kind or ""),
            TextColor3 = self.Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            AnchorPoint = Vector2New(1, 0.5),
            Position = UDim2New(1, 0, 0.5, 0),
            Size = UDim2New(0, 70, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextSize = self.Text.Micro,
            ZIndex = self.Z.Modal + 13,
        })  Tag:AddToTheme({TextColor3 = "Accent"})

        Row:Connect("MouseEnter", function()
            Row:Tween("Hover", {BackgroundColor3 = self.Theme.Element})
            Stroke:ChangeItemTheme({Color = "Accent"})
            Tween:Create(Stroke.Instance, "Hover", {Color = self.Theme.Accent}, true)
        end)

        Row:Connect("MouseLeave", function()
            Row:ChangeItemTheme({BackgroundColor3 = "Inline"})
            Row:Tween("Hover", {BackgroundColor3 = self.Theme.Inline})
            Stroke:ChangeItemTheme({Color = "Border"})
            Tween:Create(Stroke.Instance, "Hover", {Color = self.Theme.Border}, true)
        end)

        Row:Connect("MouseButton1Down", function()
            self:_JumpToSearchEntry(Entry)
        end)

        return Row
    end

    Library.RefreshSearchOverlay = function(self)
        if not self.SearchOverlayData.Built then 
            return
        end

        local Query = StringLower(self.SearchOverlayData.Input.Instance.Text or "")
        local Hint = self.SearchOverlayData.Hint
        self:_ClearSearchResults()

        local Matches = { }
        for _, Entry in self.SearchIndex do 
            local Name = StringLower(tostring(Entry.Name or ""))
            local Section = Entry.Section and StringLower(tostring(Entry.Section.Name or "")) or ""
            local SubPage = Entry.SubPage and StringLower(tostring(Entry.SubPage.Name or "")) or ""
            local Page    = Entry.Page and StringLower(tostring(Entry.Page.Name or "")) or ""

            if Query == ""
                or StringFind(Name, Query, 1, true)
                or StringFind(Section, Query, 1, true)
                or StringFind(SubPage, Query, 1, true)
                or StringFind(Page, Query, 1, true)
            then 
                TableInsert(Matches, Entry)
            end

            if #Matches >= 60 then 
                break
            end
        end

        if Hint and Hint.Instance then 
            if Query == "" then 
                Hint.Instance.Text = StringFormat("%d items indexed.", #self.SearchIndex)
            else
                Hint.Instance.Text = StringFormat("%d match%s for \"%s\"", #Matches, #Matches == 1 and "" or "es", Query)
            end
        end

        for _, Entry in Matches do 
            self:_BuildSearchResultRow(Entry)
        end
    end

    Library.OpenSearchOverlay = function(self)
        self:BuildSearchOverlay()
        if self.SearchOverlayData.Visible then 
            return
        end
        self.SearchOverlayData.Visible = true

        local Backdrop = self.SearchOverlayData.Backdrop
        local Frame = self.SearchOverlayData.Frame
        Backdrop.Instance.Visible = true

        Backdrop.Instance.BackgroundTransparency = 1
        Frame.Instance.Position = UDim2New(0.5, 0, 0, 60)

        Tween:Create(Backdrop.Instance, "Default", {BackgroundTransparency = 0.55}, true)
        Frame:Tween("Slide", {Position = UDim2New(0.5, 0, 0, 80)})

        self.SearchOverlayData.Input.Instance.Text = ""
        self:RefreshSearchOverlay()

        task.defer(function()
            if self.SearchOverlayData.Visible and self.SearchOverlayData.Input then 
                self.SearchOverlayData.Input.Instance:CaptureFocus()
            end
        end)
    end

    Library.CloseSearchOverlay = function(self)
        if not self.SearchOverlayData.Visible then 
            return
        end
        self.SearchOverlayData.Visible = false

        local Backdrop = self.SearchOverlayData.Backdrop
        local Frame = self.SearchOverlayData.Frame

        if self.SearchOverlayData.Input and self.SearchOverlayData.Input.Instance then 
            self.SearchOverlayData.Input.Instance:ReleaseFocus()
        end

        Tween:Create(Backdrop.Instance, "Default", {BackgroundTransparency = 1}, true)
        Frame:Tween("Slide", {Position = UDim2New(0.5, 0, 0, 60)})

        task.delay(0.25, function()
            if not self.SearchOverlayData.Visible then 
                Backdrop.Instance.Visible = false
            end
        end)
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local IsMobile = Library:IsMobileMode()

        -- On phones the default 681x480 window barely fits, and centring it
        -- off the viewport / 3.5 pushes it off-screen. Recompute a size that
        -- fits comfortably inside the viewport.
        local RequestedSize = Data.Size or Data.size or UDim2New(0, 681, 0, 480)
        local ResolvedSize = RequestedSize
        local ResolvedPosition = UDim2New(0, Camera.ViewportSize.X / 3.5, 0, Camera.ViewportSize.Y / 3.5)
        local ResolvedAnchor = Vector2New(0, 0)

        if IsMobile then 
            local Viewport = Camera.ViewportSize
            local TargetW = MathClamp(Viewport.X - 20, 300, RequestedSize.X.Offset)
            local TargetH = MathClamp(Viewport.Y - 40, 260, RequestedSize.Y.Offset)
            ResolvedSize = UDim2New(0, TargetW, 0, TargetH)
            ResolvedPosition = UDim2New(0.5, 0, 0.5, 0)
            ResolvedAnchor = Vector2New(0.5, 0.5)
        end

        local Window = {
            Logo = Data.Logo or Data.logo or "123748867365417",
            Size = ResolvedSize,
            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.2,
            PagePadding = Data.PagePadding or Data.pagepadding or 19,
            IsMobile = IsMobile,

            Pages = { },
            SubPages = { },
            Items = { },

            IsOpen = false
        }

        local Items = { } do
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = ResolvedAnchor,
                Name = "\0",
                Position = ResolvedPosition,
                Size = Window.Size,
                Visible = false,
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MainFrame"]:MakeDraggable()

            -- The resize handle in the bottom-right is fiddly on touchscreens
            -- and the fit-to-viewport size is already sensible on mobile, so
            -- skip resizeable behaviour there.
            if not IsMobile then 
                Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))
            end

            -- Ambient drop shadow. Soft, wide, dark — sits the window
            -- above the game world without asserting itself. Transparency
            -- is deliberately mid-range (0.35) rather than heavy black at
            -- 0.2; the shadow is depth, not decoration.
            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["MainFrame"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ImageTransparency = 0.35,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.7,
                Name = "\0",
                Size = UDim2New(1, 100, 1, 100),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            -- Whisper-thin accent bloom around the window rim. Kept very
            -- subtle (0.9 transparency) so it barely reads by itself but
            -- shifts to match the theme when Accent is swapped. Gives the
            -- window a hint of brand identity in the ambient light without
            -- calling attention to itself.
            Instances:Create("ImageLabel", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 0.9,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = -2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.75,
                Size = UDim2New(1, 40, 1, 40),
                BackgroundColor3 = FromRGB(255, 255, 255)
            }):AddToTheme({ImageColor3 = "Accent"})

            Items["Sidebar"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                BackgroundTransparency = 0,
                Size = UDim2New(0, 74, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Inline,
                ZIndex = Library.Z.Base + 1,
                BorderSizePixel = 0,
            })  Items["Sidebar"]:AddToTheme({BackgroundColor3 = "Inline"})

            -- Sidebar depth gradient (subtle vertical fade)
            Instances:Create("UIGradient", {
                Parent = Items["Sidebar"].Instance,
                Rotation = 90,
                Transparency = NumSequence{
                    NumSequenceKeypoint(0, 0.05),
                    NumSequenceKeypoint(0.5, 0),
                    NumSequenceKeypoint(1, 0.15),
                }
            })

            -- Active-page indicator. Replaces the previous left-edge pill
            -- with a soft-filled circular backdrop that slides to sit
            -- behind whichever page icon is currently active. Same shape
            -- as an icon "button" in Linear/Raycast — reads as selection,
            -- not decoration. Position + rounded shape are updated in
            -- Page:Turn.
            Items["PageAccent"] = Instances:Create("Frame", {
                Parent = Items["Sidebar"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0, 0),
                Size = UDim2New(0, 40, 0, 32),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = Library.Z.Base + 2,
                Visible = false,
                BackgroundTransparency = 0.85,
                BackgroundColor3 = Library.Theme.Accent
            })  Items["PageAccent"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["PageAccent"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            -- Thin accent stroke around the selection backdrop for a bit
            -- more definition against the sidebar surface. Uses Muted Accent
            -- so it doesn't scream at the edge.
            Instances:Create("UIStroke", {
                Parent = Items["PageAccent"].Instance,
                Color = Library.Theme["Muted Accent"],
                Thickness = 1,
                Transparency = 0.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Muted Accent"})

            Items["Logo"] = Instances:Create("ImageLabel", {
                Parent = Items["Sidebar"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 45, 0, 45),
                AnchorPoint = Vector2New(0.5, 0),
                Image = "rbxassetid://" .. Window.Logo,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0, 12),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Logo"]:AddToTheme({ImageColor3 = "Image"})

            Items["Shadow2"] = Instances:Create("ImageLabel", {
                Parent = Items["Logo"].Instance,
                ScaleType = Enum.ScaleType.Slice,
                Name = "\0",
                ImageTransparency = 0.7200000286102295,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 5, 1, 5),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.8999999761581421,
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147))
            })  Items["Shadow2"]:AddToTheme({ImageColor3 = "Image"})

            Instances:Create("Frame", {
                Parent = Items["Sidebar"].Instance,
                Size = UDim2New(0, 1, 1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            }):AddToTheme({BackgroundColor3 = "Border"})

            Items["Pages"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Sidebar"].Instance,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ScrollBarImageTransparency = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 77),
                Size = UDim2New(1, 0, 1, -103),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Pages"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                Padding = UDimNew(0, Window.PagePadding),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UICorner", {
                Parent = Items["MainFrame"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Large)
            })

            Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                Color = Library.Theme.Border,
                Thickness = 1,
                Transparency = 0.15,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Sidebar"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 34, 0, 34),
                AnchorPoint = Vector2New(0.5, 1),
                Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 1, -18),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Avatar"].Instance.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

            Instances:Create("UICorner", {
                Parent = Items["Avatar"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Avatar"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            -- Discoverable search entry point. The Ctrl+F shortcut is
            -- invisible to first-time users; this button teaches it via the
            -- tooltip and provides a mouse-first path in. Sized as a
            -- rounded icon-style button so it visually reads as a nav
            -- affordance next to the avatar, not another content button.
            Items["SearchButton"] = Instances:Create("TextButton", {
                Parent = Items["Sidebar"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 1),
                Position = UDim2New(0.5, 0, 1, -64),
                Size = UDim2New(0, 34, 0, 26),
                Text = "Find",
                FontFace = Library.Font,
                TextSize = Library.Text.Small,
                TextColor3 = Library.Theme.MutedText,
                BackgroundColor3 = Library.Theme.Element,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = Library.Z.Base + 3,
            })  Items["SearchButton"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "MutedText"})

            Instances:Create("UICorner", {
                Parent = Items["SearchButton"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            Instances:Create("UIStroke", {
                Parent = Items["SearchButton"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Library:BindTooltip(Items["SearchButton"], "Search every element  •  Ctrl+F")

            -- Custom hover: text color shifts to primary so the button
            -- reads as "hoverable" in the sidebar's muted context.
            Library:Connect(Items["SearchButton"].Instance.MouseEnter, function()
                Items["SearchButton"]:Tween("Hover", {
                    TextColor3 = Library.Theme.Text,
                    BackgroundColor3 = Library.Theme.Background
                })
            end)

            Library:Connect(Items["SearchButton"].Instance.MouseLeave, function()
                Items["SearchButton"]:Tween("Hover", {
                    TextColor3 = Library.Theme.MutedText,
                    BackgroundColor3 = Library.Theme.Element
                })
            end)

            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 75, 0, 0),
                Size = UDim2New(1, -75, 1, 0),
                ZIndex = Library.Z.Base + 1,
                ClipsDescendants = true,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
        end

        -- Auto-hide sidebar scrollbar when not hovering the sidebar
        Library:AutoHideScrollbar(Items["Pages"], Items["Sidebar"])

        -- Subtle floating logo animation (~3s sine wave, ±1.5px)
        do
            local LogoBaseY = 12
            local Phase = 0
            Library:Connect(RunService.RenderStepped, function(dt)
                Phase = Phase + dt
                local Offset = MathSin(Phase * 1.6) * 1.5
                Items["Logo"].Instance.Position = UDim2New(0.5, 0, 0, LogoBaseY + Offset)
            end)
        end

        local Debounce = false 

        function Window:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["MainFrame"].Instance.Visible = true
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                -- Staggered reveal: cap total stagger to ~180ms
                local Delay = Bool and math.min((Index - 1) * 0.004, 0.18) or 0

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Window.FadeSpeed, Delay)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Window.FadeSpeed, Delay)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["MainFrame"].Instance.Visible = Bool
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
            if Gpe then 
                return 
            end

            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        -- Mobile menu toggle: a floating draggable button so users without a
        -- keyboard can still open/close the menu (the default keybind is Z).
        if IsMobile then 
            local MenuButton = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AutoButtonColor = false,
                Text = "",
                AnchorPoint = Vector2New(0, 0),
                Position = UDim2New(0, 12, 0, 90),
                Size = UDim2New(0, 48, 0, 48),
                BackgroundColor3 = Library.Theme.Background,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = Library.Z.Overlay,
            })  MenuButton:AddToTheme({BackgroundColor3 = "Background"})

            Instances:Create("UICorner", {
                Parent = MenuButton.Instance,
                CornerRadius = UDimNew(1, 0)
            })

            local MenuStroke = Instances:Create("UIStroke", {
                Parent = MenuButton.Instance,
                Color = Library.Theme.Accent,
                Thickness = 1.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  MenuStroke:AddToTheme({Color = "Accent"})

            Library:AddDropShadow(MenuButton, { Padding = 24, Transparency = 0.55, ZIndex = Library.Z.Overlay - 1 })

            local MenuLogo = Instances:Create("ImageLabel", {
                Parent = MenuButton.Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 30, 0, 30),
                Image = "rbxassetid://" .. Window.Logo,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = Library.Z.Overlay + 1,
                BackgroundColor3 = FromRGB(255, 255, 255),
            })  MenuLogo:AddToTheme({ImageColor3 = "Image"})

            MenuButton:MakeDraggable()

            -- Distinguish a "tap" (short press with negligible movement)
            -- from a drag so dragging the button around doesn't accidentally
            -- toggle the menu.
            local PressStart, PressStartPos
            local DragThreshold = 6 -- pixels

            MenuButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                    PressStart = tick()
                    PressStartPos = Input.Position
                end
            end)

            MenuButton:Connect("InputEnded", function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then 
                    return
                end
                if not PressStart or not PressStartPos then 
                    return
                end

                local Held = tick() - PressStart
                local Delta = (Input.Position - PressStartPos).Magnitude
                PressStart = nil
                PressStartPos = nil

                if Held < 0.35 and Delta < DragThreshold then 
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Items["MobileMenuButton"] = MenuButton

            -- Tighten notification width on small screens so cards don't spill
            -- over the viewport edge.
            local NotifMax = Camera.ViewportSize.X - 30
            if Library.NotifHolder and Library.NotifHolder.Instance then 
                Instances:Create("UISizeConstraint", {
                    Parent = Library.NotifHolder.Instance,
                    MaxSize = Vector2New(NotifMax, math.huge)
                })
            end
        end

        -- Sidebar Search button: visible counterpart to the Ctrl+F keybind.
        Items["SearchButton"]:Connect("MouseButton1Down", function()
            if Library.SearchOverlayData and Library.SearchOverlayData.Visible then 
                Library:CloseSearchOverlay()
            else
                Library:OpenSearchOverlay()
            end
        end)

        -- Ctrl/⌘ + F → global search
        Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
            if not Window.IsOpen then 
                return
            end

            if Input.KeyCode == Enum.KeyCode.F and not Gpe then 
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                    or UserInputService:IsKeyDown(Enum.KeyCode.LeftMeta) or UserInputService:IsKeyDown(Enum.KeyCode.RightMeta) then 
                    if Library.SearchOverlayData.Visible then 
                        Library:CloseSearchOverlay()
                    else
                        Library:OpenSearchOverlay()
                    end
                end
            elseif Input.KeyCode == Enum.KeyCode.Escape and Library.SearchOverlayData.Visible then 
                Library:CloseSearchOverlay()
            end
        end)

        Window.Items = Items

        Window:SetOpen(true)
        return setmetatable(Window, Library)
    end

    Library.Seperator = function(self)
        return Instances:Create("Frame", {
            Parent = self.Items["Pages"].Instance,
            Name = "\0",
            Size = UDim2New(0, 40, 0, 1),
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(24, 24, 24)
        }):AddToTheme({BackgroundColor3 = "Border"})
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Icon = Data.Icon or Data.icon or "109391165290124",
            Name = Data.Name or Data.name or Data.Title or Data.title or nil,
            Search = Data.Search or Data.search or false,

            Items = { },
            -- Per-page subpage list. The check for auto-activation used to be
            -- against Window.SubPages (a flat list across ALL pages), so only
            -- the very first subpage in the whole window was auto-activated.
            -- That, combined with the click handler turning off every other
            -- subpage in Window.SubPages, meant switching pages could leave
            -- the target page with NO active subpage → the "empty tab" bug.
            SubPages = { },

            Active = false,
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("ImageButton", {
                Parent = Page.Window.Items["Pages"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                Name = "\0",
                Image = "rbxassetid://" .. Page.Icon,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 25, 0, 25),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inactive"]:AddToTheme({ImageColor3 = "Image"})

            -- Soft accent halo behind the active page icon
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance,
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(1, 22, 1, 22),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = "rbxassetid://112971167999062",
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                SliceScale = 0.6,
                ZIndex = 1,
                Name = "\0",
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

            Items["PageContent"] = Instances:Create("Frame", {
                Parent = Page.Window.Items["Inline"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Visible = false,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["SubPages"] = Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 15, 0, 15),
                Size = UDim2New(1, -30, 0, 24),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["SubPages"].Instance,
                Padding = UDimNew(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal
            }) 

            Items["Columns"] = Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                Size = UDim2New(1, 0, 1, -55),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 55),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                Size = UDim2New(1, 0, 0, 1),
                Name = "\0",
                Position = Page.Search and UDim2New(0, 0, 0, 99) or UDim2New(0, 0, 0, 54),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            }):AddToTheme({BackgroundColor3 = "Border"})

            if Page.Search then
                Items["SubPages"].Instance.Position = UDim2New(0, 15, 0, 60)
                Items["Columns"].Instance.Position = UDim2New(0, 0, 0, 100)
                Items["Columns"].Instance.Size = UDim2New(1, 0, 1, -100)

                Items["Search"] = Instances:Create("TextBox", {
                    Parent = Items["PageContent"].Instance,
                    FontFace = Library.Font,
                    Active = false,
                    Selectable = false,
                    PlaceholderColor3 = FromRGB(175, 175, 175),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 313, 0, 30),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Name = "\0",
                    PlaceholderText = "Search",
                    Position = UDim2New(0, 15, 0, 15),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(14, 14, 14)
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Background", TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    CornerRadius = UDimNew(0, 4)
                }) 

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Color = FromRGB(24, 24, 24),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Search"].Instance,
                    PaddingLeft = UDimNew(0, 8)
                }) 
            end
        end

        local Debounce = false 

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = Bool

            Debounce = true 

            if Bool then
                Items["PageContent"].Instance.Visible = true
                Items["PageContent"].Instance.Parent = Page.Window.Items["Inline"].Instance
                -- Icon becomes fully opaque and tints toward Accent on
                -- active. Combined with the backdrop pill the selection
                -- reads instantly without a second decorative halo.
                Items["Inactive"]:ChangeItemTheme({ImageColor3 = "Accent"})
                Items["Inactive"]:Tween(nil, {ImageTransparency = 0, ImageColor3 = Library.Theme.Accent})
                Items["Glow"]:Tween(nil, {ImageTransparency = 1})

                local Accent = Page.Window.Items["PageAccent"]
                if Accent then
                    local Sidebar = Page.Window.Items["Sidebar"].Instance
                    local Icon = Items["Inactive"].Instance
                    local RelativeY = (Icon.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y) + (Icon.AbsoluteSize.Y / 2)
                    Accent.Instance.Visible = true
                    Accent:Tween("Slide", {Position = UDim2New(0.5, 0, 0, RelativeY)})
                end

                -- Guarantee this page always has a visible subpage once it
                -- becomes active. If a previous subpage-click storm (see the
                -- SubPage MouseButton1Down handler) left every subpage in
                -- this page inactive, activate the first one so the user
                -- doesn't see an empty tab.
                if Page.SubPages and #Page.SubPages > 0 then 
                    local anyActive = false
                    for _, sp in Page.SubPages do 
                        if sp.Active then 
                            anyActive = true
                            break
                        end
                    end
                    if not anyActive then 
                        Page.SubPages[1]:Turn(true)
                    end
                end
            else
                Items["Inactive"]:ChangeItemTheme({ImageColor3 = "Image"})
                Items["Inactive"]:Tween(nil, {ImageTransparency = 0.5, ImageColor3 = Library.Theme.Image})
                Items["Glow"]:Tween(nil, {ImageTransparency = 1})
            end

            -- Build a skip-set of PageContent frames + their descendants for
            -- every INACTIVE subpage. Fading their subtrees is pure waste:
            -- they live inside a Visible=false parent so nothing renders,
            -- but the previous code still created a TweenService tween per
            -- transparency property (hundreds per page-switch on Movement /
            -- Combat), which is the frame-hitch users see when swapping
            -- pages. Skipping them keeps the visible fade animation intact
            -- while cutting tween-count by ~5-10x on subpage-heavy pages.
            local Skip
            if Page.SubPages and #Page.SubPages > 0 then 
                Skip = { }
                for _, sp in Page.SubPages do 
                    if not sp.Active and sp.Items and sp.Items["PageContent"] then 
                        local pc = sp.Items["PageContent"].Instance
                        Skip[pc] = true
                        for _, d in ipairs(pc:GetDescendants()) do 
                            Skip[d] = true
                        end
                    end
                end
            end

            local Descendants = Items["PageContent"].Instance:GetDescendants()
            TableInsert(Descendants, Items["PageContent"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                if Skip and Skip[Value] then 
                    continue
                end

                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Page.Window.FadeSpeed)
                end
            end

            -- If every descendant was skipped (nothing to fade) fall back to
            -- a delay so Debounce still releases and callbacks still fire.
            if not NewTween then 
                task.delay(Page.Window.FadeSpeed or 0.2, function()
                    Debounce = false
                    Items["PageContent"].Instance.Visible = Bool
                    Items["PageContent"].Instance.Parent = Bool and Page.Window.Items["Inline"].Instance or Library.UnusedHolder.Instance
                end)
                return
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and Page.Window.Items["Inline"].Instance or Library.UnusedHolder.Instance
                if Page.Search then 
                    Items["Columns"]:Tween(nil, {Position = Bool and UDim2New(0, 0, 0, 100) or UDim2New(0, 0, 1, 0)})
                else
                    Items["Columns"]:Tween(nil, {Position = Bool and UDim2New(0, 0, 0, 55) or UDim2New(0, 0, 1, 0)})
                end
            end)

            -- Belt-and-suspenders: reset Debounce after the tween duration
            -- even if the Completed signal never fires (e.g. tween cancelled
            -- by an overlapping Tween:Create on the same property). Without
            -- this, a bad race could leave Debounce=true forever and lock
            -- the page from ever being toggled again.
            task.delay((Page.Window.FadeSpeed or 0.2) + 0.1, function()
                if Debounce then 
                    Debounce = false
                end
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if Page.Name then 
            Library:BindTooltip(Items["Inactive"], Page.Name)
        end

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Items = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "SubPage",

            Items = { },
            SearchItems = { },

            Active = false,
        }

        local Items = { } do 
            -- Subpage tab. Reads like a chip: rounded pill, tight
            -- padding, semantic active/inactive states. Active is
            -- solid Accent with white text; inactive is Element bg with
            -- muted text — clear hierarchy without a decorative halo.
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Items["SubPages"].Instance,
                FontFace = Library.BoldFont,
                TextColor3 = Library.Theme.MutedText,
                Text = SubPage.Name,
                AutoButtonColor = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 108, 1, 0),
                BorderSizePixel = 0,
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Inactive"]:AddToTheme({TextColor3 = "MutedText", BackgroundColor3 = "Element"})

            Instances:Create("UICorner", {
                Parent = Items["Inactive"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            -- Legacy alias. The accent halo behind the active pill is gone;
            -- the fill + stroke transition carries the state on its own.
            Items["Shadow"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })

            Items["PageContent"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Items["Columns"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Visible = false,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Right"] = Instances:Create("ScrollingFrame", {
                Parent = Items["PageContent"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                AnchorPoint = Vector2New(1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -2, 0, 2),
                Size = UDim2New(0.5, -4, 1, -6),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Right"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Right"].Instance,
                PaddingTop = UDimNew(0, 12),
                PaddingBottom = UDimNew(0, 14),
                PaddingRight = UDimNew(0, 14),
                PaddingLeft = UDimNew(0, 7)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Right"].Instance,
                Padding = UDimNew(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Left"] = Instances:Create("ScrollingFrame", {
                Parent = Items["PageContent"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 2),
                Size = UDim2New(0.5, -4, 1, -6),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Left"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Left"].Instance,
                PaddingTop = UDimNew(0, 12),
                PaddingBottom = UDimNew(0, 14),
                PaddingRight = UDimNew(0, 7),
                PaddingLeft = UDimNew(0, 14)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Left"].Instance,
                Padding = UDimNew(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        local Debounce = false 

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = Bool

            Debounce = true 

            if Bool then
                Items["PageContent"].Instance.Visible = true
                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Text", BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Muted Accent"})

                Items["Inactive"]:Tween(nil, {TextTransparency = 0, TextColor3 = Library.Theme.Text, BackgroundColor3 = Library.Theme.Accent})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Muted Accent"]})
            else
                Items["Inactive"]:ChangeItemTheme({TextColor3 = "MutedText", BackgroundColor3 = "Element"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

                Items["Inactive"]:Tween(nil, {TextTransparency = 0, TextColor3 = Library.Theme.MutedText, BackgroundColor3 = Library.Theme.Element})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end

            local Descendants = Items["PageContent"].Instance:GetDescendants()
            TableInsert(Descendants, Items["PageContent"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed)
                end
            end

            if NewTween then 
                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["PageContent"].Instance.Visible = Bool
                end)
            else
                task.delay(SubPage.Window.FadeSpeed or 0.2, function()
                    Debounce = false
                    Items["PageContent"].Instance.Visible = Bool
                end)
            end

            -- Fallback timer so Debounce always releases even if the tween's
            -- Completed signal never fires (e.g. cancelled by an overlapping
            -- Tween:Create on the same property).
            task.delay((SubPage.Window.FadeSpeed or 0.2) + 0.1, function()
                if Debounce then 
                    Debounce = false
                end
            end)
        end

        local RenderStepped

        if SubPage.Page.Search then 
            SubPage.Page.Items["Search"]:Connect("Focused", function()
                RenderStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in SubPage.SearchItems do 
                        local Element = Value.Element
                        local Section = Value.Section

                        if StringFind(StringLower(Element.Instance.Text), StringLower(SubPage.Page.Items["Search"].Instance.Text)) and SubPage.Page.Items["Search"].Instance.Text ~= "" then
                            Element:ChangeItemTheme({TextColor3 = "Accent"})
                            Element:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        else
                            Element:ChangeItemTheme({TextColor3 = "Text"})
                            Element:Tween(nil, {TextColor3 = Library.Theme.Text})
                        end
                    end
                end)
            end)

            SubPage.Page.Items["Search"]:Connect("FocusLost", function()
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            -- Only toggle subpages that belong to the SAME page. Iterating
            -- Window.SubPages (the flat list) would clobber active subpages
            -- on unrelated pages, which is what caused the "empty tab" bug
            -- when returning to those pages.
            local siblings = SubPage.Page.SubPages or SubPage.Window.SubPages
            for Index, Value in siblings do
                Value:Turn(Value == SubPage)
            end
        end)

        -- Auto-activate the first subpage per PAGE (not per window). Ensures
        -- every page that has subpages opens with content visible.
        if SubPage.Page.SubPages and #SubPage.Page.SubPages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Items = Items

        -- Track the subpage on BOTH the page and the window. The window
        -- list is still used by legacy callers (e.g. search jump-to); the
        -- page list is the new source of truth for sibling operations.
        if SubPage.Page.SubPages then 
            TableInsert(SubPage.Page.SubPages, SubPage)
        end
        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = { 
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or "Left",

            Items = { },
        }

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Side:lower() == "left" and Section.Page.Items["Left"].Instance or Section.Page.Items["Right"].Instance,
                BorderSizePixel = 0,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 48),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 3,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Library.Theme.Background
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Background"})

            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            -- Section marker. A thin 2px vertical bar aligned with the
            -- title only — quiet, functional, no halo. Consumers can
            -- override its color via Section.Items["AccentBar"] if a
            -- specific section wants its own category tint.
            Items["AccentBar"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Size = UDim2New(0, 2, 0, 12),
                Name = "\0",
                Position = UDim2New(0, 10, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 5,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent
            })  Items["AccentBar"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["AccentBar"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.BoldFont,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, -40, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 18, 0, 7),
                ZIndex = Library.Z.Base + 5,
                TextSize = Library.Text.Title,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            -- Hairline divider between header and content. Deliberately
            -- kept at Border rather than a hardcoded muted color so it
            -- moves with any theme swap.
            Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Size = UDim2New(1, -20, 0, 1),
                Name = "\0",
                Position = UDim2New(0, 10, 0, 29),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 3,
                BorderSizePixel = 0,
                BackgroundTransparency = 0.35,
                BackgroundColor3 = Library.Theme.Border
            }):AddToTheme({BackgroundColor3 = "Border"})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 12, 0, 40),
                Size = UDim2New(1, -24, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["BottomPadding"] = Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 14)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Section"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            Items["Chevron"] = Instances:Create("ImageLabel", {
                Parent = Items["Section"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 9, 0, 9),
                AnchorPoint = Vector2New(1, 0),
                Image = "rbxassetid://86523506890491",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -12, 0, 10),
                ZIndex = Library.Z.Base + 5,
                BorderSizePixel = 0,
                Rotation = 0,
                ImageColor3 = Library.Theme.MutedText,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Chevron"]:AddToTheme({ImageColor3 = "MutedText"})

            Items["HeaderButton"] = Instances:Create("TextButton", {
                Parent = Items["Section"].Instance,
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 30),
                Position = UDim2New(0, 0, 0, 0),
                ZIndex = Library.Z.Base + 6,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            -- Header hover: chevron shifts from muted → primary so the
            -- collapse affordance is discoverable on hover.
            Library:Connect(Items["HeaderButton"].Instance.MouseEnter, function()
                Items["Chevron"]:Tween("Hover", {ImageColor3 = Library.Theme.Text})
            end)

            Library:Connect(Items["HeaderButton"].Instance.MouseLeave, function()
                Items["Chevron"]:Tween("Hover", {ImageColor3 = Library.Theme.MutedText})
            end)
        end

        Section.Collapsed = false

        function Section:SetCollapsed(Bool)
            Section.Collapsed = Bool and true or false

            Items["Content"].Instance.Visible = not Section.Collapsed
            Items["BottomPadding"].Instance.PaddingBottom = UDimNew(0, Section.Collapsed and 4 or 12)
            Items["Chevron"]:Tween(nil, {Rotation = Section.Collapsed and -90 or 0})
        end

        function Section:ToggleCollapse()
            Section:SetCollapsed(not Section.Collapsed)
        end

        Items["HeaderButton"]:Connect("MouseButton1Down", function()
            Section:ToggleCollapse()
        end)

        function Section:SetVisibility(Bool)
           Items["Section"].Instance.Visible = Bool 
        end

        Section.Items = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,

            Count = 0
        }

        local Items = { } do
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            -- Pill switch. Off = Element background with a muted thumb;
            -- on = Accent fill with a white thumb slid to the right. No
            -- external halo — the color + stroke transition carries the
            -- state, same principle as the SubPage tabs and Slider thumb.
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 28, 0, 15),
                ZIndex = Library.Z.Base + 4,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Indicator"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            -- Sliding thumb. Off state parks it on the left in FaintText
            -- grey; :Set tweens it to the right in white when active.
            Items["Thumb"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 2, 0.5, 0),
                Size = UDim2New(0, 11, 0, 11),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 6,
                BackgroundColor3 = Library.Theme.FaintText
            })  Items["Thumb"]:AddToTheme({BackgroundColor3 = "FaintText"})

            Instances:Create("UICorner", {
                Parent = Items["Thumb"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            -- Legacy aliases so external code that references Items["Check"]
            -- or Items["Shadow"] doesn't break. Both are zero-size invisible
            -- frames — the checkmark rendering and accent halo behind the
            -- pill are gone by design.
            Items["Check"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Shadow"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                Visible = false,
                Size = UDim2New(0, 0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = Toggle.Name,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end

        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Value, IsKeybind)
            if IsKeybind then 
                Value = IsKeybind.Toggled
                Toggle.Value = Value
            else
                Toggle.Value =  Value 
            end

            Library.Flags[Toggle.Flag] = Value 

            if Value then
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Muted Accent"})
                Items["Thumb"]:ChangeItemTheme({BackgroundColor3 = "Image"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Items["Thumb"]:Tween("Slide", {Position = UDim2New(1, -13, 0.5, 0), BackgroundColor3 = Library.Theme.Image})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Muted Accent"]})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})
                Items["Thumb"]:ChangeItemTheme({BackgroundColor3 = "FaintText"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                Items["Thumb"]:Tween("Slide", {Position = UDim2New(0, 2, 0.5, 0), BackgroundColor3 = Library.Theme.FaintText})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end

            if Toggle.Callback then
                Library:SafeCall(Toggle.Callback, Value)
            end
        end

        function Toggle:SetVisibility(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.new(1, 1, 1),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,

                Parent = Items["Toggle"],
                Count = Toggle.Count,
                IsToggle = true,
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local SearchData = {
                Name = Toggle.Name,
                Element = Items["Text"],
                Section = Colorpicker.Section
            }

            TableInsert(Colorpicker.Page.SearchItems, SearchData)
            Library:IndexElement(Colorpicker, "Colorpicker")

            local Extension = Library:CreateColorpicker(Colorpicker)
            return Extension
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,

                Key = nil,
                Picking = false,
                Value = "",
                Toggled = false,
                Count = Toggle.Count,
            }

            Toggle.Count += 1
            Keybind.Count = Toggle.Count

            local SubItems = { } do 
                SubItems["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Items["Toggle"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0,
                    Text = "None",
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(1, 0.5),
                    ZIndex = 4,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["KeyButton"]:AddToTheme({TextColor3 = "Text"})

                local CalculateCount = function(Index)
                    local MaxButtonsAdded = 5

                    local Column = Index % MaxButtonsAdded
                
                    local ButtonSize = SubItems["KeyButton"].Instance.AbsoluteSize
                    local Spacing = 4
                
                    local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - ButtonSize.X
                
                    -- Same story for keybinds pinned to a toggle: clear the
                    -- 28px pill switch instead of the old 16px checkbox.
                    SubItems["KeyButton"].Instance.Position = UDim2New(1, Index == 1 and -XPosition - 36 or -XPosition, 0.5, 0)
                end

                CalculateCount(Keybind.Count)
                
                function Keybind:Get()
                    return Keybind.Toggled, Keybind.Key
                end

                function Keybind:SetVisibility(Bool)
                    SubItems["KeyButton"].Instance.Visible = Bool
                end

                function Keybind:Set(Key)
                    if StringFind(tostring(Key), "Enum") then 
                        Keybind.Key = tostring(Key)

                        Key = Key.Name == "Backspace" and "None" or Key.Name

                        local KeyName = Key
                        local KeyString = Keys[KeyName] or KeyName or "None"
                        local TextToDisplay = KeyString or "None"

                        Keybind.Value = TextToDisplay
                        SubItems["KeyButton"].Instance.Text = TextToDisplay

                        Library.Flags[Keybind.Flag] = {
                            Mode = Keybind.Mode,
                            Key = Keybind.Key,
                            Toggled = Keybind.Toggled
                        }

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                        end

                    elseif TableFind({"Hold", "Toggle", "Always"}, Key) then 
                        Keybind.Mode = Key

                        Keybind:SetMode(Keybind.Mode)

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                        end
                    elseif type(Key) == "table" then 
                        local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                        Keybind.Key = tostring(Key.Key)

                        if Key.Mode then
                            Keybind.Mode = Key.Mode
                            Keybind:SetMode(Key.Mode)
                        else
                            Keybind.Mode = "Toggle"
                            Keybind:SetMode("Toggle")
                        end

                        local RealKeyName = typeof(RealKey) == "EnumItem" and RealKey.Name or tostring(RealKey)
                        local KeyString = Keys[RealKeyName] or RealKeyName or "None"
                        local TextToDisplay = KeyString or "None"

                        Keybind.Value = TextToDisplay
                        SubItems["KeyButton"].Instance.Text = TextToDisplay

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                        end
                    end

                    Keybind.Picking = false 
                    SubItems["KeyButton"]:ChangeItemTheme({TextColor3 = "Text"})
                    SubItems["KeyButton"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end

                function Keybind:SetMode(Mode)
                    if Keybind.Mode == "Always" then 
                        Keybind.Toggled = true
                    else
                        Keybind.Toggled = false
                    end

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Callback then 
                        Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                    end
                end

                function Keybind:Press(Bool)
                    if Keybind.Mode == "Toggle" then
                        Keybind.Toggled = not Keybind.Toggled
                    elseif Keybind.Mode == "Hold" then
                        Keybind.Toggled = Bool
                    elseif Keybind.Mode == "Always" then
                        Keybind.Toggled = true
                    end

                    Toggle:Set(nil, Keybind)

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Callback then 
                        Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                    end 
                end

                SubItems["KeyButton"]:Connect("MouseButton1Click", function()
                    if Keybind.Picking then 
                        return
                    end

                    Keybind.Picking = true

                    SubItems["KeyButton"]:ChangeItemTheme({TextColor3 = "Accent"})
                    SubItems["KeyButton"]:Tween(nil, {TextColor3 = Library.Theme.Accent})

                    local InputBegan 
                    InputBegan = UserInputService.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Keyboard then 
                            Keybind:Set(Input.KeyCode)
                        else
                            Keybind:Set(Input.UserInputType)
                        end

                        InputBegan:Disconnect()
                        InputBegan = nil
                    end)
                end)

                Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
                    if Gpe then 
                        return 
                    end

                    if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Value == "None" then 
                            return 
                        end
                        
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        end
                    end
                end)

                Library:Connect(UserInputService.InputEnded, function(Input)
                    if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then 
                        if Keybind.Value == "None" then 
                            return 
                        end

                        if Keybind.Mode == "Hold" then 
                            Keybind:Press(false)
                        end
                    end
                end)

                if Keybind.Default then
                    Keybind:Set({Key = Keybind.Default, Mode = Keybind.Mode or "Toggle"})
                end

                Library:RegisterKeybindEntry(function()
                    return {
                        Name = Keybind.Name,
                        Key = Keybind.Value,
                        Active = Keybind.Toggled == true and Keybind.Mode ~= "Always",
                    }
                end)

                Library.SetFlags[Keybind.Flag] = function(Value)
                    Keybind:Set(Value)
                end

                return Keybind
            end
        end

        local SearchData = {
            Name = Toggle.Name,
            Element = Items["Text"],
            Section = Toggle.Section,
        }

        TableInsert(Toggle.Page.SearchItems, SearchData)
        Library:IndexElement(Toggle, "Toggle")

        Library:BindTooltip(Items["Toggle"], Library:GetDescription(Data))

        Library:Connect(Items["Toggle"].Instance.MouseEnter, function()
            Items["Text"]:Tween("Hover", {TextTransparency = Toggle.Value and 0 or 0.2})
        end)

        Library:Connect(Items["Toggle"].Instance.MouseLeave, function()
            Items["Text"]:Tween("Hover", {TextTransparency = Toggle.Value and 0 or 0.5})
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        if Toggle.Default then 
            Toggle:Set(Toggle.Default)
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Button",
            Callback = Data.Callback or Data.callback or function() end
        }

        local Items = { } do
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Items["Content"].Instance,
                FontFace = Library.BoldFont,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 26),
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

            Instances:Create("UICorner", {
                Parent = Items["Button"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})
        end

        function Button:Press()
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
            Items["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

            Items["Button"]:Tween("Instant", {BackgroundColor3 = Library.Theme.Accent})
            Items["UIStroke"]:Tween("Instant", {Color = Library.Theme["Light Accent"]})

            task.wait(0.1)

            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
            Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

            Items["Button"]:Tween("Hover", {BackgroundColor3 = Library.Theme.Element})
            Items["UIStroke"]:Tween("Hover", {Color = Library.Theme.Border})

            Library:SafeCall(Button.Callback)
        end

        function Button:SetVisibility(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        function Button:SubButton(Data)
            local SubButton = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local ButtonHolder = Instances:Create("Frame", {
                Parent = Button.Section.Items["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 26),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Button"].Instance.Parent = ButtonHolder.Instance
            Items["Button"].Instance.Size =  UDim2New(0.48, 1, 0, 26)

            local SubItems = { } do
                SubItems["SubButton"] = Instances:Create("TextButton", {
                    Parent = ButtonHolder.Instance,
                    FontFace = Library.BoldFont,
                    TextColor3 = Library.Theme.Text,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = SubButton.Name,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    Name = "\0",
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0.48, 1, 0, 26),
                    ZIndex = Library.Z.Base + 3,
                    TextSize = Library.Text.Body,
                    BackgroundColor3 = Library.Theme.Element
                })  SubItems["SubButton"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = SubItems["SubButton"].Instance,
                    CornerRadius = UDimNew(0, Library.Radius.Medium)
                })

                SubItems["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = SubItems["SubButton"].Instance,
                    Color = Library.Theme.Border,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  SubItems["UIStroke"]:AddToTheme({Color = "Border"})
            end

            function SubButton:Press()
                SubItems["SubButton"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                SubItems["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

                SubItems["SubButton"]:Tween("Instant", {BackgroundColor3 = Library.Theme.Accent})
                SubItems["UIStroke"]:Tween("Instant", {Color = Library.Theme["Light Accent"]})

                task.wait(0.1)

                SubItems["SubButton"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                SubItems["UIStroke"]:ChangeItemTheme({Color = "Border"})

                SubItems["SubButton"]:Tween("Hover", {BackgroundColor3 = Library.Theme.Element})
                SubItems["UIStroke"]:Tween("Hover", {Color = Library.Theme.Border})

                Library:SafeCall(SubButton.Callback)
            end

            function SubButton:SetVisibility(Bool)
                SubItems["SubButton"].Instance.Visible = Bool
            end

            local SearchData = {
                Name = SubButton.Name,
                Element = SubItems["SubButton"],
                Section = SubButton.Section
            }

            TableInsert(SubButton.Page.SearchItems, SearchData)
            Library:IndexElement(SubButton, "Sub Button")

            SubItems["SubButton"]:Connect("MouseButton1Down", function(X, Y)
                Library:Ripple(SubItems["SubButton"], X, Y, Library.Theme["Light Accent"])
                SubButton:Press()
            end)
            
            return SubButton
        end

        local SearchData = {
            Name = Button.Name,
            Element = Items["Button"],
            Section = Button.Section
        }

        TableInsert(Button.Page.SearchItems, SearchData)
        Library:IndexElement(Button, "Button")

        Library:BindTooltip(Items["Button"], Library:GetDescription(Data))

        Items["Button"]:OnHover(function()
            if not Items["Button"].Instance then return end
            Items["Button"]:Tween("Hover", {BackgroundColor3 = FromRGB(28, 28, 38)})
        end)

        Items["Button"]:OnHoverLeave(function()
            if not Items["Button"].Instance then return end
            Items["Button"]:Tween("Hover", {BackgroundColor3 = Library.Theme.Element})
        end)

        Items["Button"]:Connect("MouseButton1Down", function(X, Y)
            Library:Ripple(Items["Button"], X, Y, Library.Theme["Light Accent"])
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = { 
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,

            Value = 0,
            Sliding = false
        }

        local Items = { } do
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 28),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            -- Value reads as tabular-numeric muted-text so the label carries
            -- primary weight and the number recedes until it changes.
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.MutedText,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "0.873",
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "MutedText"})

            Items["ValueInput"] = Instances:Create("TextBox", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Accent,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                ClearTextOnFocus = true,
                Visible = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 70, 0, 15),
                ZIndex = Library.Z.Base + 5,
                TextSize = Library.Text.Body,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ValueInput"]:AddToTheme({TextColor3 = "Accent"})

            -- Track. A single rounded rail — no depth gradient, no inner
            -- shadow. In a dark theme those effects read as noise, not
            -- material. The filled portion carries the value; the empty
            -- portion is deliberately quiet.
            Items["RealSlider"] = Instances:Create("Frame", {
                Parent = Items["Slider"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 4),
                ZIndex = Library.Z.Base + 4,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UICorner", {
                Parent = Items["RealSlider"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            Items["Accent"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                Size = UDim2New(0.673, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 5,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent
            })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["Accent"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            -- Thumb. Solid accent-tinted circle with a thin white stroke —
            -- no external halo, no inner ring. Clean shape at 12x12; still
            -- has a big enough hit-target since the RealSlider intercepts
            -- input across the whole row.
            Items["Drag"] = Instances:Create("TextButton", {
                Parent = Items["Accent"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                BorderSizePixel = 0,
                Name = "\0",
                Position = UDim2New(1, 6, 0.5, 0),
                Size = UDim2New(0, 12, 0, 12),
                ZIndex = Library.Z.Base + 6,
                TextSize = 14,
                BackgroundColor3 = Library.Theme.Accent
            })  Items["Drag"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["Drag"].Instance,
                CornerRadius = UDimNew(1, 0)
            })

            Instances:Create("UIStroke", {
                Parent = Items["Drag"].Instance,
                Color = Library.Theme["Light Accent"],
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Light Accent"})

            -- Legacy aliases so external code that referenced Items["Shadow"],
            -- Items["Shadow2"], or Items["DragInner"] doesn't blow up. Each
            -- is a zero-size, transparent frame — the halos and inner ring
            -- are gone by design.
            Items["Shadow"] = Instances:Create("Frame", {
                Parent = Items["Accent"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })

            Items["Shadow2"] = Instances:Create("Frame", {
                Parent = Items["Drag"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })

            Items["DragInner"] = Instances:Create("Frame", {
                Parent = Items["Drag"].Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                Visible = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value

            Items["Accent"]:Tween("Default", {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
            Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Slider.Suffix)

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        local SearchData = {
            Name = Slider.Name,
            Element = Items["Text"],
            Section = Slider.Section,
        }
        
        TableInsert(Slider.Page.SearchItems, SearchData)
        Library:IndexElement(Slider, "Slider")

        Library:BindTooltip(Items["Slider"], Library:GetDescription(Data))

        -- Double-click the value to type an exact number
        local ValueClickConnection
        local LastValueClick = 0
        local function OpenValueInput()
            Items["ValueInput"].Instance.Text = tostring(Slider.Value)
            Items["Value"].Instance.Visible = false
            Items["ValueInput"].Instance.Visible = true
            Items["ValueInput"].Instance:CaptureFocus()
        end

        local ValueButton = Instances:Create("TextButton", {
            Parent = Items["Slider"].Instance,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            AnchorPoint = Vector2New(1, 0),
            Position = UDim2New(1, 0, 0, 0),
            Size = UDim2New(0, 70, 0, 15),
            ZIndex = 5,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        }) 

        ValueButton:Connect("MouseButton1Down", function()
            local Now = tick()
            if Now - LastValueClick <= 0.35 then 
                OpenValueInput()
            end
            LastValueClick = Now
        end)

        Items["ValueInput"]:Connect("FocusLost", function()
            Items["ValueInput"].Instance.Visible = false
            Items["Value"].Instance.Visible = true

            local Typed = tonumber(Items["ValueInput"].Instance.Text)
            if Typed then 
                Slider:Set(MathClamp(Library:Round(Typed, Slider.Decimals), Slider.Min, Slider.Max))
            end
        end)

        Items["Drag"]:Connect("MouseButton1Down", function(Input)
            Slider.Sliding = true 

            local SizeX = ((UserInputService:GetMouseLocation().X - 15) - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max))
        end)

        -- Touch support: MouseButton1Down only covers the tap that starts a
        -- drag on mobile; we also need the touch begin so we can lock into a
        -- drag when the user starts touching an off-thumb region.
        Items["Drag"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = true

                local SizeX = ((Input.Position.X) - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max))
            end
        end)

        Items["Drag"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = false 
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Slider.Sliding then
                local SizeX = ((Input.Position.X - 1) - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max))
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            -- Default popup height. Each row is 32px + 4px gap (~36px per
            -- option) plus search input + padding, so 360 comfortably fits
            -- 8-9 rows without needing to scroll. Small dropdowns still
            -- auto-shrink to their content at open time so they don't leave
            -- empty scroll space (see :SetOpen).
            MaxSize = Data.MaxSize or Data.maxsize or 360,
            -- Minimum popup width so options don't clip on narrow buttons.
            -- The dropdown button itself might be 120px wide (short label);
            -- popping open a 120px menu with truncated option text is what
            -- the "too small" complaint was really about. We now compute
            -- max(buttonWidth, MinWidth) in SetOpen.
            MinWidth = Data.MinWidth or Data.minwidth or 220,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
        }

        local MultiBadgeThreshold = tonumber(Data.MultiBadgeThreshold) or 3

        local function FormatMultiValue(Values)
            local Count = #Values
            if Count == 0 then 
                return "--"
            end
            if Count < MultiBadgeThreshold then 
                return TableConcat(Values, ", ")
            end
            return StringFormat("%d selected", Count)
        end

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 52),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            -- Parent to the top-level Library.Holder ScreenGui, NOT to the
            -- Dropdown Frame. The Dropdown lives inside a ScrollingFrame
            -- (Section.Left/Right) which clips descendants; leaving the
            -- OptionHolder as a child of that ScrollingFrame made options
            -- invisible whenever they extended past the visible section
            -- bounds. Position is set in absolute screen coordinates each
            -- time the dropdown opens (see Dropdown:SetOpen).
            -- Popover z-band keeps this above the window content but below
            -- modals/tooltips/toasts.
            Items["OptionHolder"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                AutoButtonColor = false,
                Visible = false,
                Text = "",
                Size = UDim2New(0, 200, 0, Dropdown.MaxSize),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Popover,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["OptionHolder"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            -- Soft drop shadow behind the popup so it reads as a distinct
            -- floating surface hovering over the section. ZIndex sits just
            -- below the popup so it's masked outside its footprint.
            Library:AddDropShadow(Items["OptionHolder"], { Padding = 32, Transparency = 0.5, ZIndex = Library.Z.Popover - 1 })

            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Holder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["OptionHolder"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = Library.Z.Popover + 1,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 6, 0, 6),
                Size = UDim2New(1, -12, 1, -12),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["Holder"].Instance,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            local UseDropdownSearch = Data.Search or Data.search or (#Dropdown.Items > 8)
            if UseDropdownSearch then
                Items["Search"] = Instances:Create("TextBox", {
                    Parent = Items["OptionHolder"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme.Text,
                    PlaceholderColor3 = Library.Theme.FaintText,
                    PlaceholderText = "Search",
                    Text = "",
                    Name = "\0",
                    ClearTextOnFocus = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 6, 0, 6),
                    Size = UDim2New(1, -12, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = Library.Z.Popover + 2,
                    TextSize = Library.Text.Body,
                    BackgroundColor3 = Library.Theme.Background
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Background", TextColor3 = "Text", PlaceholderColor3 = "FaintText"})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    CornerRadius = UDimNew(0, Library.Radius.Small)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Color = Library.Theme.Border,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Search"].Instance,
                    PaddingLeft = UDimNew(0, 10)
                })

                Items["Holder"].Instance.Position = UDim2New(0, 6, 0, 40)
                Items["Holder"].Instance.Size = UDim2New(1, -12, 1, -46)

                Items["Search"]:Connect("Changed", function(Property)
                    if Property ~= "Text" then 
                        return
                    end

                    local Query = StringLower(Items["Search"].Instance.Text)
                    for _, OptionData in Dropdown.Options do 
                        if OptionData.Button and OptionData.Button.Instance then 
                            OptionData.Button.Instance.Visible = Query == "" or StringFind(StringLower(OptionData.Name), Query, 1, true) ~= nil
                        end
                    end
                end)
            end

            Items["RealDropdown"] = Instances:Create("TextButton", {
                Parent = Items["Dropdown"].Instance,
                AutoButtonColor = false,
                Text = "",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 32),
                ZIndex = Library.Z.Base + 3,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["RealDropdown"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                TextTruncate = Enum.TextTruncate.AtEnd,
                Size = UDim2New(1, -40, 1, 0),
                Position = UDim2New(0, 12, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Items["OpenIcon"] = Instances:Create("ImageLabel", {
                Parent = Items["RealDropdown"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 10, 0, 10),
                AnchorPoint = Vector2New(1, 0.5),
                Image = "rbxassetid://86523506890491",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -10, 0.5, 0),
                ZIndex = Library.Z.Base + 3,
                BorderSizePixel = 0,
                ImageColor3 = Library.Theme.MutedText,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["OpenIcon"]:AddToTheme({ImageColor3 = "MutedText"})
        end

        local Debounce = false

        function Dropdown:Set(Option)
            if Data.Multi then
                if type(Option) ~= "table" then 
                    return
                end

                for _, OptionData in Dropdown.Options do
                    OptionData.Selected = false
                    OptionData:Toggle("Inactive")
                end

                Dropdown.Value = TableClone(Option)
                Library.Flags[Dropdown.Flag] = Dropdown.Value

                for _, Value in Dropdown.Value do 
                    local OptionData = Dropdown.Options[Value]

                    if not OptionData then 
                        continue
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Items["Value"].Instance.Text = FormatMultiValue(Dropdown.Value)
            else
                local OptionData = Dropdown.Options[Option]

                if not OptionData then 
                    return 
                end

                OptionData.Selected = true  
                OptionData:Toggle("Active")

                Dropdown.Value = OptionData.Name
                Library.Flags[Dropdown.Flag] = Dropdown.Value

                for _, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Items["Value"].Instance.Text = Dropdown.Value
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Dropdown.Value)
            end
        end

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Dropdown.IsOpen = Bool

            Debounce = true 

            if Bool then
                -- Reposition the OptionHolder in absolute screen coords
                -- each time it opens. It lives on Library.Holder (a top-
                -- level ScreenGui) instead of inside the Section
                -- ScrollingFrame, so parent-relative positioning doesn't
                -- apply.
                --
                -- Sizing strategy:
                --   1. Width from button width + MinWidth, clamped to
                --      viewport.
                --   2. Estimate "ideal" content height from actual option
                --      count so a 2-option dropdown doesn't waste space
                --      with an empty scroll area, and a 20-option one
                --      grows toward the MaxSize cap.
                --   3. Pick the direction (below/above the button) with
                --      more available room and use up to that room, capped
                --      by MaxSize and content height.
                local realDD = Items["RealDropdown"].Instance
                local absPos = realDD.AbsolutePosition
                local absSize = realDD.AbsoluteSize
                local viewport = Camera.ViewportSize

                local menuWidth = math.max(absSize.X, Dropdown.MinWidth or 220)
                menuWidth = math.min(menuWidth, viewport.X - 20)

                -- Ideal content height: 12px padding + optional 34px search
                -- overhead + rowCount * 36 (32 row + 4 gap).
                local rowCount = 0
                for _ in pairs(Dropdown.Options) do
                    rowCount = rowCount + 1
                end
                local searchOverhead = Items["Search"] and 34 or 0
                local contentHeight = 12 + searchOverhead + math.max(rowCount, 1) * 36

                -- Room-aware: whichever side of the button has more room
                -- wins. Leaves a 12px margin from the viewport edge.
                local roomBelow = viewport.Y - (absPos.Y + absSize.Y) - 12
                local roomAbove = absPos.Y - 12
                local openDownward = roomBelow >= roomAbove
                local room = openDownward and roomBelow or roomAbove

                local menuHeight = math.min(Dropdown.MaxSize, contentHeight, room)
                -- Floor so a very cramped viewport still shows something
                -- usable rather than a 20px sliver.
                menuHeight = math.max(menuHeight, 140)

                local x = absPos.X
                if x + menuWidth > viewport.X - 10 then
                    x = math.max(10, viewport.X - menuWidth - 10)
                end

                local y
                if openDownward then
                    y = absPos.Y + absSize.Y + 2
                else
                    y = absPos.Y - menuHeight - 2
                end

                Items["OptionHolder"].Instance.Position = UDim2New(0, x, 0, y)
                Items["OptionHolder"].Instance.Size = UDim2New(0, menuWidth, 0, menuHeight)
                Items["OptionHolder"].Instance.Visible = true
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Dropdown.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool,  Dropdown.Window.FadeSpeed)
                end
            end

            if NewTween then 
                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Bool
                end)
            else
                task.delay(Dropdown.Window.FadeSpeed or 0.2, function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Bool
                end)
            end

            -- Fallback release so a cancelled/dropped tween completion never
            -- leaves Debounce stuck true (which was making the dropdown feel
            -- unresponsive after rapid clicks).
            task.delay((Dropdown.Window.FadeSpeed or 0.2) + 0.1, function()
                if Debounce then 
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Bool
                end
            end)
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then
                Dropdown.Options[Option].Button:Clean()
            end

            Dropdown.Options[Option] = nil
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            Dropdown.Options = { }
            Dropdown.Value = Dropdown.Multi and { } or nil
            Library.Flags[Dropdown.Flag] = Dropdown.Value
            Items["Value"].Instance.Text = "--"

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["Holder"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.MutedText,
                Text = Option,
                Name = "\0",
                AutoButtonColor = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -6, 0, 32),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = Library.Z.Popover + 2,
                TextSize = Library.Text.Body,
                BackgroundColor3 = Library.Theme.Element
            })  OptionButton:AddToTheme({TextColor3 = "MutedText", BackgroundColor3 = "Element"})

            Instances:Create("UICorner", {
                Parent = OptionButton.Instance,
                CornerRadius = UDimNew(0, Library.Radius.Small)
            })

            local UIPadding = Instances:Create("UIPadding", {
                Parent = OptionButton.Instance,
                PaddingLeft = UDimNew(0, 12)
            })

            local OptionData = {
                Name = Option,
                Button = OptionButton,
                Padding = UIPadding,
                Selected = false
            }

            -- Track hover state so it can't overwrite the active fill when
            -- the user moves the pointer over a selected row.
            local Hovered = false

            function OptionData:Toggle(Status)
                if Status == "Active" then
                    OptionData.Button:ChangeItemTheme({TextColor3 = "Text", BackgroundColor3 = "Muted Accent"})
                    OptionData.Button:Tween(nil, {
                        TextColor3 = Library.Theme.Text,
                        BackgroundColor3 = Library.Theme["Muted Accent"],
                        BackgroundTransparency = 0,
                    })
                    UIPadding:Tween(nil, {PaddingLeft = UDimNew(0, 16)})
                else
                    OptionData.Button:ChangeItemTheme({TextColor3 = "MutedText", BackgroundColor3 = "Element"})
                    OptionData.Button:Tween(nil, {
                        TextColor3 = Library.Theme.MutedText,
                        BackgroundColor3 = Hovered and Library.Theme.Element or Library.Theme.Element,
                        BackgroundTransparency = Hovered and 0 or 1,
                    })
                    UIPadding:Tween(nil, {PaddingLeft = UDimNew(0, 12)})
                end
            end

            OptionButton:Connect("MouseEnter", function()
                Hovered = true
                if not OptionData.Selected then
                    OptionButton:Tween("Hover", {BackgroundTransparency = 0, TextColor3 = Library.Theme.Text})
                end
            end)

            OptionButton:Connect("MouseLeave", function()
                Hovered = false
                if not OptionData.Selected then
                    OptionButton:Tween("Hover", {BackgroundTransparency = 1, TextColor3 = Library.Theme.MutedText})
                end
            end)

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then 
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = FormatMultiValue(Dropdown.Value)

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    end
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            OptionData.Button:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end
        
        local SearchData = {
            Name = Dropdown.Name,
            Element = Items["Text"],
            Section = Dropdown.Section
        }

        TableInsert(Dropdown.Page.SearchItems, SearchData)
        Library:IndexElement(Dropdown, "Dropdown")

        Library:BindTooltip(Items["Dropdown"], Library:GetDescription(Data))
        Library:AddBoxHover(Items["RealDropdown"])

        Items["RealDropdown"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Dropdown.IsOpen and not Debounce and not Library:IsMouseOverFrame(Items["OptionHolder"]) then
                Dropdown:SetOpen(false)
            end
        end)

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        if Dropdown.Default then
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)
        end

        return Dropdown
    end

    Library.Sections.Label = function(self, Text, Alignment)
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Text or "Label",
            Alignment = Alignment or "Left",

            Count = 0
        }
        
        local Items = { } do
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = Library.Z.Base + 3,
                TextSize = Library.Text.Body,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.new(1, 1, 1),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,

                Parent = Items["Label"],
                Count = Label.Count
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local SearchData = {
                Name = Label.Name,
                Element = Items["Text"],
                Section = Colorpicker.Section
            }

            TableInsert(Colorpicker.Page.SearchItems, SearchData)
            Library:IndexElement(Colorpicker, "Colorpicker")

            local Extension = Library:CreateColorpicker(Colorpicker)
            return Extension
        end

        return Label
    end

    Library.Sections.Keybind = function(self, Data)
        Data = Data or { }

        local Keybind = { 
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Keybind",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
            Callback = Data.Callback or Data.callback or function() end,
            Mode = Data.Mode or Data.mode or "Toggle",

            Key = nil,
            Value = "",
            Toggled = false,
            Picking = false
        }

        Library.Flags[Keybind.Flag] = { }

        local Items = { } do
            Items["Keybind"] = Instances:Create("Frame", {
                Parent = Keybind.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 42),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Keybind"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Keybind.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["RealKeybind"] = Instances:Create("TextButton", {
                Parent = Items["Keybind"].Instance,
                AutoButtonColor = false,
                Text = "",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 26),
                ZIndex = Library.Z.Base + 3,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element
            })  Items["RealKeybind"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["RealKeybind"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["RealKeybind"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealKeybind"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(255, 255, 255),
                Text = "None",
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, -16, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 8, 0, 1),
                ZIndex = 4,
                TextSize = 13,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
        end

        function Keybind:Get()
            return Keybind.Toggled, Keybind.Key
        end

        function Keybind:SetVisibility(Bool)
            Items["Keybind"].Instance.Visible = Bool
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyName = Key
                local KeyString = Keys[KeyName] or KeyName or "None"
                local TextToDisplay = KeyString or "None"

                Keybind.Value = TextToDisplay
                Items["Value"].Instance.Text = TextToDisplay

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end

            elseif TableFind({"Hold", "Toggle", "Always"}, Key) then 
                Keybind.Mode = Key

                Keybind:SetMode(Keybind.Mode)

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then 
                 local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local RealKeyName = typeof(RealKey) == "EnumItem" and RealKey.Name or tostring(RealKey)
                local KeyString = Keys[RealKeyName] or RealKeyName or "None"
                local TextToDisplay = KeyString or "None"

                Keybind.Value = TextToDisplay
                Items["Value"].Instance.Text = TextToDisplay

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false 
            Items["Value"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Text})
        end

        function Keybind:SetMode(Mode)
            if Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            else
                Keybind.Toggled = false
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Keybind.Callback then 
                Library:SafeCall(Keybind.Callback, Keybind.Toggled)
            end
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Keybind.Callback then 
                Library:SafeCall(Keybind.Callback, Keybind.Toggled)
            end 
        end

        local SearchData = {
            Name = Keybind.Name,
            Element = Items["Text"],
            Section = Keybind.Section
        }

        TableInsert(Keybind.Page.SearchItems, SearchData)
        Library:IndexElement(Keybind, "Keybind")

        Library:BindTooltip(Items["Keybind"], Library:GetDescription(Data))
        Library:AddBoxHover(Items["RealKeybind"])

        Items["RealKeybind"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true

            Items["Value"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Accent})

            local InputBegan 
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
            if Gpe then 
                return 
            end

            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Value == "None" then 
                    return 
                end
                
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                end
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then 
                if Keybind.Value == "None" then 
                    return 
                end

                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                end
            end
        end)

        if Keybind.Default then
            Keybind:Set({Key = Keybind.Default, Mode = Keybind.Mode or "Toggle"})
        end

        Library:RegisterKeybindEntry(function()
            return {
                Name = Keybind.Name,
                Key = Keybind.Value,
                Active = Keybind.Toggled == true and Keybind.Mode ~= "Always",
            }
        end)

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,
            Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",

            Value = ""
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 42),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                BorderSizePixel = 0,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                ZIndex = Library.Z.Base + 3,
                Size = UDim2New(1, 0, 0, 26),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Name = "\0",
                PlaceholderColor3 = Library.Theme.FaintText,
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = Library.Text.Body,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Input"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element", PlaceholderColor3 = "FaintText"})

            Instances:Create("UICorner", {
                Parent = Items["Input"].Instance,
                CornerRadius = UDimNew(0, Library.Radius.Medium)
            })

            local InputStroke = Instances:Create("UIStroke", {
                Parent = Items["Input"].Instance,
                Color = Library.Theme.Border,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  InputStroke:AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["Input"].Instance,
                PaddingTop = UDimNew(0, 1),
                PaddingLeft = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10)
            })

            -- Focus glow: stroke lights up to Accent on focus, snaps back on
            -- blur. Ties every text input to the same visual language as
            -- the search overlay's input.
            Library:AddFocusGlow(InputStroke, Items["Input"])
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:Set(Value)
            Items["Input"].Instance.Text = Value

            Textbox.Value = Value

            Library.Flags[Textbox.Flag] = Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        local SearchData = {
            Name = Textbox.Name,
            Element = Items["Text"],
            Section = Textbox.Section,
        }

        TableInsert(Textbox.Page.SearchItems, SearchData)
        Library:IndexElement(Textbox, "Textbox")

        Library:BindTooltip(Items["Textbox"], Library:GetDescription(Data))

        Items["Input"]:Connect("FocusLost", function()
            Textbox:Set(Items["Input"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end

    Library.Sections.Divider = function(self, Text)
        local Divider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
        }

        local Items = { } do
            Items["Divider"] = Instances:Create("Frame", {
                Parent = Divider.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, Text and 14 or 6),
                ZIndex = 4,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Line"] = Instances:Create("Frame", {
                Parent = Items["Divider"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Library.Z.Base + 3,
                BackgroundTransparency = 0.35,
                BackgroundColor3 = Library.Theme.Border
            })  Items["Line"]:AddToTheme({BackgroundColor3 = "Border"})

            if Text then
                Items["Line"].Instance.Size = UDim2New(1, 0, 0, 1)

                -- Small-cap-ish label centered on the line. Uses MutedText
                -- against Background so it reads as a section marker, not a
                -- shouty heading. Background transparency matches parent so
                -- the line appears cleanly interrupted.
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Divider"].Instance,
                    FontFace = Library.Font,
                    Text = Text,
                    TextColor3 = Library.Theme.MutedText,
                    BackgroundColor3 = Library.Theme.Background,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 0, 0, 14),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = Library.Text.Small,
                    ZIndex = Library.Z.Base + 4
                })  Items["Text"]:AddToTheme({TextColor3 = "MutedText", BackgroundColor3 = "Background"})

                Instances:Create("UIPadding", {
                    Parent = Items["Text"].Instance,
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8)
                })
            end
        end

        function Divider:SetVisibility(Bool)
            Items["Divider"].Instance.Visible = Bool
        end

        Divider.Items = Items
        return Divider
    end

    Library.Sections.Image = function(self, Data)
        Data = Data or { }

        local Image = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Id = Data.Image or Data.image or Data.Id or Data.id or "",
            Height = Data.Height or Data.height or 80,
        }

        local AssetId = tostring(Image.Id)
        if StringFind(AssetId, "rbxassetid://", 1, true) ~= 1 and tonumber(AssetId) then 
            AssetId = "rbxassetid://" .. AssetId
        end

        local Items = { } do
            Items["Image"] = Instances:Create("ImageLabel", {
                Parent = Image.Section.Items["Content"].Instance,
                Name = "\0",
                Image = AssetId,
                ScaleType = Data.ScaleType or Enum.ScaleType.Fit,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, Image.Height),
                ZIndex = 4,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            if Data.Rounded ~= false then 
                Instances:Create("UICorner", {
                    Parent = Items["Image"].Instance,
                    CornerRadius = UDimNew(0, 4)
                }) 
            end
        end

        function Image:Set(NewId)
            local Id = tostring(NewId)
            if StringFind(Id, "rbxassetid://", 1, true) ~= 1 and tonumber(Id) then 
                Id = "rbxassetid://" .. Id
            end
            Items["Image"].Instance.Image = Id
        end

        function Image:SetVisibility(Bool)
            Items["Image"].Instance.Visible = Bool
        end

        Image.Items = Items
        return Image
    end

    Library.Sections.Paragraph = function(self, Data)
        Data = Data or { }

        local Paragraph = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or Data.Title or Data.title or "Paragraph",
            Text = Data.Text or Data.text or Data.Desc or Data.Description or Data.desc or Data.description or "",
        }

        local Items = { } do
            Items["Paragraph"] = Instances:Create("Frame", {
                Parent = Paragraph.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 4,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Paragraph"].Instance,
                Padding = UDimNew(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Paragraph"].Instance,
                FontFace = Library.BoldFont,
                Text = Paragraph.Name,
                TextColor3 = Library.Theme.Text,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 16),
                LayoutOrder = 1,
                TextSize = Library.Text.Title,
                ZIndex = Library.Z.Base + 3
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Body"] = Instances:Create("TextLabel", {
                Parent = Items["Paragraph"].Instance,
                FontFace = Library.Font,
                Text = Paragraph.Text,
                TextColor3 = Library.Theme.MutedText,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2New(1, 0, 0, 0),
                LayoutOrder = 2,
                TextSize = Library.Text.Body,
                ZIndex = Library.Z.Base + 3
            })  Items["Body"]:AddToTheme({TextColor3 = "MutedText"})

            if Paragraph.Name == "" then 
                Items["Title"].Instance.Visible = false
            end
        end

        function Paragraph:SetTitle(Text)
            Paragraph.Name = tostring(Text or "")
            Items["Title"].Instance.Text = Paragraph.Name
            Items["Title"].Instance.Visible = Paragraph.Name ~= ""
        end

        function Paragraph:Set(Text)
            Paragraph.Text = tostring(Text or "")
            Items["Body"].Instance.Text = Paragraph.Text
        end

        function Paragraph:SetValue(Text)
            Paragraph:Set(Text)
        end

        function Paragraph:Update(Update)
            if type(Update) ~= "table" then 
                return
            end
            if Update.Title ~= nil then 
                Paragraph:SetTitle(Update.Title)
            end
            if Update.Text ~= nil then 
                Paragraph:Set(Update.Text)
            elseif Update.Desc ~= nil then 
                Paragraph:Set(Update.Desc)
            elseif Update.Description ~= nil then 
                Paragraph:Set(Update.Description)
            end
        end

        function Paragraph:SetVisibility(Bool)
            Items["Paragraph"].Instance.Visible = Bool
        end

        local SearchData = {
            Name = Paragraph.Name,
            Element = Items["Title"],
            Section = Paragraph.Section,
        }

        TableInsert(Paragraph.Page.SearchItems, SearchData)
        Library:IndexElement(Paragraph, "Paragraph")

        Paragraph.Items = Items
        return Paragraph
    end
end

getgenv().Library = Library
return Library
