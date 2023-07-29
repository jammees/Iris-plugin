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
				Iris:Connect(Iris.ShowDemoWindow)
			end

			Iris.Disabled = false
		else
			Iris.Disabled = true
		end
	end)

	widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not widget.Enabled then
			Iris.Disabled = true
		end
	end)
end)

PluginFramework:OnDeInit(function()
	Iris.Disabled = true
end)

plugin.Unloading:Connect(function()
	PluginFramework:Destroy()
end)

PluginFramework:Init()
