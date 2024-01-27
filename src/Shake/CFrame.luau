local CFrameOperations = {
    Identity = CFrame.identity,
    PropertyName = "CFrame",
}

CFrameOperations.__index = CFrameOperations

-------------------

type self = {
    target: any,
    propertyName: string,
    currentOffset: CFrame,
    offsetApplied: CFrame,
}

export type CFrameOperations = typeof(setmetatable({} :: self, CFrameOperations))

-------------------

function CFrameOperations.new(target: Instance, propertyName: string?): CFrameOperations
    local self = {
        target = target,
        propertyName = propertyName or CFrameOperations.PropertyName,
        offsetApplied = CFrameOperations.Identity,
        currentOffset = CFrameOperations.Identity,
    }

    setmetatable(self, CFrameOperations)

    return self
end

function CFrameOperations.getOrigin(self: CFrameOperations): CFrame
    return self.target[self.propertyName] * self.offsetApplied:Inverse()
end

function CFrameOperations.next(self: CFrameOperations, offset: Vector3): CFrame
    local convertedOffset = CFrame.new(offset)

    self.currentOffset = convertedOffset

    return self:getOrigin() * convertedOffset
end

function CFrameOperations.apply(self: CFrameOperations, new: CFrame)
    self.target[self.propertyName] = new
    self.offsetApplied = self.currentOffset
end

-------------------

return CFrameOperations