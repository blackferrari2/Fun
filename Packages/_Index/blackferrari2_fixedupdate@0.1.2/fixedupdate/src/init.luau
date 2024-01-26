--[[
    BY gizzygazzy360 (Smile4)
    ADAPTED BY Jonichromed (blackferrari2)

    https://devforum.roblox.com/t/identical-method-to-unitys-fixedupdate/2153749/3
    https://create.roblox.com/store/asset/16032534077/Smile4s-FixedUpdate%3Fkeyword=&pageNumber=&pagePosition=
]]

local RunService = game:GetService("RunService")

local packages = script.Parent

local Signal = require(packages.Signal)

local FixedUpdate = {}
FixedUpdate.__index = FixedUpdate

------------------

type self = {
    rate: number,
    heartbeat: Signal.Signal<nil>,
    thread: thread?,
}

export type FixedUpdate = typeof(setmetatable({} :: self, FixedUpdate))

------------------

function FixedUpdate.new(rate: number?): FixedUpdate
	local self = {
        rate = rate or 1 / 60,
        heartbeat = Signal.new()
	}

	setmetatable(self, FixedUpdate)

	return self
end

function FixedUpdate.start(self: FixedUpdate)
    if self.thread then
        return
    end

    self.thread = task.spawn(function()
		local accumulator = 0
		local deltaTime = 0
		
		self.heartbeat:Fire()

		while true do
			accumulator += deltaTime

			while accumulator >= self.rate do
                self.heartbeat:Fire()
				accumulator -= self.rate
			end

			deltaTime = RunService.Heartbeat:Wait()
		end
    end)
end

function FixedUpdate.stop(self: FixedUpdate)
    if self.thread then
        task.cancel(self.thread)
        self.thread = nil
    end
end

function FixedUpdate.destroy(self: FixedUpdate)
    self:stop()
    self.heartbeat:Destroy()

    local setmetatable: any = setmetatable
    setmetatable(self, nil)
end

------------------

return FixedUpdate