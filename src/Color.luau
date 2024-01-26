local Color = {}

-------------------

-- credit: stravant
-- https://devforum.roblox.com/t/alpha-properties-for-color3/26992/4?u=jonichromed

function Color.lighten(color: Color3, percent: number): Color3
    return Color3.new(
        percent * color.R, 
        percent * color.G, 
        percent * color.B
    )
end

function Color.darken(color: Color3, percent: number): Color3
    return Color3.new(
        percent + (1-percent) * color.R, 
        percent + (1-percent) * color.G, 
        percent + (1-percent) * color.B
    )
end

-------------------

return Color