/// @func Vector2
function Vector2(_x,_y) constructor {
	x = _x;
	y = _y;
}

/// @func vec2_add
function vec2_add(a,b) {
	return new Vector2(a.x + b.x, a.y + b.y);
}

/// @func vec2_subtract
function vec2_subtract(a,b) {
	return new Vector2(a.x - b.x, a.y - b.y);
}

/// @func vec2_multiply
function vec2_multiply(a,b) {
	if (is_struct(b)) {
		return new Vector2(a.x * b.x, a.y * b.y);
	} else {
		return new Vector2(a.x * b, a.y * b);
	}
}

/// @func vec2_divide
function vec2_divide(a,b) {
	if (is_struct(b)) {
		return new Vector2(a.x / b.x, a.y / b.y);
	} else {
		return new Vector2(a.x / b, a.y / b);
	}
}

/// @func vec2_length
function vec2_length(v) {
	return point_distance(0,0,v.x,v.y);
}

/// @func vec2_angle
function vec2_angle(v) {
	return point_direction(0,0,v.x,v.y);
}

/// @func vec2_normalized
function vec2_normalized(v) {
	return vec2_divide(v,vec2_length(v));
}

/// @func vec2_rotate
function vec2_rotate(v,degrees) {
	var rad = degtorad(degrees)
	var sine = -sin(rad);
	var cosine = cos(rad);
	
	var vx = v.x * cosine - v.y * sine;
	var vy = v.x * sine + v.y * cosine;
	return new Vector2(vx,vy);
}

/// @func vec2_dot_product
function vec2_dot_product(a,b) {
	return dot_product(a.x,a.y,b.x,b.y);
}

/// @func vec2_project
function vec2_project(v_project,v_onto) {
	var d = vec2_dot_product(v_onto,v_onto);
	
	if (d > 0) {
		var dp = vec2_dot_product(v_project,v_onto);
		return vec2_multiply(v_onto, dp / d);
	}
	
	return v_onto;
}

/// @func vec2_enclosed_angle
function vec2_enclosed_angle(a,b) {
	var u1 = vec2_normalized(a);
	var u2 = vec2_normalized(b);
	var dp = vec2_dot_product(u1,u2);
	return radtodeg(arccos(dp));
}

/// @func vec2_equals
function vec2_equals(a,b) {
	return a.x == b.x and a.y == b.y;
}

/// @func vec2_distance
function vec2_distance(a,b) {
	return point_distance(a.x,a.y,b.x,b.y);
}

/// @func vec2_direction
function vec2_direction(a,b) {
	return point_direction(a.x,a.y,b.x,b.y);
}

/// @func vec2_rotate_90
function vec2_rotate_90(v) {
	return new Vector2(-v.y,v.x);
}

/// @func vec2_negate
function vec2_negate(v) {
	return new Vector2(-v.x,-v.y);
}

/// @func vec2_parallel
function vec2_parallel(a,b) {
	var na = vec2_rotate_90(a);
	return vec2_dot_product(na,b) == 0;
}

/// @func vec2_sort
function vec2_sort(v) {
	if (v.x > v.y) {
		return new Vector2(v.y,v.x);
	}
	
	return v;
}