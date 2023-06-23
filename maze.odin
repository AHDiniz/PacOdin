package pacodin

import rl "vendor:raylib"

CELL_SIZE : rl.Vector2 : rl.Vector2{32.5, 33.5};
CELL_COUNT : rl.Vector2 : rl.Vector2{18, 20};

CellType :: enum {

    EMPTY = 0,
    POINT_CELL = 1,
    SUPER_CELL = 2,
    GHOST_SPAWN_CELL = 3,
    PLAYER_SPAWN_CELL = 4,
    TELEPORT = 5,
}

Cell :: struct {

    cell_type : CellType,
    wall : [4]bool, // north, east, south, west
    active : bool,
}

create_grid :: proc(types : []int) -> [dynamic]Cell {

    cells : [dynamic]Cell;

    for i := 0; i < len(types); i += 1 {

        cell_type := CellType(types[i]);

        cell := Cell{cell_type, {true, true, true, true}, true};

        x := i % int(CELL_COUNT.x);
        y := i / int(CELL_COUNT.x);

        if types[i] != 0 {

            if y > 0 && types[(y - 1) * int(CELL_COUNT.x) + x] != 0 {

                cell.wall[0] = false;
            }

            if x < int(CELL_COUNT.x) - 1 && types[y * int(CELL_COUNT.x) + x + 1] != 0 {

                cell.wall[1] = false;
            }

            if y < int(CELL_COUNT.y) - 1 && types[(y + 1) * int(CELL_COUNT.x) + x] != 0 {

                cell.wall[2] = false;
            }

            if x > 0 && types[y * int(CELL_COUNT.x) + x - 1] != 0 {

                cell.wall[3] = false;
            }

        } else {

            if y > 0 && types[(y - 1) * int(CELL_COUNT.x) + x] == 0 {

                cell.wall[0] = false;
            }

            if x < int(CELL_COUNT.x) - 1 && types[y * int(CELL_COUNT.x) + x + 1] == 0 {

                cell.wall[1] = false;
            }

            if y < int(CELL_COUNT.y) - 1 && types[(y + 1) * int(CELL_COUNT.x) + x] == 0 {

                cell.wall[2] = false;
            }

            if x > 0 && types[y * int(CELL_COUNT.x) + x - 1] == 0 {

                cell.wall[3] = false;
            }
        }

        append(&cells, cell);
    }

    return cells;
}

get_player_spawn_position :: proc(cells : []Cell, grid_origin : rl.Vector2) -> rl.Vector2 {

    position : rl.Vector2;

    for i := 0; i < len(cells); i += 1 {

        if cells[i].cell_type == CellType.PLAYER_SPAWN_CELL {

            position.x = grid_origin.x + f32(i % int(CELL_COUNT.x)) * CELL_SIZE.x + CELL_SIZE.x / 2;
            position.y = grid_origin.y + f32(i / int(CELL_COUNT.x)) * CELL_SIZE.y + CELL_SIZE.y / 2;

            return position;
        }
    }

    return position;
}

draw_cells :: proc(cells : []Cell, position : rl.Vector2) {

    for i := 0; i < len(cells); i += 1 {

        x : f32 = position.x + f32(i % int(CELL_COUNT.x)) * CELL_SIZE.x;
        y : f32 = position.y + f32(i / int(CELL_COUNT.x)) * CELL_SIZE.y;

        if cells[i].wall[0] {

            rl.DrawLineEx(rl.Vector2{x - 2, y}, rl.Vector2{x + CELL_SIZE.x + 2, y}, 5, rl.BLUE);
        }

        if cells[i].wall[1] {

            rl.DrawLineEx(rl.Vector2{x + CELL_SIZE.x, y - 2}, rl.Vector2{x + CELL_SIZE.x, y + CELL_SIZE.y + 2}, 5, rl.BLUE);
        }

        if cells[i].wall[2] {

            rl.DrawLineEx(rl.Vector2{x + CELL_SIZE.x + 2, y + CELL_SIZE.y}, rl.Vector2{x - 2, y + CELL_SIZE.y}, 5, rl.BLUE);
        }

        if cells[i].wall[3] {

            rl.DrawLineEx(rl.Vector2{x, y + CELL_SIZE.y + 2}, rl.Vector2{x, y - 2}, 5, rl.BLUE);
        }

        #partial switch cells[i].cell_type {

            case .POINT_CELL:

                if cells[i].active {

                    rl.DrawCircleV(rl.Vector2{x + CELL_SIZE.x / 2.0, y + CELL_SIZE.y / 2.0}, 4.0, rl.YELLOW);
                }

            case .SUPER_CELL:

                if cells[i].active {

                    rl.DrawCircleV(rl.Vector2{x + CELL_SIZE.x / 2.0, y + CELL_SIZE.y / 2.0}, 8.0, rl.YELLOW);
                }

            case:
        }
    }
}