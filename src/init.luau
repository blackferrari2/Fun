local Shake = require(script.Shake)
local Color = require(script.Color)
local Random = require(script.Random)
local Rotation = require(script.Rotation)
local Sequencer = require(script.Sequencer)
local Shortcuts = require(script.Shortcuts)

--------------------

export type Shake = Shake.Shake
export type ShakeMode = Shake.Mode
export type Rotation = Rotation.Rotation
export type Sequencer = Sequencer.Sequencer

--------------------

return {
    Shake = Shake,
    Color = Color,
    Shortcuts = Shortcuts,
    Sequencer = Sequencer,
    Rotation = Rotation,
    Random = Random,
}