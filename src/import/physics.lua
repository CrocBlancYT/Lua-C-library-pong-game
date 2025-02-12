local physics = { g = 9.81, air_res = 0.2 }

function physics.gravity(vel, mass, deltaTime)
    if not mass then mass = 1 end
    local force = physics.g * mass

    return vel:sub({ x=0, y=force*deltaTime })
end

function physics.air_resistance(vel, deltaTime)
    local delta_air_res = physics.air_res * deltaTime
    local force_loss_k = (1-delta_air_res)
    
    return vel:mul(force_loss_k)
end

function physics.spring_force(init, n) --positive = push; negative = pull
    return (init-n) / init
end

return physics