local TweenService = game:GetService("TweenService")

local packages = script.Parent.Parent

local Signal = require(packages.Signal)
local FixedUpdate = require(packages.FixedUpdate)

local Rotation = {}
Rotation.__index = Rotation

-------------------

type self = {
    target: any,
    offset: CFrameValue,
    update: FixedUpdate.FixedUpdate?,
    updateConnection: Signal.Connection?,
}

export type Rotation = typeof(setmetatable({} :: self, Rotation))

-------------------

function Rotation.new(target: any, offset: CFrame): Rotation
	local self = {
		target = target,
		offset = Instance.new("CFrameValue"),
	}
	
	self.offset.Value = offset

	setmetatable(self, Rotation)

	return self
end

function Rotation.setOffset(self: Rotation, to: CFrame, info: TweenInfo?): Tween?
	if info then
		return TweenService:Create(self.offset, info, {Value = to})
	end

	self.offset.Value = to

	return nil
end

function Rotation.next(self: Rotation)
    local pivot = self.target:GetPivot()

    self.target:PivotTo(pivot * self.offset.Value)
end

function Rotation.loop(self: Rotation, rate: number)
    if self.update then
        return
    end

    rate = rate or 1 / 60

    local update = FixedUpdate.new(rate)

    self.update = update
    self.updateConnection = update.heartbeat:Connect(function()
        self:next()
    end)
end

function Rotation.stop(self: Rotation)
    if self.update then
        self.update:destroy()
        self.update = nil
    end

    if self.updateConnection then
        self.updateConnection:Disconnect()
        self.updateConnection = nil
    end
end

function Rotation.destroy(self: Rotation)
	self:stop()
	self.offset:Destroy()

	local setmetatable: any = setmetatable
	setmetatable(self, nil)
end

-------------------

return Rotation