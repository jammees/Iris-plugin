local Iris = require(script.Parent.Iris)

local widgetButton = plugin:CreateToolbar("iris_example"):CreateButton("__example_button", "Opens/Closes the widget", "", "Open/Close")
local myWidget = plugin:CreateDockWidgetPluginGui("__example", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 1000, 750, 1000, 750))

widgetButton.Click:Connect(function()
    myWidget.Enabled = not myWidget.Enabled

    if myWidget.Enabled then
        if not Iris.Internal._started then
            Iris = Iris.Init(myWidget)
        end

        Iris.Disabled = false
        Iris:Connect(Iris.ShowDemoWindow)
    else
        Iris.Disabled = true
        table.clear(Iris.Internal._connectedFunctions)
    end
end)
