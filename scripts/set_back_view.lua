-- This script is an example of saying hello

function update()
    local current_pos = ahrs:get_location() -- fetch the current position of the vehicle
    local home = ahrs:get_home()            -- fetch the home position of the vehicle

    if current_pos and home then
        local target_yaw = math.deg(home:get_bearing(current_pos))
	target_yaw = target_yaw > 180 and target_yaw - 360 or target_yaw
        gcs:send_text(0, string.format("target_yaw: %.1f", target_yaw))
        vehicle:set_target_angle_and_climbrate(0, 0, target_yaw, 0, false,  0)
    end

    return update, 1000
end

return update()
