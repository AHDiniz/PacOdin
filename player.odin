package pacodin

import "core:math"
import rl "vendor:raylib"

Player :: struct {
    
    is_moving : bool,
    speed : f32,
    radius : f32,
    position : rl.Vector2,
    initial_position : rl.Vector2,
    velocity : rl.Vector2,
    color : rl.Color,
}

update_player :: proc(player : ^Player, cells : []Cell, grid_origin : rl.Vector2, deltaTime : f32) {

    if !player.is_moving {

        if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {

            player.velocity.x = player.speed;
        
        } else if rl.IsKeyDown(rl.KeyboardKey.LEFT) {

            player.velocity.x = -player.speed;

        } else if rl.IsKeyDown(rl.KeyboardKey.UP) {

            player.velocity.y = -player.speed;

        } else if rl.IsKeyDown(rl.KeyboardKey.DOWN) {

            player.velocity.y = player.speed;
        }
    
        x := int((player.position.x - grid_origin.x - CELL_SIZE.x / 2) / CELL_SIZE.x);
        y := int((player.position.y - grid_origin.y - CELL_SIZE.y / 2) / CELL_SIZE.y);

        cell := cells[y * int(CELL_COUNT.x) + x];

        player.velocity.y = cell.wall[0] && player.velocity.y < 0 ? 0 : player.velocity.y;
        player.velocity.x = cell.wall[1] && player.velocity.x > 0 ? 0 : player.velocity.x;
        player.velocity.y = cell.wall[2] && player.velocity.y > 0 ? 0 : player.velocity.y;
        player.velocity.x = cell.wall[3] && player.velocity.x < 0 ? 0 : player.velocity.x;
 
        player.initial_position = player.position;
        player.is_moving = true;
    
    } else {

        player.position.xy += player.velocity.xy * deltaTime;
        diff := player.position.xy - player.initial_position.xy;
        player.is_moving = (math.sqrt(diff.x * diff.x + diff.y * diff.y) <= CELL_SIZE.x / 2);
    }
}

draw_player :: proc(player : ^Player) {

    rl.DrawCircleV(player.position, player.radius, player.color);
}