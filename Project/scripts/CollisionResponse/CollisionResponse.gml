/// @func penetration_depth_circle_aabb
/// @desc returns shortest distance out of aabb
/// x1,y1	top-left corner of aabb
/// x2,y2	bottom-right corner of aabb
/// cx,cy	center position of circle
/// cr		radius of circle
function penetration_depth_circle_aabb(x1,y1,x2,y2,cx,cy,cr) {
	if (!rectangle_in_circle(x1,y1,x2,y2,cx,cy,cr)) return new Vector2(0,0);

	var nearest_x = max(x1,min(cx,x2));
	var nearest_y = max(y1,min(cy,y2));

	var distance = new Vector2(
		cx - nearest_x,
		cy - nearest_y
	);

	var penetration = cr - vec2_length(distance);
	var offset = vec2_multiply(vec2_normalized(distance),penetration);
	return offset;
}

/// @func penetration_depth_circle_rectangle
/// @desc returns shortest distance out of an oriented rectangle
/// rx,ry	center position of rectangle
/// rw,rh	half-size of rectangle
/// ra		angle of rectangle
/// cx,cy	center position of circle
/// cr		radius of circle
function penetration_depth_circle_rectangle(rx,ry,rw,rh,ra,cx,cy,cr) {
	var orpos = new Vector2(rx,ry);
	var orsize = new Vector2(rw,rh);
	var orangle = ra mod 360;
	var rpos = vec2_subtract(orpos,orsize);
	var rsize = vec2_multiply(orsize,2);
	
	var cpos = new Vector2(cx,cy);
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
	
	var offset = penetration_depth_circle_aabb(rx,ry,rx2,ry2,tcpos.x,tcpos.y,cr);
	offset = vec2_rotate(offset,orangle);
	return offset;
}

/// @func penetration_depth_circle_circle
/// @desc returns shortest distance out of other circle
/// cx1,cy1	center position of circle 1
/// cr1		radius of circle 1
/// cx2,cy2	center position of circle 2
/// cr2		radius of circle 2
function penetration_depth_circle_circle(cx1,cy1,cr1,cx2,cy2,cr2) {
	var c1pos = new Vector2(cx1,cy1);
	var c2pos = new Vector2(cx2,cy2);
	var diff = vec2_subtract(c1pos,c2pos);
	var dist = vec2_length(diff);
	var sumrad = cr1 + cr2;
	
	if (dist > sumrad) return new Vector2(0,0);
	
	var penetration_depth = sumrad - dist;
		
	var dir = vec2_normalized(diff);
	return vec2_multiply(dir,penetration_depth);
}










