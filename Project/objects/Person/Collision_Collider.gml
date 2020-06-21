if (other.image_angle) {
	
	var orpos = new Vector2(other.x,other.y);
	var orsize = new Vector2(other.sprite_xoffset,other.sprite_yoffset);
	var orangle = other.image_angle mod 360;
	var rpos = vec2_subtract(orpos,orsize);
	var rsize = vec2_multiply(orsize,2);
	
	var cpos = new Vector2(x,y);
	var dist = vec2_distance(orpos,cpos);
	var dir = vec2_direction(orpos,cpos) - orangle;
	var coffset = new Vector2(
		lengthdir_x(dist,dir),
		lengthdir_y(dist,dir)
	);
	var tcpos = vec2_add(orpos,coffset);
	
	var rx = rpos.x;
	var ry = rpos.y;
	var rx2 = rpos.x + rsize.x;
	var ry2 = rpos.y + rsize.y;
	
	var offset = penetration_depth_circle_aabb(rx,ry,rx2,ry2,tcpos.x,tcpos.y,sprite_xoffset);
	offset = vec2_rotate(offset,orangle);
	x += offset.x;
	y += offset.y;
	
} else {
	
	var rx = other.x - other.sprite_xoffset;
	var ry = other.y - other.sprite_yoffset;
	var rx2 = other.x + other.sprite_xoffset;
	var ry2 = other.y + other.sprite_yoffset;
	
	var offset = penetration_depth_circle_aabb(rx,ry,rx2,ry2,x,y,sprite_xoffset);
	x += offset.x;
	y += offset.y;
	
}