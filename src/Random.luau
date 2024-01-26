local Random = {
    Generator = Random.new()
}

-------------------

function Random.CFrame(): CFrame
    return CFrame.lookAt(Vector3.zero, Random.Generator:NextUnitVector())
end

function Random.Vector(): Vector3
    return Random.Generator:NextUnitVector()
end

function Random.Color(): Color3
    return Color3.new(
        Random.Generator:NextNumber(0, 1),
        Random.Generator:NextNumber(0, 1),
        Random.Generator:NextNumber(0, 1)
    )
end

function Random.SaturatedColor(): Color3
    return Color3.new(
        Random.Generator:NextInteger(0, 1),
        Random.Generator:NextInteger(0, 1),
        Random.Generator:NextInteger(0, 1)
    )
end

-------------------

return Random