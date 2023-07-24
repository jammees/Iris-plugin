local PluginFramework = require(script.Parent.PluginFramework).init(plugin, "Iris-plugin Demo")
local Iris

local isInitiated = false

PluginFramework:OnInit(function()
	local widget: DockWidgetPluginGui =
		PluginFramework:Dock("Iris-plugin Demo", Enum.InitialDockState.Float, Vector2.new(1280, 720), false)
	local button: PluginToolbarButton = PluginFramework:ToolbarButton("Demo", "Open/Close the Demo widget.", "")

	button.Click:Connect(function()
		widget.Enabled = not widget.Enabled

		if widget.Enabled then
			if not isInitiated then
				isInitiated = true
				Iris = require(script.Parent.Iris).Init(widget.Container)
			end

			Iris:Connect(function()
				Iris.ShowDemoWindow()
			end)
		else
			table.clear(Iris._connectedFunctions)
		end
	end)

	widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not widget.Enabled then
			table.clear(Iris._connectedFunctions)
		end
	end)
end)

PluginFramework:OnDeInit(function()
	table.clear(Iris._connectedFunctions)
end)

plugin.Unloading:Connect(function()
	PluginFramework:Destroy()
end)

PluginFramework:Init()
