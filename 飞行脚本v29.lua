local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local flySpeed = 100
local minSpeed = 100
local maxSpeed = 1000
local isFlying = false
local flyDirection = Vector3.new(0, 0, 0)
local joystickDirection = Vector3.new(0, 0, 0)
local flyGyro = nil
local flyVelocity = nil
local originalMotorOffsets = {}
local savedOriginalPose = false
local flyParticles = nil
local guiElements = {}
local function saveOriginalMotorOffsets()
    originalMotorOffsets = {}
    local count = 0
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("Motor6D") then
            originalMotorOffsets[part] = {
                C0 = part.C0,
                C1 = part.C1
            }
            count = count + 1
        end
    end
    savedOriginalPose = true
    print()
end
local function getJoints()
    local joints = {}
    local isR15 = not character:FindFirstChild("Torso")
    joints.isR15 = isR15
    if isR15 then
        joints.rootJoint = character:FindFirstChild("LowerTorso") and
                            character.LowerTorso:FindFirstChild("Root")
        if not joints.rootJoint then
            joints.rootJoint = character:FindFirstChild("HumanoidRootPart") and
                                character.HumanoidRootPart:FindFirstChild("RootJoint")
        end
        if not joints.rootJoint then
            joints.rootJoint = character:FindFirstChild("HumanoidRootPart") and
                                character.HumanoidRootPart:FindFirstChild("Root")
        end
        joints.neck = character:FindFirstChild("Head") and
                        character.Head:FindFirstChild("Neck")
        if not joints.neck then
            joints.neck = character:FindFirstChild("UpperTorso") and
                        character.UpperTorso:FindFirstChild("Neck")
        end
        joints.leftShoulder = character:FindFirstChild("UpperTorso") and
                                character.UpperTorso:FindFirstChild("LeftShoulder")
        joints.rightShoulder = character:FindFirstChild("UpperTorso") and
                                character.UpperTorso:FindFirstChild("RightShoulder")
        joints.leftElbow = character:FindFirstChild("LeftUpperArm") and
                            character.LeftUpperArm:FindFirstChild("LeftElbow")
        joints.rightElbow = character:FindFirstChild("RightUpperArm") and
                            character.RightUpperArm:FindFirstChild("RightElbow")
        joints.leftHip = character:FindFirstChild("LowerTorso") and
                        character.LowerTorso:FindFirstChild("LeftHip")
        joints.rightHip = character:FindFirstChild("LowerTorso") and
                        character.LowerTorso:FindFirstChild("RightHip")
        joints.leftKnee = character:FindFirstChild("LeftUpperLeg") and
                        character.LeftUpperLeg:FindFirstChild("LeftKnee")
        joints.rightKnee = character:FindFirstChild("RightUpperLeg") and
                            character.RightUpperLeg:FindFirstChild("RightKnee")
        joints.waist = character:FindFirstChild("UpperTorso") and
                        character.UpperTorso:FindFirstChild("Waist")
    else
        joints.rootJoint = character:FindFirstChild("HumanoidRootPart") and
                            character.HumanoidRootPart:FindFirstChild("RootJoint")
        joints.neck = character:FindFirstChild("Torso") and
                        character.Torso:FindFirstChild("Neck")
        joints.leftShoulder = character:FindFirstChild("Torso") and
                                character.Torso:FindFirstChild("Left Shoulder")
        joints.rightShoulder = character:FindFirstChild("Torso") and
                                character.Torso:FindFirstChild("Right Shoulder")
        joints.leftHip = character:FindFirstChild("Torso") and
                        character.Torso:FindFirstChild("Left Hip")
        joints.rightHip = character:FindFirstChild("Torso") and
                        character.Torso:FindFirstChild("Right Hip")
    end
    return joints
end
local poseDebugPrinted = false
local function forceSupermanPose()
    if not savedOriginalPose then return end
    local joints = getJoints()
    if not poseDebugPrinted then
        print()
        print()
        print()
        print()
        print()
        print()
        print()
        print()
        if joints.isR15 then
            print()
            print()
            print()
            print()
            print()
        end
        poseDebugPrinted = true
    end
    if joints.rootJoint and originalMotorOffsets[joints.rootJoint] then
        local rootOffset = CFrame.Angles(math.rad(-50), 0, 0)
        joints.rootJoint.C0 = originalMotorOffsets[joints.rootJoint].C0 * rootOffset
    end
    if joints.waist and originalMotorOffsets[joints.waist] then
        local waistOffset = CFrame.Angles(math.rad(-15), 0, 0)
        joints.waist.C0 = originalMotorOffsets[joints.waist].C0 * waistOffset
    end
    if joints.neck and originalMotorOffsets[joints.neck] then
        local neckOffset = CFrame.Angles(math.rad(55), 0, 0)
        joints.neck.C0 = originalMotorOffsets[joints.neck].C0 * neckOffset
    end
    if joints.leftShoulder and originalMotorOffsets[joints.leftShoulder] then
        local armOffset = CFrame.Angles(math.rad(-100), 0, math.rad(-15))
        joints.leftShoulder.C0 = originalMotorOffsets[joints.leftShoulder].C0 * armOffset
    end
    if joints.rightShoulder and originalMotorOffsets[joints.rightShoulder] then
        local armOffset = CFrame.Angles(math.rad(-100), 0, math.rad(15))
        joints.rightShoulder.C0 = originalMotorOffsets[joints.rightShoulder].C0 * armOffset
    end
    if joints.leftElbow and originalMotorOffsets[joints.leftElbow] then
        local elbowOffset = CFrame.Angles(math.rad(-15), 0, 0)
        joints.leftElbow.C0 = originalMotorOffsets[joints.leftElbow].C0 * elbowOffset
    end
    if joints.rightElbow and originalMotorOffsets[joints.rightElbow] then
        local elbowOffset = CFrame.Angles(math.rad(-15), 0, 0)
        joints.rightElbow.C0 = originalMotorOffsets[joints.rightElbow].C0 * elbowOffset
    end
    if joints.leftHip and originalMotorOffsets[joints.leftHip] then
        local legOffset = CFrame.Angles(math.rad(50), 0, 0)
        joints.leftHip.C0 = originalMotorOffsets[joints.leftHip].C0 * legOffset
    end
    if joints.rightHip and originalMotorOffsets[joints.rightHip] then
        local legOffset = CFrame.Angles(math.rad(50), 0, 0)
        joints.rightHip.C0 = originalMotorOffsets[joints.rightHip].C0 * legOffset
    end
    if joints.leftKnee and originalMotorOffsets[joints.leftKnee] then
        local kneeOffset = CFrame.Angles(math.rad(-25), 0, 0)
        joints.leftKnee.C0 = originalMotorOffsets[joints.leftKnee].C0 * kneeOffset
    end
    if joints.rightKnee and originalMotorOffsets[joints.rightKnee] then
        local kneeOffset = CFrame.Angles(math.rad(-25), 0, 0)
        joints.rightKnee.C0 = originalMotorOffsets[joints.rightKnee].C0 * kneeOffset
    end
end
local function restoreOriginalPose()
    local count = 0
    for motor, offsets in pairs(originalMotorOffsets) do
        if motor and motor.Parent then
            motor.C0 = offsets.C0
            motor.C1 = offsets.C1
            count = count + 1
        end
    end
    print()
end
local function createFlyParticles()
    if not rootPart then return end
    if rootPart:FindFirstChild("AtomicTailTrail") then
        rootPart.AtomicTailTrail:Destroy()
    end
    local trailFolder = Instance.new("Folder")
    trailFolder.Name = "AtomicTailTrail"
    trailFolder.Parent = rootPart
    local attLeft = Instance.new("Attachment")
    attLeft.Name = "TrailLeft"
    attLeft.Position = Vector3.new(-0.7, -1.25, 1.05)
    attLeft.Parent = rootPart
    local attRight = Instance.new("Attachment")
    attRight.Name = "TrailRight"
    attRight.Position = Vector3.new(0.7, -1.25, 1.05)
    attRight.Parent = rootPart
    local trailOuter = Instance.new("Trail")
    trailOuter.Attachment0 = attLeft
    trailOuter.Attachment1 = attRight
    trailOuter.Lifetime = 0.85
    trailOuter.LightEmission = 0.18
    trailOuter.FaceCamera = true
    trailOuter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 36, 36)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 62, 62)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 90, 90))
    })
    trailOuter.Transparency = NumberSequence.new(0.45, 0.62, 1)
    trailOuter.WidthScale = NumberSequence.new(0.95, 0.7, 0)
    trailOuter.Parent = trailFolder
    local trailInner = Instance.new("Trail")
    trailInner.Attachment0 = attLeft
    trailInner.Attachment1 = attRight
    trailInner.Lifetime = 0.55
    trailInner.LightEmission = 0.08
    trailInner.FaceCamera = true
    trailInner.Color = ColorSequence.new(Color3.fromRGB(170, 125, 125), Color3.fromRGB(120, 80, 80))
    trailInner.Transparency = NumberSequence.new(0.6, 0.72, 1)
    trailInner.WidthScale = NumberSequence.new(0.3, 0.16, 0)
    trailInner.Parent = trailFolder
    return {trailFolder, attLeft, attRight, trailOuter, trailInner}
end
local function removeFlyParticles()
    if flyParticles then
        for _, obj in pairs(flyParticles) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        flyParticles = nil
    end
    if rootPart then
        local existing = rootPart:FindFirstChild("AtomicTailTrail")
        if existing then
            existing:Destroy()
        end
    end
end
local function createFlyGUI()
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CatFlyGUI"
    screenGui.ResetOnSpawn = false      
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    guiElements.screenGui = screenGui
    local floatBtn = Instance.new("ImageButton")
    floatBtn.Name = "FloatButton"
    floatBtn.Size = UDim2.new(0, 40, 0, 40)       
    floatBtn.Position = UDim2.new(0, 20, 0, 60)     
    floatBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    floatBtn.BackgroundTransparency = 0.1
    floatBtn.Image = "rbxassetid://75293061485556"                             
    floatBtn.BorderSizePixel = 0
    floatBtn.AutoButtonColor = false
    floatBtn.Visible = false                        
    floatBtn.Parent = screenGui
    guiElements.floatBtn = floatBtn
    local floatCorner = Instance.new("UICorner")
    floatCorner.CornerRadius = UDim.new(1, 0)
    floatCorner.Parent = floatBtn
    local floatStroke = Instance.new("UIStroke")
    floatStroke.Color = Color3.fromRGB(100, 220, 255)
    floatStroke.Transparency = 0.5
    floatStroke.Thickness = 2
    floatStroke.Parent = floatBtn
    local function breatheAnimation()
        local tweenIn = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        TweenService:Create(floatStroke, tweenIn, {Transparency = 0.2}):Play()
    end
    breatheAnimation()
    local panelFrame = Instance.new("Frame")
    panelFrame.Name = "PanelFrame"
    panelFrame.Size = UDim2.new(0, 160, 0, 195)     
    panelFrame.Position = UDim2.new(0.5, -80, 0.5, -97)  
    panelFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    panelFrame.BackgroundTransparency = 0.15
    panelFrame.BorderSizePixel = 0
    panelFrame.Visible = true                      
    panelFrame.Parent = screenGui
    guiElements.panelFrame = panelFrame
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 16)
    panelCorner.Parent = panelFrame
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(100, 220, 255)
    panelStroke.Transparency = 0.7
    panelStroke.Thickness = 2
    panelStroke.Parent = panelFrame
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Position = UDim2.new(0, 8, 0, 6)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 85, 100)
    minimizeBtn.BackgroundTransparency = 0.3
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 14
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = panelFrame
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeBtn
    local panelTitle = Instance.new("TextLabel")
    panelTitle.Name = "PanelTitle"
    panelTitle.Size = UDim2.new(1, -56, 0, 26)
    panelTitle.Position = UDim2.new(0, 28, 0, 6)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "猫飞行"
    panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    panelTitle.TextSize = 14
    panelTitle.Font = Enum.Font.GothamBold
    panelTitle.Parent = panelFrame
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -24, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = panelFrame
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    local confirmDialog = Instance.new("Frame")
    confirmDialog.Name = "ConfirmDialog"
    confirmDialog.Size = UDim2.new(1, 0, 1, 0)       
    confirmDialog.Position = UDim2.new(0, 0, 0, 0)   
    confirmDialog.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    confirmDialog.BackgroundTransparency = 0.05
    confirmDialog.BorderSizePixel = 0
    confirmDialog.ZIndex = 10
    confirmDialog.Visible = false
    confirmDialog.Parent = panelFrame
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 12)
    confirmCorner.Parent = confirmDialog
    local confirmStroke = Instance.new("UIStroke")
    confirmStroke.Color = Color3.fromRGB(80, 85, 100)
    confirmStroke.Transparency = 0.5
    confirmStroke.Thickness = 1
    confirmStroke.Parent = confirmDialog
    local confirmTitle = Instance.new("TextLabel")
    confirmTitle.Name = "ConfirmTitle"
    confirmTitle.Size = UDim2.new(1, 0, 0, 30)
    confirmTitle.Position = UDim2.new(0, 0, 0, 28)
    confirmTitle.BackgroundTransparency = 1
    confirmTitle.Text = "关闭飞行"
    confirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmTitle.TextSize = 15
    confirmTitle.Font = Enum.Font.GothamBold
    confirmTitle.ZIndex = 11
    confirmTitle.Parent = confirmDialog
    local confirmText = Instance.new("TextLabel")
    confirmText.Name = "ConfirmText"
    confirmText.Size = UDim2.new(1, -24, 0, 36)
    confirmText.Position = UDim2.new(0, 12, 0, 62)
    confirmText.BackgroundTransparency = 1
    confirmText.Text = "是否要关闭猫飞行？您将无法再次打开它"
    confirmText.TextColor3 = Color3.fromRGB(180, 185, 195)
    confirmText.TextSize = 12
    confirmText.Font = Enum.Font.Gotham
    confirmText.TextWrapped = true
    confirmText.ZIndex = 11
    confirmText.Parent = confirmDialog
    local btnContainer = Instance.new("Frame")
    btnContainer.Name = "BtnContainer"
    btnContainer.Size = UDim2.new(1, -24, 0, 34)
    btnContainer.Position = UDim2.new(0, 12, 1, -50)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ZIndex = 11
    btnContainer.Parent = confirmDialog
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0, 10)
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.Parent = btnContainer
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Name = "CancelBtn"
    cancelBtn.Size = UDim2.new(0.5, -5, 1, 0)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(55, 58, 65)
    cancelBtn.Text = "取消"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 13
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.BorderSizePixel = 0
    cancelBtn.ZIndex = 11
    cancelBtn.Parent = btnContainer
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 8)
    cancelCorner.Parent = cancelBtn
    local closeFlyBtn = Instance.new("TextButton")
    closeFlyBtn.Name = "CloseFlyBtn"
    closeFlyBtn.Size = UDim2.new(0.5, -5, 1, 0)
    closeFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeFlyBtn.Text = "关闭飞行"
    closeFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeFlyBtn.TextSize = 13
    closeFlyBtn.Font = Enum.Font.GothamBold
    closeFlyBtn.BorderSizePixel = 0
    closeFlyBtn.ZIndex = 11
    closeFlyBtn.Parent = btnContainer
    local closeFlyCorner = Instance.new("UICorner")
    closeFlyCorner.CornerRadius = UDim.new(0, 8)
    closeFlyCorner.Parent = closeFlyBtn
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -16, 0, 142)
    contentFrame.Position = UDim2.new(0, 8, 0, 38)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panelFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = contentFrame
    local toggleRow = Instance.new("Frame")
    toggleRow.Name = "ToggleRow"
    toggleRow.Size = UDim2.new(1, 0, 0, 36)
    toggleRow.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    toggleRow.BackgroundTransparency = 0.3
    toggleRow.BorderSizePixel = 0
    toggleRow.LayoutOrder = 1
    toggleRow.Parent = contentFrame
    local toggleRowCorner = Instance.new("UICorner")
    toggleRowCorner.CornerRadius = UDim.new(0, 10)
    toggleRowCorner.Parent = toggleRow
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Name = "ArrowLabel"
    arrowLabel.Size = UDim2.new(0, 20, 1, 0)
    arrowLabel.Position = UDim2.new(0, 8, 0, 0)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Text = "≫"
    arrowLabel.TextColor3 = Color3.fromRGB(100, 220, 255)
    arrowLabel.TextSize = 14
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.Parent = toggleRow
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "ToggleText"
    toggleText.Size = UDim2.new(0, 90, 1, 0)
    toggleText.Position = UDim2.new(0, 28, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = "开启飞行"
    toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleText.TextSize = 13
    toggleText.Font = Enum.Font.GothamBold
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleRow
    guiElements.toggleText = toggleText
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundTransparency = 0.85
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = toggleRow
    guiElements.toggleBtn = toggleBtn
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleBtn
    local toggleBtnStroke = Instance.new("UIStroke")
    toggleBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    toggleBtnStroke.Transparency = 0.8
    toggleBtnStroke.Thickness = 1
    toggleBtnStroke.Parent = toggleBtn
    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "ToggleDot"
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBtn
    guiElements.toggleDot = toggleDot
    local toggleDotCorner = Instance.new("UICorner")
    toggleDotCorner.CornerRadius = UDim.new(1, 0)
    toggleDotCorner.Parent = toggleDot
    toggleBtn.MouseButton1Click:Connect(function()
        toggleFly()
    end)
    local speedRow = Instance.new("Frame")
    speedRow.Name = "SpeedRow"
    speedRow.Size = UDim2.new(1, 0, 0, 48)
    speedRow.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    speedRow.BackgroundTransparency = 0.3
    speedRow.BorderSizePixel = 0
    speedRow.LayoutOrder = 2
    speedRow.Parent = contentFrame
    local speedRowCorner = Instance.new("UICorner")
    speedRowCorner.CornerRadius = UDim.new(0, 10)
    speedRowCorner.Parent = speedRow
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 50, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 5)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "速度"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 13
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedRow
    local speedValue = Instance.new("TextLabel")
    speedValue.Name = "SpeedValue"
    speedValue.Size = UDim2.new(0, 50, 0, 20)
    speedValue.Position = UDim2.new(1, -58, 0, 5)
    speedValue.BackgroundTransparency = 1
    speedValue.Text = "0%"
    speedValue.TextColor3 = Color3.fromRGB(100, 220, 255)
    speedValue.TextSize = 13
    speedValue.Font = Enum.Font.GothamBold
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    speedValue.Parent = speedRow
    guiElements.speedValue = speedValue
    local speedTrack = Instance.new("Frame")
    speedTrack.Name = "SpeedTrack"
    speedTrack.Size = UDim2.new(1, -20, 0, 6)
    speedTrack.Position = UDim2.new(0, 10, 0, 32)
    speedTrack.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    speedTrack.BorderSizePixel = 0
    speedTrack.Parent = speedRow
    local speedTrackCorner = Instance.new("UICorner")
    speedTrackCorner.CornerRadius = UDim.new(0, 3)
    speedTrackCorner.Parent = speedTrack
    local speedFill = Instance.new("Frame")
    speedFill.Name = "SpeedFill"
    speedFill.Size = UDim2.new(0, 0, 1, 0)
    speedFill.BackgroundColor3 = Color3.fromRGB(100, 220, 255)
    speedFill.BorderSizePixel = 0
    speedFill.Parent = speedTrack
    guiElements.speedFill = speedFill
    local speedFillCorner = Instance.new("UICorner")
    speedFillCorner.CornerRadius = UDim.new(0, 3)
    speedFillCorner.Parent = speedFill
    local speedBtn = Instance.new("TextButton")
    speedBtn.Name = "SpeedBtn"
    speedBtn.Size = UDim2.new(0, 14, 0, 14)
    speedBtn.Position = UDim2.new(0, -7, 0.5, -7)
    speedBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.Text = ""
    speedBtn.BorderSizePixel = 0
    speedBtn.Parent = speedTrack
    guiElements.speedBtn = speedBtn
    local speedBtnCorner = Instance.new("UICorner")
    speedBtnCorner.CornerRadius = UDim.new(1, 0)
    speedBtnCorner.Parent = speedBtn
    local isDraggingSpeed = false
    local function updateSpeedSlider(input)
        local trackPos = speedTrack.AbsolutePosition.X
        local trackWidth = speedTrack.AbsoluteSize.X
        local inputX = input.Position.X
        local relativePos = math.clamp((inputX - trackPos) / trackWidth, 0, 1)
        speedBtn.Position = UDim2.new(relativePos, -7, 0.5, -7)
        speedFill.Size = UDim2.new(relativePos, 0, 1, 0)
        flySpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * relativePos)
        speedValue.Text = tostring(math.floor(relativePos * 100)) .. "%"
    end
    speedBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSpeed = true
        end
    end)
    speedTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSpeed = true
            updateSpeedSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSpeed = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not isDraggingSpeed then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and
            input.UserInputType ~= Enum.UserInputType.Touch then return end
        updateSpeedSlider(input)
    end)
    local heightRow = Instance.new("Frame")
    heightRow.Name = "HeightRow"
    heightRow.Size = UDim2.new(1, 0, 0, 36)
    heightRow.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    heightRow.BackgroundTransparency = 0.3
    heightRow.BorderSizePixel = 0
    heightRow.LayoutOrder = 3
    heightRow.Parent = contentFrame
    local heightRowCorner = Instance.new("UICorner")
    heightRowCorner.CornerRadius = UDim.new(0, 10)
    heightRowCorner.Parent = heightRow
    local heightLabel = Instance.new("TextLabel")
    heightLabel.Name = "HeightLabel"
    heightLabel.Size = UDim2.new(0, 50, 1, 0)
    heightLabel.Position = UDim2.new(0, 10, 0, 0)
    heightLabel.BackgroundTransparency = 1
    heightLabel.Text = "高度"
    heightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    heightLabel.TextSize = 13
    heightLabel.Font = Enum.Font.GothamBold
    heightLabel.TextXAlignment = Enum.TextXAlignment.Left
    heightLabel.Parent = heightRow
    local heightValue = Instance.new("TextLabel")
    heightValue.Name = "HeightValue"
    heightValue.Size = UDim2.new(0, 60, 1, 0)
    heightValue.Position = UDim2.new(1, -68, 0, 0)
    heightValue.BackgroundTransparency = 1
    heightValue.Text = "0"
    heightValue.TextColor3 = Color3.fromRGB(100, 220, 255)
    heightValue.TextSize = 13
    heightValue.Font = Enum.Font.GothamBold
    heightValue.TextXAlignment = Enum.TextXAlignment.Right
    heightValue.Parent = heightRow
    guiElements.heightValue = heightValue
    local isDraggingPanel = false
    local panelDragStart = nil
    local panelFrameStart = nil
    panelFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            local absPos = panelFrame.AbsolutePosition
            local absSize = panelFrame.AbsoluteSize
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local relX = mousePos.X - absPos.X
            local relY = mousePos.Y - absPos.Y
            if relX > (absSize.X - 30) and relY < 30 then
                return
            end
            if relX > (absSize.X - 60) and relY > 40 and relY < 80 then
                return
            end
            if relY > 85 and relY < 140 then
                return
            end
            isDraggingPanel = true
            panelDragStart = mousePos
            panelFrameStart = panelFrame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingPanel = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not isDraggingPanel then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and
            input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - panelDragStart
        panelFrame.Position = UDim2.new(
            panelFrameStart.X.Scale, panelFrameStart.X.Offset + delta.X,
            panelFrameStart.Y.Scale, panelFrameStart.Y.Offset + delta.Y
        )
    end)
    local panelOpen = false
    local function togglePanel()
        panelOpen = not panelOpen
        panelFrame.Visible = panelOpen
        if panelOpen then
            floatBtn.Visible = false
            panelFrame.Position = UDim2.new(0.5, -80, 0.5, -97)
            panelFrame.Size = UDim2.new(0, 0, 0, 0)
            local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(panelFrame, tweenInfo, {
                Size = UDim2.new(0, 160, 0, 195)
            }):Play()
        end
    end
    floatBtn.MouseButton1Click:Connect(function()
        togglePanel()
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        panelOpen = false
        panelFrame.Visible = false
        confirmDialog.Visible = false
        floatBtn.Position = UDim2.new(0, 20, 0, 60)
        floatBtn.Visible = true
    end)
    closeBtn.MouseButton1Click:Connect(function()
        confirmDialog.Visible = true
    end)
    cancelBtn.MouseButton1Click:Connect(function()
        confirmDialog.Visible = false
    end)
    closeFlyBtn.MouseButton1Click:Connect(function()
        if isFlying then
            stopFlying()
        end
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
        print()
        guiElements = nil
        flyDirection = nil
        joystickDirection = nil
        originalMotorOffsets = nil
    end)
    local isDraggingFloat = false
    local floatDragStart = nil
    local floatFrameStart = nil
    floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingFloat = true
            floatDragStart = Vector2.new(input.Position.X, input.Position.Y)
            floatFrameStart = floatBtn.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            isDraggingFloat = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not isDraggingFloat then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and
            input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - floatDragStart
        floatBtn.Position = UDim2.new(
            floatFrameStart.X.Scale, floatFrameStart.X.Offset + delta.X,
            floatFrameStart.Y.Scale, floatFrameStart.Y.Offset + delta.Y
        )
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F then
            togglePanel()
        end
    end)
    print()
end
local function updateGUI()
    if not guiElements.toggleBtn then return end
    if isFlying then
        guiElements.toggleText.Text = "关闭飞行"
        guiElements.toggleText.TextColor3 = Color3.fromRGB(100, 220, 255)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(guiElements.toggleDot, tweenInfo, {
            Position = UDim2.new(1, -19, 0.5, -8)
        }):Play()
        TweenService:Create(guiElements.toggleBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(100, 220, 255)
        }):Play()
    else
        guiElements.toggleText.Text = "开启飞行"
        guiElements.toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(guiElements.toggleDot, tweenInfo, {
            Position = UDim2.new(0, 3, 0.5, -8)
        }):Play()
        TweenService:Create(guiElements.toggleBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end
end
function setCatImage(imageId)
    if guiElements.floatBtn then
        guiElements.floatBtn.Image = imageId
    end
    print()
end
local function startFlying()
    if isFlying then return end
    isFlying = true
    flyGyro = Instance.new("BodyGyro")
    flyGyro.Parent = rootPart
    flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.D = 500
    flyGyro.P = 50000
    flyGyro.CFrame = rootPart.CFrame
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Parent = rootPart
    flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVelocity.Velocity = Vector3.new(0, 0, 0)
    humanoid.PlatformStand = true
    if not savedOriginalPose then
        saveOriginalMotorOffsets()
    end
    poseDebugPrinted = false
    forceSupermanPose()
    flyParticles = createFlyParticles()
    updateGUI()
    print()
end
local function stopFlying()
    if not isFlying then return end
    isFlying = false
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    humanoid.PlatformStand = false
    restoreOriginalPose()
    removeFlyParticles()
    flyDirection = Vector3.new(0, 0, 0)
    joystickDirection = Vector3.new(0, 0, 0)
    updateGUI()
    print()
end
function toggleFly()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end
local function setupSystemJoystick()
    humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
        if not isFlying then return end
        local moveDir = humanoid.MoveDirection
        joystickDirection = Vector3.new(moveDir.X, 0, moveDir.Z)
    end)
    print()
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.F then
    end
    if not isFlying then return end
    if key == Enum.KeyCode.W then
        flyDirection = flyDirection + Vector3.new(0, 0, -1)
    end
    if key == Enum.KeyCode.S then
        flyDirection = flyDirection + Vector3.new(0, 0, 1)
    end
    if key == Enum.KeyCode.A then
        flyDirection = flyDirection + Vector3.new(-1, 0, 0)
    end
    if key == Enum.KeyCode.D then
        flyDirection = flyDirection + Vector3.new(1, 0, 0)
    end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not isFlying then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then
        flyDirection = flyDirection - Vector3.new(0, 0, -1)
    end
    if key == Enum.KeyCode.S then
        flyDirection = flyDirection - Vector3.new(0, 0, 1)
    end
    if key == Enum.KeyCode.A then
        flyDirection = flyDirection - Vector3.new(-1, 0, 0)
    end
    if key == Enum.KeyCode.D then
        flyDirection = flyDirection - Vector3.new(1, 0, 0)
    end
end)
RunService.RenderStepped:Connect(function()
    if guiElements.heightValue and rootPart then
        local currentHeight = math.floor(rootPart.Position.Y)
        guiElements.heightValue.Text = tostring(currentHeight)
    end
    if isFlying and savedOriginalPose then
        forceSupermanPose()
    end
    if not isFlying or not flyVelocity or not flyGyro then return end
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local cameraLook = cameraCFrame.LookVector
    local cameraRight = cameraCFrame.RightVector
    local kbRight = flyDirection.X
    local kbForward = -flyDirection.Z
    local jsForward = joystickDirection:Dot(cameraLook)
    local jsRight = joystickDirection:Dot(cameraRight)
    local inputX = kbRight + jsRight
    local inputZ = kbForward + jsForward
    local horizontalMove = cameraRight * inputX
    local forwardMove = cameraLook * inputZ
    local finalDirection = horizontalMove + forwardMove
    if finalDirection.Magnitude > 0 then
        finalDirection = finalDirection.Unit * flySpeed
    end
    flyVelocity.Velocity = finalDirection
    local targetLook = Vector3.new(cameraLook.X, 0, cameraLook.Z)
    if targetLook.Magnitude > 0 then
        targetLook = targetLook.Unit
        local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + targetLook)
        flyGyro.CFrame = targetCFrame
    end
end)
player.CharacterAdded:Connect(function(newCharacter)
    if isFlying then
        stopFlying()
    end
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    setupSystemJoystick()
    savedOriginalPose = false
    originalMotorOffsets = {}
    poseDebugPrinted = false
    humanoid.Died:Connect(function()
        stopFlying()
    end)
end)
humanoid.Died:Connect(function()
    stopFlying()
end)
createFlyGUI()
setupSystemJoystick()
updateGUI()