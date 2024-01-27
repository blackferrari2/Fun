local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Random = require(script.Parent.Random)

local Shake = {
	Modes = {
		CFrame = "CFrame",
		Vector3 = "Vector3",
		UDim2 = "UDim2"
	}
}

Shake.__index = Shake

-------------------

type self = {
    target: Instance,
    power: NumberValue,
    mode: Mode,
    operations: any,
	loopConnection: RBXScriptConnection?,
}

export type Mode = "CFrame" | "Vector3" | "UDim2"
export type Shake = typeof(setmetatable({} :: self, Shake))

-------------------

local ERROR_INVALID_MODE = "Mode %s is invalid."

-------------------

function Shake.new(target: Instance, power: number?, mode: Mode?, propertyName: string?): Shake
	mode = mode or Shake.Modes.Vector3

	local operations = script:FindFirstChild(mode)

	if not operations then
		error(string.format(ERROR_INVALID_MODE, mode))
	end
	
	local self = {
		target = target,
		power = Instance.new("NumberValue"),
		mode = mode,
		operations = require(operations).new(target, propertyName),
	}
	
	self.power.Value = power or 1

	setmetatable(self, Shake)

	return self
end

function Shake.setPower(self: Shake, to: number, info: TweenInfo?): Tween?
	if info then
		local tween = TweenService:Create(self.power, info, {Value = to})
		
		tween:Play()

		return tween
	end

	self.power.Value = to

	return nil
end

function Shake.next(self: Shake)
	local offset = Random.vector() * self.power.Value
	local new = self.operations:next(offset)

	self.operations:apply(new)
end

function Shake.undo(self: Shake)
	local origin = self.operations:getOrigin()

	self.operations:apply(origin)
end

function Shake.loop(self: Shake, event: RBXScriptSignal)
	-- this is in case u need RenderStepped or something (i.e camera)
	event = event or RunService.Heartbeat

	self.loopConnection = event:Connect(function()
		self:next()
	end)
end

function Shake.stop(self: Shake)
	if self.loopConnection then
		self.loopConnection:Disconnect()
		self.loopConnection = nil
		self:undo()
	end
end

function Shake.destroy(self: Shake)
	self:stop()
	self.power:Destroy()
	self.operations = nil

	local setmetatable: any = setmetatable
	setmetatable(self, nil)
end

-------------------

return Shake
