local Sequencer = require(script.Parent.Sequencer)
local Shake = require(script.Parent.Shake)

local Shortcuts = {}

-------------------

type FlipbookMetadata = {
    [number]: {
        position: Vector2,
        size: Vector2,
    }
}

-------------------

function Shortcuts.decayShake(shake: Shake.Shake, decayTime: number): Tween
	local info = TweenInfo.new(decayTime, Enum.EasingStyle.Linear)
	local decay = shake:setPower(0, info)
	
	task.spawn(function()
		decay.Completed:Wait()
		shake:destroy()
	end)

    return decay
end

--[[
    thisll create a sequencer thatll "flip", in order, through all the frames in `metadata`

    get your spritesheet and organize them like so:

    ```lua
    return {
        [1] = {
            position = vector2.new(156, 256),
            size = vector2.new(156, 256),
        },

        [2] = {
            position = vector2.new(156, 256),
            size = vector2.new(156, 256),
        }
    }
    ```

    and so on!
]]
function Shortcuts.flipbook(display: ImageLabel, metadata: FlipbookMetadata): Sequencer.Sequencer
    local function flipPage(frameNumber: number)
        if not display.Parent then
            return
        end

		display.ImageRectOffset = metadata[frameNumber].position
		display.ImageRectSize = metadata[frameNumber].size
	end

	local queue = {}

	for frameNumber in ipairs(metadata) do
        local function callback()
            flipPage(frameNumber)
        end

		queue[frameNumber] = callback
	end

    return Sequencer.new(queue)
end

-------------------

return Shortcuts