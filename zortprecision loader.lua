loader.lua


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Precision Configuration
local Settings = {
    Precision = 1.0,
    PredictionValue = 0.155,
    AimPart = "Head",
    ToggleKey = Enum.KeyCode.Q,
    MenuKey = Enum.KeyCode.RightControl
}

-- Premium UI Elements
local ZortGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Container = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

-- Sleek Design Setup
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "ZORT PRECISION"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Text = "CAMLOCK"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

-- Precision Camlock System
local Target = nil
local Enabled = false

local function GetTarget()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer and Player.Character and Player.Character:FindFirstChild(Settings.AimPart) then
            local TargetVector = Player.Character[Settings.AimPart].Position
            local TargetDistance = (TargetVector - workspace.CurrentCamera.CFrame.Position).Magnitude
            
            if TargetDistance < ClosestDistance then
                ClosestDistance = TargetDistance
                ClosestPlayer = Player
            end
        end
    end
    return ClosestPlayer
end

RunService.RenderStepped:Connect(function()
    if Enabled and Target and Target.Character then
        local TargetPosition = Target.Character[Settings.AimPart].Position
        local TargetVelocity = Target.Character.HumanoidRootPart.Velocity
        
        -- Precision Calculation
        local PredictedPosition = TargetPosition + (TargetVelocity * Settings.PredictionValue)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, PredictedPosition)
    end
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Settings.ToggleKey then
        Enabled = not Enabled
        Target = GetTarget()
        ToggleButton.BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- Initialize
ZortGui.Parent = game.CoreGui
MainFrame.Parent = ZortGui

-- Welcome Effect
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(0, 200, 0, 50)
WelcomeText.Position = UDim2.new(0.5, -100, 0.4, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.TextColor3 = Color3.fromRGB(255, 0, 0)
WelcomeText.Text = "ZORT LOADED"
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextSize = 24
WelcomeText.Parent = ZortGui

TweenService:Create(WelcomeText, TweenInfo.new(1), {TextTransparency = 1}):Play()
wait(2)
WelcomeText:Destroy()
