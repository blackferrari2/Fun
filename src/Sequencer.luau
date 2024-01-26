local Sequencer = {}
Sequencer.__index = Sequencer

-------------------

type Queue = {() -> ()}

type self = {
    queue: Queue,
    position: number,
	loopThread: thread?,
}

export type Sequencer = typeof(setmetatable({} :: self, Sequencer))

-------------------

function Sequencer.new(queue: Queue): Sequencer
	local self = {
        queue = queue,
        position = 1,
	}

	setmetatable(self, Sequencer)

	return self
end

function Sequencer.next(self: Sequencer)
    if self.position > #self.queue then
        self.position = 1
    end

    local callback = self.queue[self.position]

    callback()

    self.position += 1
end

function Sequencer.loop(self: Sequencer, rate: number)
    rate = rate or 0.1

	-- TODO: use fixedupdate
	self.loopThread = task.spawn(function()
		while true do
			self:next()
			task.wait(rate)
		end
	end)
end

function Sequencer.stop(self: Sequencer)
    if self.loopThread then
        task.cancel(self.loopThread)
        self.loopThread = nil
    end
end

function Sequencer.destroy(self: Sequencer)
	self:stop()
	self.offset:Destroy()

	local setmetatable: any = setmetatable
	setmetatable(self, nil)
end

-------------------

return Sequencer