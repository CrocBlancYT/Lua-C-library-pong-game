local physics = { g = 9.81, air_res = 0.1 }

function physics.gravity(mass)
    return physics.g * mass
end

function physics.air_resistance(k)
    return (1-physics.air_res) * k
end

function physics.spring_force(init, n) --positive push; negative pull
    return (init-n) / init
end

return physics