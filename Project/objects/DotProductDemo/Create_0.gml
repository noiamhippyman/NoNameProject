a = new Vector2(100,0);
b = new Vector2(-100,0);
c = new Vector2(0,100);

function update(dt) {
	c = vec2_rotate(c,100 * dt);
}

function draw() {

	matrix_set(matrix_world,matrix_build(room_width/2,room_height/2,0,0,0,0,1,1,1));
	draw_line(0,0,a.x,a.y);
	draw_line(0,0,b.x,b.y);
	draw_line(0,0,c.x,c.y);
	matrix_set(matrix_world,matrix_build_identity());
	
	draw_text(1,1,string_replace("Dot product: dot","dot",vec2_dot_product(a,c)))
	
}