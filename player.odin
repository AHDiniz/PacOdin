package pacodin

import rl "vendor:raylib"

Player :: struct {
    
    speed : f32,
    radius : f32,
    position : rl.Vector2,
    velocity : rl.Vector2,
    color : rl.Color,
}

draw_player :: proc(player : ^Player) {

    rl.DrawCircleV(player.position, player.radius, player.color);
}