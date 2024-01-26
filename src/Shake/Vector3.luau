local Vector3Operations = {
    Identity = Vector3.zero,
    PropertyName = "Position",
}

Vector3Operations.__index = Vector3Operations

-------------------

type self = {
    target: any,
    propertyName: string,
    previousStep: Vector3,
}

export type Vector3Operations = typeof(setmetatable({} :: self, Vector3Operations))

-------------------

function Vector3Operations.new(target: Instance, propertyName: string?): Vector3Operations
    local self = {
        target = target,
        propertyName = propertyName or Vector3Operations.PropertyName,
        previousStep = Vector3Operations.Identity,
    }

    setmetatable(self, Vector3Operations)

    return self
end

function Vector3Operations.getOrigin(self: Vector3Operations): Vector3
    return self.target[self.PropertyName] - self.previousStep
end

function Vector3Operations.next(self: Vector3Operations, offset: Vector3): Vector3
    return self:getOrigin() * offset
end

function Vector3Operations.apply(self: Vector3Operations, vector3: Vector3)
    self.target[self.PropertyName] = vector3
    self.previousStep = vector3
end

-------------------

return Vector3Operations