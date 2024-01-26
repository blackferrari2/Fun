local packages = script.Parent.Parent

local Signal = require(packages.Signal)
local FixedUpdate = require(packages.FixedUpdate)

local Sequencer = {}
Sequencer.__index = Sequencer

-------------------

type Queue = {() -> ()}

type self = {
    queue: Queue,
    position: number,
    completed: Signal.Signal<nil>,
    update: FixedUpdate.FixedUpdate?,
    updateConnection: Signal.Connection?,
}

export type Sequencer = typeof(setmetatable({} :: self, Sequencer))

-------------------

function Sequencer.new(queue: Queue): Sequencer
	local self = {
        queue = queue,
        position = 1,
		completed = Signal.new(),
	}

	setmetatable(self, Sequencer)

	return self
end

function Sequencer.next(self: Sequencer)
    local callback = self.queue[self.position]

    callback()

    self.position += 1

	if self.position > #self.queue then
        self.position = 1
		self.completed:Fire()
    end
end

function Sequencer.loop(self: Sequencer, rate: number)
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

function Sequencer.stop(self: Sequencer)
    if self.update then
        self.update:destroy()
        self.update = nil
    end

    if self.updateConnection then
        self.updateConnection:Disconnect()
        self.updateConnection = nil
    end
end

function Sequencer.destroy(self: Sequencer)
	self:stop()
	self.offset:Destroy()
    self.completed:Destroy()

	local setmetatable: any = setmetatable
	setmetatable(self, nil)
end

-------------------

return Sequencer