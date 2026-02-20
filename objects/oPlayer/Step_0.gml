x_speed = 0;
y_speed += .2; //gravity

if keyboard_check(ord("D")) {
	x_speed = walk_speed;
	image_xscale = -1;
} else if keyboard_check(ord("A")) {
	x_speed =-walk_speed;
	image_xscale = 1;
}

// INPUT
var move = keyboard_check(ord("D")) - keyboard_check(ord("A"));
x_speed = move * walk_speed;

if (move != 0) image_xscale = -sign(move);

// GROUND CHECK
var on_ground = place_meeting(x, y + 1, oSolid);

// GRAVITY
if (!on_ground) y_speed += 0.65;
y_speed = clamp(y_speed, -20, 12);

// JUMP
if (jump_buffer > 0 && coyote > 0)
{
	y_speed = -10;
	jump_buffer = 0;
	coyote = 0;
}


// -------- HORIZONTAL --------
if (place_meeting(x + x_speed, y, oSolid))
{
	while (!place_meeting(x + sign(x_speed), y, oSolid))
		x += sign(x_speed);
	x_speed = 0;
}
x += x_speed;


// -------- VERTICAL --------
if (place_meeting(x, y + y_speed, oSolid))
{
	while (!place_meeting(x, y + sign(y_speed), oSolid))
		y += sign(y_speed);
	y_speed = 0;
}
y += y_speed;

if (place_meeting(x, y + 1, oSolid)) {
	if (keyboard_check_pressed(vk_space)) {
		y_speed = -10;
	} else {
		y_speed = 0;
	}
}

// Sprint
if keyboard_check(vk_shift) {
	walk_speed = 2;
} else {
	walk_speed = 1;
}

// Spike Collisions
if (place_meeting(x, y, oSpikes)) {
	room_restart();
}

// Out of Bounds Handling 
if (y > room_height or x > room_width or x < 0) {
	room_restart();
}

// Door Collisions
if place_meeting(x, y, oDoorNext) and keyboard_check(vk_enter) {
	room_goto_next();
} else if place_meeting(x, y, oDoorRand) and keyboard_check(vk_enter) {
	room_goto(choose(Room1, Room2, Room3, Room4, Room5));
} else if place_meeting(x, y, oDoorRestart) and keyboard_check(vk_enter) {
	room_restart();
}

var on_ground = place_meeting(x, y + 1, oSolid);

// COYOTE TIME (walk off edge still jump)
if (on_ground)
	coyote = 6;
else
	coyote--;

// JUMP BUFFER (pressed slightly early still jumps)
if (keyboard_check_pressed(vk_space))
	jump_buffer = 6;
else
	jump_buffer--;