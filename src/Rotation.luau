local TweenService = game:GetService("TweenService")

local Rotation = {}
Rotation.__index = Rotation

-------------------

type self = {
    target: any,
    offset: CFrameValue,
	loopThread: thread?,
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
    rate = rate or 0.1

	-- TODO: use fixedupdate
	self.loopThread = task.spawn(function()
		while true do
			self:next()
			task.wait(rate)
		end
	end)
end

function Rotation.stop(self: Rotation)
    if self.loopThread then
        task.cancel(self.loopThread)
        self.loopThread = nil
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