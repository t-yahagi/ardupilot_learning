-- This script is an example of saying hello
local dist_tolerance = 5

local copter_land_mode_num = 9
local copter_guided_mode_num = 4

local target_pitch = 15.0

function update()
    
    local current_pos = ahrs:get_location() -- fetch the current position of the vehicle
    local home = ahrs:get_home()            -- fetch the home position of the vehicle
    if not arming:is_armed() then -- reset state when disarmed
        target_pitch = 15
    end

    if current_pos and home then
        local mode = vehicle:get_mode()
        if not (mode == copter_guided_mode_num) then
            target_pitch = 15
            -- gcs:send_text(0, string.format("mode: %d", mode))
            return update, 1000
        end

        local target_yaw = math.deg(home:get_bearing(current_pos))
        target_yaw = target_yaw > 180 and target_yaw - 360 or target_yaw

        local dist_to_home = current_pos:get_distance(home)
        target_pitch = dist_to_home > 50 and target_pitch or target_pitch * dist_to_home / 50
        target_pitch = target_pitch < 2 and 2 or target_pitch
        target_pitch = dist_to_home < 10 and 1 or target_pitch
        if dist_to_home < dist_tolerance then
            vehicle:set_mode(copter_land_mode_num)
        end

        local current_yaw = math.deg(ahrs:get_yaw())
        gcs:send_text(0, string.format("dist: %1.f, pitch: %1.f, target_yaw: %.1f, current_yaw: %.1f",dist_to_home, target_pitch, target_yaw, current_yaw))
        vehicle:set_target_angle_and_climbrate(0, target_pitch, target_yaw, 0, false,  0)
    end

    return update, 200
end

return update()
