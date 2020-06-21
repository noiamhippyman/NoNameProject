#region General Functions

/// @func overlapping
function overlapping(minA,maxA,minB,maxB) {
	return minB <= maxA and minA <= maxB;
}

/// @func equivalent_lines
function equivalent_lines(a,b) {
	if (!vec2_parallel(a.get_global_angle(),b.get_global_angle())) return false;
	
	var d = vec2_subtract(a.get_global_position(),b.get_global_position());
	return vec2_parallel(d,a.get_global_angle());
}

/// @func on_one_side
function on_one_side(line,line_segment) {
	var d1 = vec2_subtract(line_segment.get_global_position(),line.get_global_position());
	var d2 = vec2_subtract(line_segment.get_end_global_position(),line.get_global_position());
	var n = vec2_rotate_90(line.get_global_angle());
	return vec2_dot_product(n,d1) * vec2_dot_product(n,d2) > 0;
}

/// @func project_segment
function project_segment(line_segment,onto) {
	var o_normalized = vec2_normalized(onto);
	
	var dp1 = vec2_dot_product(o_normalized,line_segment.get_global_position());
	var dp2 = vec2_dot_product(o_normalized,line_segment.get_end_global_position());
	var r = new Vector2(dp1,dp2);
	return vec2_sort(r);
}

/// @func overlapping_ranges
function overlapping_ranges(a,b) {
	return overlapping(a.x,a.y,b.x,b.y);
}

/// @func oriented_rectangle_edge
function oriented_rectangle_edge(oriented_rectangle,nr) {
	var a = new Vector2(oriented_rectangle.half_size.x,oriented_rectangle.half_size.y);
	var b = new Vector2(oriented_rectangle.half_size.x,oriented_rectangle.half_size.y);
	switch (nr mod 3) {
		case 0:
			a.x = -a.x
			break;
		case 1:
			b.y = -b.y;
			break;
		case 2:
			a.y = -a.y;
			b = vec2_negate(b);
			break;
		default:
			a = vec2_negate(a);
			b.x = -b.x;
			break;
	}
	
	a = vec2_rotate(a,oriented_rectangle.angle);
	a = vec2_add(a,oriented_rectangle.origin);
	b = vec2_rotate(b,oriented_rectangle.angle);
	b = vec2_add(b,oriented_rectangle.origin);
	
	return line_segment_create(oriented_rectangle.instance,a.x,a.y,b.x,b.y);
	
}

/// @func range_hull
function range_hull(a,b) {
	return new Vector2(
		a.x < b.x ? a.x : b.x,
		a.y > b.y ? a.y : b.y
	);
}

/// @func separating_axis_for_oriented_rect
function separating_axis_for_oriented_rect(line_segment,oriented_rectangle) {
	var r_edge0 = oriented_rectangle_edge(oriented_rectangle,0);
	var r_edge2 = oriented_rectangle_edge(oriented_rectangle,2);
	var n = vec2_subtract(line_segment.get_global_position(),line_segment.get_end_global_position());
	
	var axis_range = project_segment(line_segment,n);
	var r0_range = project_segment(r_edge0,n);
	var r2_range = project_segment(r_edge2,n);
	var r_project = range_hull(r0_range,r2_range);
	
	return !overlapping_ranges(axis_range,r_project);
}

/// @func clamp_on_rectangle
function clamp_on_rectangle(v,rectangle) {
	var ro = rectangle.get_global_position();
	var rs = new Vector2(rectangle.size.x,rectangle.size.y);
	var x1 = ro.x;
	var y1 = ro.y;
	var x2 = x1 + rs.x;
	var y2 = y1 + rs.y;
	return new Vector2(
		clamp(v.x,x1,x2),
		clamp(v.y,y1,y2)
	);
}

/// @func rectangle_corner
function rectangle_corner(r,nr) {
	var ro = r.get_global_position();
	var corner = new Vector2(ro.x,ro.y);
	switch (nr mod 4) {
		case 0:
			corner.x += r.size.x;
			break;
		case 1:
			corner = vec2_add(corner, r.size);
			break;
		case 2:
			corner.y += r.size.y;
			break;
		default:
			break;
	}
	return corner;
}

/// @func oriented_rectangle_corner
function oriented_rectangle_corner(r,nr) {
	var corner = new Vector2(r.half_size.x,r.half_size.y);
	switch (nr mod 4) {
		case 0:
			corner.x = -corner.x;
			break;
		case 1:
			break;
		case 2:
			corner.y = -corner.y;
			break;
		default:
			corner = vec2_negate(corner);
			break;
	}
	
	corner = vec2_rotate(corner,r.get_global_angle());
	return vec2_add(corner,r.get_global_position());
}

/// @func enlarge_rectangle_point
function enlarge_rectangle_point(rectangle,v) {
	var ro = rectangle.get_global_position();
	var rs = rectangle.size;
	var enlarged = rectangle_create(noone,
		min(ro.x,v.x),
		min(ro.y,v.y),
		max(ro.x + rs.x, v.x),
		max(ro.y + rs.y, v.y)
	);
	
	enlarged.size = vec2_subtract(enlarged.size,enlarged.get_global_position());
	return enlarged;
}

/// @func oriented_rectangle_rectangle_hull
function oriented_rectangle_rectangle_hull(oriented_rectangle) {
	var h = rectangle_create(noone,0,0,0,0);
	h.origin = oriented_rectangle.get_global_position();
	
	for (var nr = 0; nr < 4; ++nr) {
		var corner = oriented_rectangle_corner(oriented_rectangle,nr);
		h = enlarge_rectangle_point(h,corner);
	}
	
	return h;
}

/// @func separating_axis_for_rect
function separating_axis_for_rect(line_segment,rectangle) {
	var glstart = line_segment.get_global_position();
	var glend = line_segment.get_end_global_position();
	var n = vec2_subtract(glstart,glend);
	
	var redge_a = line_segment_create(noone,0,0,0,0);
	var redge_b = line_segment_create(noone,0,0,0,0);
	redge_a.origin = rectangle_corner(rectangle,0);
	redge_a.endpoint = rectangle_corner(rectangle,1);
	redge_b.origin = rectangle_corner(rectangle,2);
	redge_b.endpoint = rectangle_corner(rectangle,3);
	
	var redge_a_range = project_segment(redge_a,n);
	var redge_b_range = project_segment(redge_b,n);
	var rproject = range_hull(redge_a_range,redge_b_range);
	var axis_range = project_segment(line_segment,n);
	
	return !overlapping_ranges(axis_range,rproject);
}

#endregion

#region Collision Functions

/// @func collide_rectangles
function collide_rectangles(a,b) {
	var apos = a.get_global_position();
	var bpos = b.get_global_position();
	
	var ax1 = apos.x;
	var ay1 = apos.y;
	var ax2 = ax1 + a.size.x;
	var ay2 = ay1 + a.size.y;
	var bx1 = bpos.x;
	var by1 = bpos.y;
	var bx2 = bx1 + b.size.x;
	var by2 = by1 + b.size.y;
	
	return rectangle_in_rectangle(ax1,ay1,ax2,ay2,bx1,by1,bx2,by2);
}

/// @func collide_circles
function collide_circles(a,b) {
	var rad_sum = a.radius + b.radius;
	var dist = vec2_subtract(a.get_global_position(),b.get_global_position());
	return vec2_length(dist) <= rad_sum;
}

/// @func collide_lines
function collide_lines(a,b) {
	if (vec2_parallel(a.get_global_angle(),b.get_global_angle())) {
		return equivalent_lines(a,b);
	}
	
	return true;
}

/// @func collide_line_segments
function collide_line_segments(a,b) {
	var axis_a = line_create(noone,0,0,0,0);
	var axis_b = line_create(noone,0,0,0,0);
	
	axis_a.origin = a.get_global_position();
	axis_a.angle = vec2_subtract(a.get_end_global_position(),a.get_global_position());
	if (on_one_side(axis_a,b)) return false;
	
	axis_b.origin = b.get_global_position();
	axis_b.angle = vec2_subtract(b.get_end_global_position(),b.get_global_position());
	if (on_one_side(axis_b,a)) return false;
	
	if (vec2_parallel(axis_a.get_global_angle(),axis_b.get_global_angle())) {
		var ra = project_segment(a, axis_a.get_global_angle());
		var rb = project_segment(b, axis_a.get_global_angle());
		return overlapping_ranges(ra,rb);
	}
	
	return true;
}

/// @func collide_oriented_rectangles
function collide_oriented_rectangles(a,b) {
	var edge = oriented_rectangle_edge(a, 0);
	if (separating_axis_for_oriented_rect(edge, b)) return false;

	edge = oriented_rectangle_edge(a, 1);
	if (separating_axis_for_oriented_rect(edge, b)) return false;

	edge = oriented_rectangle_edge(b, 0);
	if (separating_axis_for_oriented_rect(edge, a)) return false;

	edge = oriented_rectangle_edge(b, 1);
	return !separating_axis_for_oriented_rect(edge, a);
}

/// @func collide_point_in_circle
function collide_point_in_circle(x,y,circle) {
	var cpos = circle.get_global_position();
	return point_in_circle(x,y,cpos.x,cpos.y,circle.radius);
}

/// @func collide_point_in_rectangle
function collide_point_in_rectangle(x,y,rectangle) {
	var rpos = rectangle.get_global_position();
	var x1 = rpos.x;
	var y1 = rpos.y;
	var x2 = x1 + rectangle.size.x;
	var y2 = y1 + rectangle.size.y;
	return point_in_rectangle(x,y,x1,y1,x2,y2);
}

/// @func collide_point_in_line
function collide_point_in_line(x,y,line) {
	var v = new Vector2(x,y);
	if (vec2_equals(line.get_global_position(), v)) return true;
	
	var lp = vec2_subtract(v, line.get_global_position());
	return vec2_parallel(lp, line.get_global_angle());
}

/// @func collide_point_in_line_segment
function collide_point_in_line_segment(x,y,line_segment) {
	var v = new Vector2(x,y);
	var d = vec2_subtract(line_segment.get_end_global_position(),line_segment.get_global_position());
	var lp = vec2_subtract(v, line_segment.get_global_position());
	var pr = vec2_project(lp,d);
	return vec2_equals(lp,pr) and
	vec2_length(pr) <= vec2_length(d) and
	0 <= vec2_dot_product(pr,d);
}

/// @func collide_point_in_oriented_rectangle
function collide_point_in_oriented_rectangle(x,y,oriented_rectangle) {
	var v = new Vector2(x,y);
	
	var lr = rectangle_create(noone,0,0,0,0);
	lr.size = vec2_multiply(oriented_rectangle.half_size, 2);
	
	var lp = vec2_subtract(v,oriented_rectangle.get_global_position());
	lp = vec2_rotate(lp, -oriented_rectangle.get_global_angle());
	lp = vec2_add(lp, oriented_rectangle.half_size);
	
	return collide_point_in_rectangle(lp.x,lp.y,lr);
}

/// @func collide_line_in_circle
function collide_line_in_circle(line,circle) {
	var lc = vec2_subtract(circle.get_global_position(), line.get_global_position());
	var p = vec2_project(lc,line.get_global_angle());
	var near = vec2_add(line.get_global_position(),p);
	return collide_point_in_circle(near.x,near.y,circle);
}

/// @func collide_line_in_rectangle
function collide_line_in_rectangle(line,rectangle) {
	var n = vec2_rotate_90(line.get_global_angle());
	var ro = rectangle.get_global_position();
	var c1 = new Vector2(ro.x,ro.y);
	var c2 = vec2_add(c1, rectangle.size);
	var c3 = new Vector2(c2.x,c1.y);
	var c4 = new Vector2(c1.x,c2.y);
	
	var lpos = line.get_global_position();
	c1 = vec2_subtract(c1, lpos);
	c2 = vec2_subtract(c2, lpos);
	c3 = vec2_subtract(c3, lpos);
	c4 = vec2_subtract(c4, lpos);
	
	var dp1 = vec2_dot_product(n, c1);
	var dp2 = vec2_dot_product(n, c2);
	var dp3 = vec2_dot_product(n, c3);
	var dp4 = vec2_dot_product(n, c4);
	
	return (dp1 * dp2 <= 0) or (dp2 * dp3 <= 0) or (dp3 * dp4 <= 0);
}

/// @func collide_line_in_line_segment
function collide_line_in_line_segment(line,line_segment) {
	return !on_one_side(line,line_segment);
}

/// @func collide_line_in_oriented_rectangle
function collide_line_in_oriented_rectangle(line,oriented_rectangle) {
	var lr = rectangle_create(noone,0,0,0,0);
	lr.size = vec2_multiply(oriented_rectangle.half_size, 2);
	var ll = line_create(noone,0,0,0,0);
	ll.origin = vec2_subtract(line.get_global_position(),oriented_rectangle.get_global_position());
	ll.origin = vec2_rotate(ll.get_global_position(),-oriented_rectangle.get_global_angle());
	ll.origin = vec2_add(ll.get_global_position(), oriented_rectangle.half_size);
	ll.angle = vec2_rotate(line.get_global_angle(),-oriented_rectangle.get_global_angle());
	return collide_line_in_rectangle(ll,lr);
}

/// @func collide_line_segment_in_circle
function collide_line_segment_in_circle(line_segment,circle) {
	var glstart = line_segment.get_global_position();
	var glend = line_segment.get_end_global_position();
	if (collide_point_in_circle(glstart.x,glstart.y,circle) or collide_point_in_circle(glend.x,glend.y,circle)) return true;
	
	var d = vec2_subtract(glend,glstart);
	var lc = vec2_subtract(circle.get_global_position(),glstart);
	var p = vec2_project(lc,d);
	var near = vec2_add(glstart,p);
	
	return	collide_point_in_circle(near.x,near.y,circle) and
			vec2_length(p) <= vec2_length(d) and
			0 <= vec2_dot_product(p,d);
}

/// @func collide_line_segment_in_rectangle
function collide_line_segment_in_rectangle(line_segment,rectangle) {
	var glstart = line_segment.get_global_position();
	var glend = line_segment.get_end_global_position();
	
	var sline = line_create(noone,0,0,0,0);
	sline.origin = glstart;
	sline.angle = vec2_subtract(glend,glstart);
	if (!collide_line_in_rectangle(sline,rectangle)) return false;
	
	var ro = rectangle.get_global_position();
	var rrange = new Vector2(ro.x,ro.x+rectangle.size.x);
	var srange = new Vector2(glstart.x,glend.x);
	srange = vec2_sort(srange);
	if (!overlapping_ranges(rrange,srange)) return false;
	
	rrange = new Vector2(ro.y,ro.y+rectangle.size.y);
	srange = new Vector2(glstart.y,glend.y);
	srange = vec2_sort(srange);
	return overlapping_ranges(rrange,srange);
}

/// @func collide_line_segment_in_oriented_rectangle
function collide_line_segment_in_oriented_rectangle(line_segment,oriented_rectangle) {
	var lr = rectangle_create(noone,0,0,0,0);
	lr.size = vec2_multiply(oriented_rectangle.half_size,2);
	
	var glstart = line_segment.get_global_position();
	var glend = line_segment.get_end_global_position();
	var grpos = oriented_rectangle.get_global_position();
	var grangle = oriented_rectangle.get_global_angle();
	var ls = line_segment_create(noone,0,0,0,0);
	ls.origin = vec2_subtract(glstart,grpos);
	ls.origin = vec2_rotate(ls.origin,-grangle);
	ls.origin = vec2_add(ls.origin,oriented_rectangle.half_size);
	
	ls.endpoint = vec2_subtract(glend,grpos);
	ls.endpoint = vec2_rotate(ls.endpoint,-grangle);
	ls.endpoint = vec2_add(ls.endpoint,oriented_rectangle.half_size);
	
	return collide_line_segment_in_rectangle(ls,lr);
}

/// @func collide_circle_in_rectangle
function collide_circle_in_rectangle(circle,rectangle) {
	var clamped = clamp_on_rectangle(circle.get_global_position(),rectangle);
	return collide_point_in_circle(clamped.x,clamped.y,circle);
}

/// @func collide_circle_in_oriented_rectangle
function collide_circle_in_oriented_rectangle(circle,oriented_rectangle) {
	var lr =  rectangle_create(noone,0,0,0,0);
	lr.size = vec2_multiply(oriented_rectangle.half_size,2);
	
	var lc = circle_create(noone,0,0,circle.radius);
	var dist = vec2_subtract(circle.get_global_position(),oriented_rectangle.get_global_position());
	dist = vec2_rotate(dist,-oriented_rectangle.get_global_angle());
	lc.origin = vec2_add(dist,oriented_rectangle.half_size);
	
	return collide_circle_in_rectangle(lc,lr);
}

/// @func collide_rectangle_in_oriented_rectangle
function collide_rectangle_in_oriented_rectangle(rectangle,oriented_rectangle) {
	var orhull = oriented_rectangle_rectangle_hull(oriented_rectangle);
	if (!collide_rectangles(orhull,rectangle)) return false;
	
	var edge = oriented_rectangle_edge(oriented_rectangle,0);
	if (separating_axis_for_rect(edge,rectangle)) return false;
	
	edge = oriented_rectangle_edge(oriented_rectangle,1);
	return !separating_axis_for_rect(edge,rectangle);
}

#endregion

#region Penetration Vector return functions

/// @func penetration_vector_circles
function penetration_vector_circles(a,b) {
	var diff = vec2_subtract(a.get_global_position(),b.get_global_position());
	var dist = vec2_length(diff);
	var sumrad = a.radius + b.radius;
	var penetration_depth = sumrad - dist;
		
	var dir = vec2_normalized(diff);
	return vec2_multiply(dir,penetration_depth);
}

/// @func penetration_vector_circle_in_rectangle
function penetration_vector_circle_in_rectangle(circle,rectangle) {
	var rpos = rectangle.get_global_position();
	var rx = rpos.x;
	var ry = rpos.y;
	var cpos = circle.get_global_position();
	var cx = cpos.x;
	var cy = cpos.y;
	var nearest_x = max(rx,min(cx,rx + rectangle.size.x));
	var nearest_y = max(ry,min(cy,ry + rectangle.size.y));
	var distance = {
		x: cx - nearest_x,
		y: cy - nearest_y
	};
	
	var penetration_depth = circle.radius - vec2_length(distance);
	return vec2_multiply(vec2_normalized(distance),penetration_depth);
}

/// @func penetration_vector_circle_in_oriented_rectangle
function penetration_vector_circle_in_oriented_rectangle(circle,oriented_rectangle) {
	// make normal rectangle in oriented_rectangle.position - oriented_rectangle.extents
	// normal rect.size = oriented_rectangle.extents * 2
	// rotate circle position relative to oriented rectangle - rotation
	// get penetration vector circle in rectangle
	// rotate penetration vector to oriented rectangles angle
	var orpos = oriented_rectangle.get_global_position();
	var orsize = oriented_rectangle.half_size;
	var orangle = oriented_rectangle.angle;
	var rpos = vec2_subtract(orpos,orsize);
	var rsize = vec2_multiply(orsize,2);
	var normal_rect = rectangle_create(noone,rpos.x,rpos.y,rsize.x,rsize.y);
	
	var cpos = circle.get_global_position();
	var dist = vec2_distance(orpos,cpos);
	var dir = vec2_direction(orpos,cpos) - orangle;
	var offset = new Vector2(
		lengthdir_x(dist,dir),
		lengthdir_y(dist,dir)
	);
	var tcpos = vec2_add(orpos,offset);
	var transposed_circle = circle_create(noone,tcpos.x,tcpos.y,circle.radius);
	
	var penetration = penetration_vector_circle_in_rectangle(transposed_circle,normal_rect);
	
	return vec2_rotate(penetration,orangle);
}

#endregion