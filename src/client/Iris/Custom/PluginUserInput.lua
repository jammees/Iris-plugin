-- Utility module which replaces UserInputService.
-- Because Iris is working in a plugin environment UserInputService wouldn't work
-- as expected, since for some reason it only registers keys if the workspace
-- is focused.
local pressedKeys = {} :: { [number]: Enum.KeyCode }

local PluginUserInput = {}
PluginUserInput.X = 0
PluginUserInput.Y = 0

function PluginUserInput.Init(parent: Instance)
	local root = Instance.new("Frame")
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1, 1)
	root.Name = "Detector"
	root.ZIndex = 999999999
	root.Parent = parent

	root.MouseMoved:Connect(function(x: number, y: number)
		PluginUserInput.X = x
		PluginUserInput.Y = y
	end)

	PluginUserInput.InputBegan = root.InputBegan
	PluginUserInput.InputEnded = root.InputEnded
	PluginUserInput.MouseMoved = root.MouseMoved
	PluginUserInput.InputChanged = root.InputChanged

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

function PluginUserInput.GetMouseLocation()
	return Vector2.new(PluginUserInput.X, PluginUserInput.Y)
end

function PluginUserInput.IsKeyDown(key: Enum.KeyCode)
	return table.find(pressedKeys, key) ~= nil
end

return PluginUserInput
