-- 💩 Poop GUI
-- Executor'a yapıştır ve çalıştır!

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Mevcut GUI'yi temizle
if PlayerGui:FindFirstChild("PoopGUI") then
    PlayerGui.PoopGUI:Destroy()
end

-- Değişkenler
local poopCount = 1
local minCount = 1
local maxCount = 100
local isDragging = false
local dragStart, startPos
local isOnCooldown = false
local isSending = false
local COOLDOWN = 4.0  -- Scriptler bittikten sonra bekleme süresi (saniye)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PoopGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana Frame (biraz büyütüldü)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

-- Başlık çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 52)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 22, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(30, 22, 40)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 70, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 45, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 25, 5))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleEmoji = Instance.new("TextLabel")
TitleEmoji.Size = UDim2.new(0, 40, 1, 0)
TitleEmoji.Position = UDim2.new(0, 12, 0, 0)
TitleEmoji.BackgroundTransparency = 1
TitleEmoji.Text = "💩"
TitleEmoji.TextSize = 22
TitleEmoji.Font = Enum.Font.GothamBold
TitleEmoji.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 52, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Poop Script"
TitleLabel.TextColor3 = Color3.fromRGB(255, 220, 150)
TitleLabel.TextSize = 17
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Kapat butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Ayırıcı çizgi
local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(1, -40, 0, 1)
Divider1.Position = UDim2.new(0, 20, 0, 62)
Divider1.BackgroundColor3 = Color3.fromRGB(139, 90, 43)
Divider1.BackgroundTransparency = 0.5
Divider1.BorderSizePixel = 0
Divider1.Parent = MainFrame

-- ─── BÖLÜM: MİKTAR ───

local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.new(1, -40, 0, 26)
CountLabel.Position = UDim2.new(0, 20, 0, 72)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = "Miktar"
CountLabel.TextColor3 = Color3.fromRGB(180, 140, 100)
CountLabel.TextSize = 13
CountLabel.Font = Enum.Font.GothamBold
CountLabel.TextXAlignment = Enum.TextXAlignment.Left
CountLabel.Parent = MainFrame

local CounterFrame = Instance.new("Frame")
CounterFrame.Size = UDim2.new(1, -40, 0, 60)
CounterFrame.Position = UDim2.new(0, 20, 0, 100)
CounterFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
CounterFrame.BorderSizePixel = 0
CounterFrame.Parent = MainFrame

local CounterCorner = Instance.new("UICorner")
CounterCorner.CornerRadius = UDim.new(0, 10)
CounterCorner.Parent = CounterFrame

local CounterStroke = Instance.new("UIStroke")
CounterStroke.Color = Color3.fromRGB(139, 90, 43)
CounterStroke.Transparency = 0.6
CounterStroke.Thickness = 1
CounterStroke.Parent = CounterFrame

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 54, 1, -16)
MinusBtn.Position = UDim2.new(0, 8, 0, 8)
MinusBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
MinusBtn.Text = "−"
MinusBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
MinusBtn.TextSize = 26
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.BorderSizePixel = 0
MinusBtn.Parent = CounterFrame

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 8)
MinusCorner.Parent = MinusBtn

local NumberDisplay = Instance.new("TextLabel")
NumberDisplay.Size = UDim2.new(1, -124, 1, 0)
NumberDisplay.Position = UDim2.new(0, 70, 0, 0)
NumberDisplay.BackgroundTransparency = 1
NumberDisplay.Text = tostring(poopCount)
NumberDisplay.TextColor3 = Color3.fromRGB(255, 230, 150)
NumberDisplay.TextSize = 28
NumberDisplay.Font = Enum.Font.GothamBold
NumberDisplay.Parent = CounterFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 54, 1, -16)
PlusBtn.Position = UDim2.new(1, -62, 0, 8)
PlusBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
PlusBtn.TextSize = 26
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.BorderSizePixel = 0
PlusBtn.Parent = CounterFrame

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 8)
PlusCorner.Parent = PlusBtn

local RangeLabel = Instance.new("TextLabel")
RangeLabel.Size = UDim2.new(1, -40, 0, 20)
RangeLabel.Position = UDim2.new(0, 20, 0, 165)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "Min: 1  |  Max: 100"
RangeLabel.TextColor3 = Color3.fromRGB(100, 80, 60)
RangeLabel.TextSize = 12
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Parent = MainFrame

-- Tahmini süre (poop arası delay)
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1, -40, 0, 20)
TimeLabel.Position = UDim2.new(0, 20, 0, 185)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "⏱ Tahmini süre: ~0.00s"
TimeLabel.TextColor3 = Color3.fromRGB(120, 100, 70)
TimeLabel.TextSize = 12
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.Parent = MainFrame

-- Ayırıcı çizgi 2
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(1, -40, 0, 1)
Divider2.Position = UDim2.new(0, 20, 0, 212)
Divider2.BackgroundColor3 = Color3.fromRGB(139, 90, 43)
Divider2.BackgroundTransparency = 0.5
Divider2.BorderSizePixel = 0
Divider2.Parent = MainFrame

-- ─── BÖLÜM: COOLDOWN ───

local CooldownSectionLabel = Instance.new("TextLabel")
CooldownSectionLabel.Size = UDim2.new(1, -40, 0, 26)
CooldownSectionLabel.Position = UDim2.new(0, 20, 0, 220)
CooldownSectionLabel.BackgroundTransparency = 1
CooldownSectionLabel.Text = "Kullanım Cooldown"
CooldownSectionLabel.TextColor3 = Color3.fromRGB(180, 140, 100)
CooldownSectionLabel.TextSize = 13
CooldownSectionLabel.Font = Enum.Font.GothamBold
CooldownSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
CooldownSectionLabel.Parent = MainFrame

-- Cooldown görsel bar container
local CooldownFrame = Instance.new("Frame")
CooldownFrame.Size = UDim2.new(1, -40, 0, 52)
CooldownFrame.Position = UDim2.new(0, 20, 0, 248)
CooldownFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
CooldownFrame.BorderSizePixel = 0
CooldownFrame.Parent = MainFrame

local CooldownCorner = Instance.new("UICorner")
CooldownCorner.CornerRadius = UDim.new(0, 10)
CooldownCorner.Parent = CooldownFrame

local CooldownStroke = Instance.new("UIStroke")
CooldownStroke.Color = Color3.fromRGB(80, 60, 120)
CooldownStroke.Transparency = 0.5
CooldownStroke.Thickness = 1
CooldownStroke.Parent = CooldownFrame

-- Cooldown yazısı
local CooldownLabel = Instance.new("TextLabel")
CooldownLabel.Size = UDim2.new(1, 0, 0, 22)
CooldownLabel.Position = UDim2.new(0, 0, 0, 4)
CooldownLabel.BackgroundTransparency = 1
CooldownLabel.Text = "✅ Hazır"
CooldownLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
CooldownLabel.TextSize = 13
CooldownLabel.Font = Enum.Font.GothamBold
CooldownLabel.Parent = CooldownFrame

-- Progress bar arka plan
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -16, 0, 10)
BarBg.Position = UDim2.new(0, 8, 0, 34)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
BarBg.BorderSizePixel = 0
BarBg.Parent = CooldownFrame

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(0, 5)
BarBgCorner.Parent = BarBg

-- Progress bar dolgu
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.Position = UDim2.new(0, 0, 0, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(0, 5)
BarFillCorner.Parent = BarFill

-- Ayırıcı çizgi 3
local Divider3 = Instance.new("Frame")
Divider3.Size = UDim2.new(1, -40, 0, 1)
Divider3.Position = UDim2.new(0, 20, 0, 310)
Divider3.BackgroundColor3 = Color3.fromRGB(139, 90, 43)
Divider3.BackgroundTransparency = 0.5
Divider3.BorderSizePixel = 0
Divider3.Parent = MainFrame

-- ─── BÖLÜM: DURUM & BUTON ───

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 26)
StatusLabel.Position = UDim2.new(0, 20, 0, 318)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Hazır!"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

local PoopBtn = Instance.new("TextButton")
PoopBtn.Size = UDim2.new(1, -40, 0, 72)
PoopBtn.Position = UDim2.new(0, 20, 0, 352)
PoopBtn.BackgroundColor3 = Color3.fromRGB(101, 55, 0)
PoopBtn.Text = "💩  Poop!"
PoopBtn.TextColor3 = Color3.fromRGB(255, 230, 150)
PoopBtn.TextSize = 22
PoopBtn.Font = Enum.Font.GothamBold
PoopBtn.BorderSizePixel = 0
PoopBtn.Parent = MainFrame

local PoopCorner = Instance.new("UICorner")
PoopCorner.CornerRadius = UDim.new(0, 12)
PoopCorner.Parent = PoopBtn

local PoopGradient = Instance.new("UIGradient")
PoopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 90, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 0))
})
PoopGradient.Rotation = 90
PoopGradient.Parent = PoopBtn

local PoopStroke = Instance.new("UIStroke")
PoopStroke.Color = Color3.fromRGB(220, 150, 50)
PoopStroke.Transparency = 0.3
PoopStroke.Thickness = 1.5
PoopStroke.Parent = PoopBtn

-- ─── FONKSİYONLAR ───

local function updateDisplay()
    NumberDisplay.Text = tostring(poopCount)
    local totalTime = (poopCount - 1) * 0.4
    TimeLabel.Text = "⏱ Tahmini süre: ~" .. string.format("%.2f", totalTime) .. "s"
    if poopCount <= minCount then
        MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 5)
        MinusBtn.TextColor3 = Color3.fromRGB(100, 70, 40)
    else
        MinusBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
        MinusBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    if poopCount >= maxCount then
        PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 5)
        PlusBtn.TextColor3 = Color3.fromRGB(100, 70, 40)
    else
        PlusBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
        PlusBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end

-- Cooldown bar animasyonu
local function startCooldown()
    isOnCooldown = true
    PoopBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 5)
    PoopBtn.TextColor3 = Color3.fromRGB(120, 90, 50)
    BarFill.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    CooldownStroke.Color = Color3.fromRGB(200, 80, 80)

    local steps = 100
    local stepTime = COOLDOWN / steps

    for i = steps, 0, -1 do
        local remaining = i * stepTime
        local progress = i / steps

        CooldownLabel.Text = "🕐 Cooldown: " .. string.format("%.1f", remaining) .. "s"
        CooldownLabel.TextColor3 = Color3.fromRGB(220, 120, 80)

        -- Bar doluluk oranı (geri sayım: dolu → boş)
        TweenService:Create(BarFill, TweenInfo.new(stepTime, Enum.EasingStyle.Linear), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()

        -- Renk geçişi: kırmızı → turuncu → yeşil
        local r = math.floor(220 * progress + 80 * (1 - progress))
        local g = math.floor(80 * progress + 220 * (1 - progress))
        BarFill.BackgroundColor3 = Color3.fromRGB(r, g, 60)

        task.wait(stepTime)
    end

    -- Cooldown bitti
    isOnCooldown = false
    CooldownLabel.Text = "✅ Hazır"
    CooldownLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
    CooldownStroke.Color = Color3.fromRGB(80, 60, 120)
    PoopBtn.BackgroundColor3 = Color3.fromRGB(101, 55, 0)
    PoopBtn.TextColor3 = Color3.fromRGB(255, 230, 150)
end

MinusBtn.MouseButton1Click:Connect(function()
    if poopCount > minCount then
        poopCount = poopCount - 1
        updateDisplay()
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    if poopCount < maxCount then
        poopCount = poopCount + 1
        updateDisplay()
    end
end)

PoopBtn.MouseEnter:Connect(function()
    if not isOnCooldown and not isSending then
        TweenService:Create(PoopBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(130, 75, 5)
        }):Play()
    end
end)

PoopBtn.MouseLeave:Connect(function()
    if not isOnCooldown and not isSending then
        TweenService:Create(PoopBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(101, 55, 0)
        }):Play()
    end
end)

-- Poop gönderme
PoopBtn.MouseButton1Click:Connect(function()
    if isOnCooldown or isSending then return end
    isSending = true

    StatusLabel.Text = "Gönderiliyor... (0/" .. poopCount .. ")"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)

    local success = 0
    local failed = 0

    for i = 1, poopCount do
        local ok, _ = pcall(function()
            local args = {
                buffer.fromstring("\000\000\000\000")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end)

        if ok then success = success + 1 else failed = failed + 1 end

        StatusLabel.Text = "Gönderiliyor... (" .. i .. "/" .. poopCount .. ")"

        if i < poopCount then
            local delay = 0.4
            local steps = 40
            for t = steps, 1, -1 do
                local remaining = t * (delay / steps)
                TimeLabel.Text = "⏱ Bekleniyor: " .. string.format("%.2f", remaining) .. "s"
                task.wait(delay / steps)
            end
            TimeLabel.Text = "⏱ Tahmini süre: ~" .. string.format("%.2f", (poopCount - 1) * 0.4) .. "s"
        end
    end

    isSending = false

    if failed == 0 then
        StatusLabel.Text = "✔ " .. success .. " paket gönderildi!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        StatusLabel.Text = "⚠ " .. success .. " OK, " .. failed .. " başarısız"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 160, 60)
    end

    -- Cooldown başlat
    task.spawn(startCooldown)

    task.wait(2.5)
    if not isOnCooldown then
        StatusLabel.Text = "Hazır!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        StatusLabel.Text = "Cooldown bekleniyor..."
        StatusLabel.TextColor3 = Color3.fromRGB(180, 120, 60)
    end
end)

-- Sürükleme
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Insert tuşuyla aç/kapat
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("💩 Poop GUI başarıyla yüklendi! | [Insert] = Aç/Kapat")
