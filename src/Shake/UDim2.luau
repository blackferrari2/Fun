local UDim2Operations = {
    Identity = UDim2.fromScale(0, 0),
    PropertyName = "Position",
}

UDim2Operations.__index = UDim2Operations

-------------------

type self = {
    target: any,
    propertyName: string,
    currentOffset: UDim2,
    offsetApplied: UDim2,
}

export type UDim2Operations = typeof(setmetatable({} :: self, UDim2Operations))

-------------------

function UDim2Operations.new(target: Instance, propertyName: string?): UDim2Operations
    local self = {
        target = target,
        propertyName = propertyName or UDim2Operations.PropertyName,
        offsetApplied = UDim2Operations.Identity,
        currentOffset = UDim2Operations.Identity,
    }

    setmetatable(self, UDim2Operations)

    return self
end

function UDim2Operations.getOrigin(self: UDim2Operations): UDim2
    return self.target[self.propertyName] - self.offsetApplied
end

function UDim2Operations.next(self: UDim2Operations, offset: UDim2): UDim2
    self.currentOffset = offset
    return self:getOrigin() + offset
end

function UDim2Operations.apply(self: UDim2Operations, new: UDim2)
    self.target[self.propertyName] = new
    self.offsetApplied = self.currentOffset
end

-------------------

return UDim2Operations