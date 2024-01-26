local CFrameOperations = {
    Identity = CFrame.identity,
    PropertyName = "CFrame",
}

CFrameOperations.__index = CFrameOperations

-------------------

type self = {
    target: any,
    propertyName: string,
    previousStep: CFrame,
}

export type CFrameOperations = typeof(setmetatable({} :: self, CFrameOperations))

-------------------

function CFrameOperations.new(target: Instance, propertyName: string?): CFrameOperations
    local self = {
        target = target,
        propertyName = propertyName or CFrameOperations.PropertyName,
        previousStep = CFrameOperations.Identity,
    }

    setmetatable(self, CFrameOperations)

    return self
end

function CFrameOperations.getOrigin(self: CFrameOperations): CFrame
    return self.target[self.PropertyName] * self.previousStep:Inverse()
end

function CFrameOperations.next(self: CFrameOperations, offset: Vector3): CFrame
    local new = CFrame.new(offset.X, offset.Y, offset.Z)

    self.previousStep = new

    return self:getOrigin() * new
end

function CFrameOperations.apply(self: CFrameOperations, cframe: CFrame)
    self.target[self.PropertyName] = cframe
end

-------------------

return CFrameOperations