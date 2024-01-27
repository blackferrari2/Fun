local Random = {
    Generator = Random.new()
}

-------------------

function Random.cframe(): CFrame
    return CFrame.lookAt(Vector3.zero, Random.Generator:NextUnitVector())
end

function Random.vector(): Vector3
    return Random.Generator:NextUnitVector()
end

function Random.color(): Color3
    return Color3.new(
        Random.Generator:NextNumber(0, 1),
        Random.Generator:NextNumber(0, 1),
        Random.Generator:NextNumber(0, 1)
    )
end

function Random.saturedColor(): Color3
    return Color3.new(
        Random.Generator:NextInteger(0, 1),
        Random.Generator:NextInteger(0, 1),
        Random.Generator:NextInteger(0, 1)
    )
end

function Random.pick(from: {any}): any?
    if #from < 1 then
        return nil
    end

    local index = Random.Generator:NextInteger(1, #from)

    return from[index]
end

-------------------

return Random