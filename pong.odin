package pong

import "core:fmt"

import rl "vendor:raylib"

Player :: struct {
	pos:   rl.Vector2,
	speed: f32,
}

Ball :: struct {
	pos:   rl.Vector2,
	speed: f32,
}

G :: 400
PLAYER_JUMP_SPD :: 350.0
PLAYER_HOR_SPD :: 200.0

SCREEN_H :: 800
SCREEN_W :: 450

main :: proc() {
	fmt.println("Running Pong!")
	run_game()
}

run_game :: proc() {
	screen_w: i32 = 800
	screen_h: i32 = 450

	rl.InitWindow(screen_w, screen_h, "Pong!")
	defer rl.CloseWindow()

	p1 := Player{{450, 280}, 0}
	p2 := Player{{1150, 280}, 0}

	ball := Ball{{700, 280}, 1}

	camera := rl.Camera2D{0, {f32(screen_w) / 2.0, f32(screen_h) / 2.0}, 0.0, 1}

	rl.SetTargetFPS(60)

	// Main game loop
	for (!rl.WindowShouldClose()) {
		// Handle Player Inputs and Ball Movement
		update_game(&p1, &p2, &ball)

		// Draw Scene.
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.LIGHTGRAY)
			rl.BeginMode2D(camera)
			{
				p1_rect := rl.Rectangle{p1.pos.x - 20, p1.pos.y - 40, 20, 90}
				rl.DrawRectangleRec(p1_rect, rl.RED)

				p2_rect := rl.Rectangle{p2.pos.x - 20, p2.pos.y - 40, 20, 90}
				rl.DrawRectangleRec(p2_rect, rl.BLUE)

				ball_rect := rl.Rectangle{ball.pos.x - 20, ball.pos.y - 40, 30, 30}
				rl.DrawCircle(i32(ball.pos.x - 20), i32(ball.pos.y - 20), 40, rl.GREEN) //ball_rect.x, ball_rect.y, 3, rl.GREEN)

			}
			rl.EndMode2D()

			fmt.println("Current p1 position: ", p1.pos.y, p1.pos.x)
			fmt.println("Current p2 position: ", p2.pos.y, p2.pos.x)
			fmt.println("Current ball position: ", ball.pos.y, ball.pos.x)


			rl.DrawText("Controls:", 20, 20, 10, rl.BLACK)
			rl.DrawText("- Right/Left to move", 40, 40, 10, rl.DARKGRAY)
			rl.DrawText("- Space to jump", 40, 60, 10, rl.DARKGRAY)
			rl.DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, rl.DARKGRAY)
			rl.DrawText("- C to change camera mode", 40, 100, 10, rl.DARKGRAY)
			rl.DrawText("Current camera mode:", 20, 120, 10, rl.BLACK)
		}
		rl.EndDrawing()
	}
}

update_game :: proc(p1: ^Player, p2: ^Player, ball: ^Ball) {
	screen_top: f32 = 265
	screen_bot: f32 = 625
	// Player One Controls - Colemak: 'Q' 'A'
	if rl.IsKeyDown(.Q) do p1.pos.y -= 3
	else if rl.IsKeyDown(.A) do p1.pos.y += 3

	if p1.pos.y > screen_bot do p1.pos.y = screen_bot
	if p1.pos.y < screen_top do p1.pos.y = screen_top

	// Player Two Controls - Colemak: 'Up' 'Down'
	if rl.IsKeyDown(.UP) do p2.pos.y -= 3
	else if rl.IsKeyDown(.DOWN) do p2.pos.y += 3

	if p2.pos.y > screen_bot do p2.pos.y = screen_bot
	if p2.pos.y < screen_top do p2.pos.y = screen_top

	// Ball Update
	// Collision check?
}

// update_player :: proc(player: ^Player, env_items: []EnvItem, delta: f32) {
// 	if rl.IsKeyDown(.LEFT) do player.pos.x -= PLAYER_HOR_SPD * delta
// 	if rl.IsKeyDown(.RIGHT) do player.pos.x += PLAYER_HOR_SPD * delta
// 	if rl.IsKeyDown(.SPACE) && player.canJump {
// 		player.speed = -PLAYER_JUMP_SPD
// 		player.canJump = false
// 	}
//
// 	hits_obstacle := 0
// 	for ei in env_items {
// 		p := player.pos
// 		if ei.blocking &&
// 		   ei.rect.x <= p.x &&
// 		   ei.rect.x + ei.rect.width >= p.x &&
// 		   ei.rect.y >= p.y &&
// 		   ei.rect.y <= p.y + player.speed * delta {
// 			hits_obstacle += 1
// 			player.speed = 0.0
// 			p.y = ei.rect.y
// 		}
// 	}
//
// 	if (hits_obstacle < 1) {
// 		player.pos.y += player.speed * delta
// 		player.speed += G * delta
// 		player.canJump = false
// 	} else do player.canJump = true
// }
