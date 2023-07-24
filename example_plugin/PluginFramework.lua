type ID = string

type PluginFramework = {
	_Plugin: Plugin,
	_DockIDs: { [ID]: DockWidgetPluginGui },
	_ToolbarButtonIDs: { [ID]: PluginToolbarButton },
	_OnInitCallbacks: { () -> () },
	_OnDeInitCallbacks: { () -> () },
	_Toolbar: PluginToolbar,

	init: (plugin: Plugin, toolbarName: string) -> PluginFramework,

	Dock: (
		self: PluginFramework,
		title: string,
		state: Enum.InitialDockState,
		size: Vector2,
		isEnabled: boolean
	) -> DockWidgetPluginGui,

	ToolbarButton: (self: PluginFramework, name: string, toolip: string, iconID: string) -> PluginToolbarButton,
	OnInit: (self: PluginFramework, callback: () -> ()) -> (),
	OnDeInit: (self: PluginFramework, callback: () -> ()) -> (),
	Init: (self: PluginFramework) -> (),
	DeInit: (self: PluginFramework) -> (),
	Destroy: (self: PluginFramework) -> (),
}

local HTTPService = game:GetService("HttpService")

local PluginFramework = {}
PluginFramework.__index = PluginFramework

function PluginFramework.init(plugin: Plugin, toolbarName: string)
	return setmetatable({
		_Plugin = plugin :: Plugin,
		_DockIDs = {} :: { [ID]: DockWidgetPluginGui },
		_ToolbarButtonIDs = {} :: { [ID]: PluginToolbarButton },
		_OnInitCallbacks = {} :: { () -> () },
		_OnDeInitCallbacks = {} :: { () -> () },
		_Toolbar = plugin:CreateToolbar(toolbarName) :: PluginToolbar,
	}, PluginFramework)
end

function PluginFramework.Dock(
	self: PluginFramework,
	title: string,
	state: Enum.InitialDockState,
	size: Vector2,
	isEnabled: boolean?
): DockWidgetPluginGui
	local dockID = HTTPService:GenerateGUID(false)

	local dock: DockWidgetPluginGui = self._Plugin:CreateDockWidgetPluginGui(
		dockID,
		DockWidgetPluginGuiInfo.new(state, false, true, size.X, size.Y, size.X, size.Y)
	)
	dock.Enabled = isEnabled or false
	dock.Title = title
	dock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	dock.Name = title
	self._DockIDs[dockID] = dock

	local container = Instance.new("Frame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.Name = "Container"
	container.Parent = dock

	return dock
end

function PluginFramework.ToolbarButton(
	self: PluginFramework,
	name: string,
	toolip: string,
	iconID: string
): PluginToolbarButton
	local button = self._Toolbar:CreateButton(name, toolip, iconID)

	self._ToolbarButtonIDs[name] = button

	return button
end

function PluginFramework.OnInit(self: PluginFramework, callback: () -> ())
	table.insert(self._OnInitCallbacks, callback)
end

function PluginFramework.OnDeInit(self: PluginFramework, callback: () -> ())
	table.insert(self._OnDeInitCallbacks, callback)
end

function PluginFramework.Init(self: PluginFramework)
	for _, callback in self._OnInitCallbacks do
		callback()
	end
end

function PluginFramework.DeInit(self: PluginFramework)
	for _, callback in self._OnDeInitCallbacks do
		callback()
	end
end

function PluginFramework.Destroy(self: PluginFramework)
	self:DeInit()
	table.clear(self._OnInitCallbacks)
	table.clear(self._OnDeInitCallbacks)

	for ID, widget in self._DockIDs do
		widget:Destroy()
		self._DockIDs[ID] = nil
	end

	for ID, button in self._ToolbarButtonIDs do
		button:Destroy()
		self._ToolbarButtonIDs[ID] = nil
	end

	self._Toolbar:Destroy()
end

return PluginFramework
