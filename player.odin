package pacodin

import "core:math"
import rl "vendor:raylib"

Player :: struct {
    
    speed : f32,
    radius : f32,
    direction : rl.Vector2,
    position : rl.Vector2,
    color : rl.Color,
}

update_player :: proc(player : ^Player, cells : []Cell, grid_origin : rl.Vector2, deltaTime : f32) {

    player.direction.x = f32(int(rl.IsKeyDown(rl.KeyboardKey.RIGHT)) - int(rl.IsKeyDown(rl.KeyboardKey.LEFT)));
    player.direction.y = f32(int(rl.IsKeyDown(rl.KeyboardKey.DOWN)) - int(rl.IsKeyDown(rl.KeyboardKey.UP)));

    point_to_check := player.position.xy + player.direction.xy;

    next_x := int(point_to_check.x + CELL_SIZE.x / 2) % int(CELL_COUNT.x * CELL_SIZE.x);
    next_y := int(point_to_check.y + CELL_SIZE.y / 2) / int(CELL_COUNT.x * CELL_SIZE.x);

    current_x := int(player.position.x + CELL_SIZE.x / 2) % int(CELL_COUNT.x * CELL_SIZE.x);
    current_y := int(player.position.y + CELL_SIZE.y / 2) / int(CELL_COUNT.x * CELL_SIZE.x);
    
    next_cell_center := rl.Vector2{
        f32(next_x) + CELL_SIZE.x / 2,
        f32(next_y) + CELL_SIZE.y / 2,
    };

    current_cell_center := rl.Vector2{
        f32(current_x) + CELL_SIZE.x / 2,
        f32(current_y) + CELL_SIZE.y / 2,
    };

    player_diff_to_next := next_cell_center.xy - player.position.xy;
    player_dist_to_next := math.sqrt(player_diff_to_next.x * player_diff_to_next.x + player_diff_to_next.y * player_diff_to_next.y);

    cell_diff_to_next := next_cell_center.xy - current_cell_center.xy;
    cell_dist_to_next := math.sqrt(cell_diff_to_next.x * cell_diff_to_next.x + cell_diff_to_next.y * cell_diff_to_next.y);

    cell := player_dist_to_next < cell_dist_to_next ? cells[next_y * int(CELL_COUNT.x) + next_x] : cells[current_y * int(CELL_COUNT.x) + current_x];

    player.direction.y = cell.wall[0] && player.direction.y < 0 ? 0 : player.direction.y;
    player.direction.x = cell.wall[1] && player.direction.x > 0 ? 0 : player.direction.x;
    player.direction.y = cell.wall[2] && player.direction.y > 0 ? 0 : player.direction.y;
    player.direction.x = cell.wall[3] && player.direction.x < 0 ? 0 : player.direction.x;

    player.position.xy += player.direction.xy * player.speed * deltaTime;
}

draw_player :: proc(player : ^Player) {

    rl.DrawCircleV(player.position, player.radius, player.color);
}