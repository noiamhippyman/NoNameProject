move_speed = 200;

function move(xaxis,yaxis,distance) {
	var move_dir = vec2_normalized(new Vector2(xaxis,yaxis));
	var move_vector = vec2_multiply(move_dir,distance);
	x += move_vector.x;
	y += move_vector.y;
}


function update(dt) {
	var move_dir = {
		x: key_to_axis(ord("D"),ord("A")),
		y: key_to_axis(ord("S"),ord("W"))
	};
	
	if (move_dir.x != 0 or move_dir.y != 0) {
		move(move_dir.x,move_dir.y,move_speed*dt);
	}
}