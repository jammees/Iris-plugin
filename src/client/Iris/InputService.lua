-- Utility module which replaces UserInputService.
-- Because Iris is working in a plugin environment UserInputService wouldn't work
-- as expected, since for some reason it only registers keys if the workspace
-- is focused.
-- If Iris is not in a plugin environment that just simply use
-- UserInputService
local UserInputService = game:GetService("UserInputService")

local Types = require(script.Parent.Types)

local pressedKeys = {} :: { [number]: Enum.KeyCode }

local InputService = {}
InputService.X = 0
InputService.Y = 0
InputService.Initiated = false

InputService.InputBegan = UserInputService.InputBegan
InputService.InputEnded = UserInputService.InputEnded
InputService.InputChanged = UserInputService.InputChanged
InputService.TouchTapInWorld = UserInputService.TouchTapInWorld

function InputService.Init(internal: Types.Internal)
    -- if InputService.Initiated then
    -- return
    -- end

    InputService.Initiated = true

    local root = Instance.new("Frame")
    root.BackgroundTransparency = 1
    root.Size = UDim2.fromScale(1, 1)
    root.Name = "Detector"
    root.ZIndex = 999999999
    root.Parent = internal.parentInstance

    root.MouseMoved:Connect(function(x: number, y: number)
        InputService.X = x
        InputService.Y = y
    end)

    -- overwrite defaults
    InputService.InputBegan = root.InputBegan
    InputService.InputEnded = root.InputEnded
    InputService.MouseMoved = root.MouseMoved
    InputService.InputChanged = root.InputChanged

    InputService.TouchTapInWorld = Instance.new("BindableEvent", script).Event

    root.InputBegan:Connect(function(input: Enum.KeyCode, gameProcessed: boolean)
        if gameProcessed then
            return
        end

        table.insert(pressedKeys, input.KeyCode)
    end)

    root.InputEnded:Connect(function(input: Enum.KeyCode, gameProcessed: boolean)
        if gameProcessed then
            return
        end

        table.remove(pressedKeys, table.find(pressedKeys, input.KeyCode))
    end)
end

-- backwards compatiblity with UserInputService
function InputService:GetMouseLocation()
    if not InputService.Initiated then
        return UserInputService:GetMouseLocation()
    end

    return Vector2.new(InputService.X, InputService.Y)
end

-- backwards compatiblity with UserInputService
function InputService:IsKeyDown(key: Enum.KeyCode)
    if not InputService.Initiated then
        return UserInputService:IsKeyDown(key)
    end

    return table.find(pressedKeys, key) ~= nil
end

return InputService
