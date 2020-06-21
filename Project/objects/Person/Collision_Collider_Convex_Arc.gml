var is_aabb_cool = false;
switch (other.sprite_index) {
	case spr_collider_convex_arc_nw:
		is_aabb_cool = x < other.bbox_left or y < other.bbox_top;
		break;
	case spr_collider_convex_arc_ne:
		is_aabb_cool = x > other.bbox_right or y < other.bbox_top;
		break;
	case spr_collider_convex_arc_sw:
		is_aabb_cool = x < other.bbox_left or y > other.bbox_bottom;
		break;
	case spr_collider_convex_arc_se:
		is_aabb_cool = x > other.bbox_right or y > other.bbox_bottom;
		break;
}


if (is_aabb_cool) {
	var offset = penetration_depth_circle_aabb(other.bbox_left,other.bbox_top,other.bbox_right,other.bbox_bottom,x,y,sprite_xoffset);
	
	x += offset.x;
	y += offset.y;
} else {
	var offset = penetration_depth_circle_circle(x,y,sprite_xoffset,other.x,other.y,other.sprite_width);
	
	x += offset.x;
	y += offset.y;
}