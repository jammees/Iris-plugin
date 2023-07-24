return function(Iris, widgets)
	local NumNonWindowChildren = 0
	Iris.WidgetConstructor("Root", {
		hasState = false,
		hasChildren = true,
		Args = {},
		Events = {},
		Generate = function()
			local Root = Instance.new("Frame")
			Root.BackgroundTransparency = 1
			Root.Size = UDim2.fromScale(1, 1)
			Root.Name = "Iris_Root"

			local PseudoWindowScreenGui = Instance.new("Frame")
			PseudoWindowScreenGui.Name = "PseudoWindowScreenGui"
			PseudoWindowScreenGui.BackgroundTransparency = 1
			PseudoWindowScreenGui.Parent = Root

			local PopupScreenGui = Instance.new("Frame")
			PopupScreenGui.Size = UDim2.fromScale(1, 1)
			PopupScreenGui.BackgroundTransparency = 1
			PopupScreenGui.Name = "PopupScreenGui"
			PopupScreenGui.ZIndex = 999999999
			PopupScreenGui.Parent = Root

			local TooltipContainer = Instance.new("Frame")
			TooltipContainer.Name = "TooltipContainer"
			TooltipContainer.AutomaticSize = Enum.AutomaticSize.XY
			TooltipContainer.Size = UDim2.fromOffset(0, 0)
			TooltipContainer.BackgroundTransparency = 1
			TooltipContainer.BorderSizePixel = 0

			widgets.UIListLayout(
				TooltipContainer,
				Enum.FillDirection.Vertical,
				UDim.new(0, Iris._config.FrameBorderSize)
			)

			TooltipContainer.Parent = PopupScreenGui

			local PseudoWindow = Instance.new("Frame")
			PseudoWindow.Name = "PseudoWindow"
			PseudoWindow.Size = UDim2.new(0, 0, 0, 0)
			PseudoWindow.Position = UDim2.fromOffset(0, 22)
			PseudoWindow.BorderSizePixel = Iris._config.WindowBorderSize
			PseudoWindow.BorderColor3 = Iris._config.BorderColor
			PseudoWindow.BackgroundTransparency = Iris._config.WindowBgTransparency
			PseudoWindow.BackgroundColor3 = Iris._config.WindowBgColor
			PseudoWindow.AutomaticSize = Enum.AutomaticSize.XY

			PseudoWindow.Selectable = false
			PseudoWindow.SelectionGroup = true
			PseudoWindow.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			PseudoWindow.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			PseudoWindow.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			PseudoWindow.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

			PseudoWindow.Visible = false
			widgets.UIPadding(PseudoWindow, Iris._config.WindowPadding)

			widgets.UIListLayout(PseudoWindow, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

			PseudoWindow.Parent = PseudoWindowScreenGui

			return Root
		end,
		Update = function(thisWidget)
			if NumNonWindowChildren > 0 then
				thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true
			end
		end,
		Discard = function(thisWidget)
			NumNonWindowChildren = 0
			thisWidget.Instance:Destroy()
		end,
		ChildAdded = function(thisWidget, childWidget)
			if childWidget.type == "Window" then
				return thisWidget.Instance
			elseif childWidget.type == "Tooltip" then
				return thisWidget.Instance.PopupScreenGui.TooltipContainer
			else
				NumNonWindowChildren += 1
				thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true

				return thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow
			end
		end,
		ChildDiscarded = function(thisWidget, childWidget)
			if childWidget.type ~= "Window" then
				NumNonWindowChildren -= 1
				if NumNonWindowChildren == 0 then
					thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = false
				end
			end
		end,
	})
end
