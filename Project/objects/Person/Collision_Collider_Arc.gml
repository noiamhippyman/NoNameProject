//var c1pos = new Vector2(x,y);
//var c2pos = new Vector2(other.x,other.y);

//var diff = vec2_subtract(c1pos,c2pos);
//var dist = vec2_length(diff);
//var diffrad = max(other.sprite_width,sprite_xoffset) - min(other.sprite_width,sprite_xoffset);

//if (dist <= diffrad) exit; 
//var penetration_depth = diffrad - dist;
		
//var dir = vec2_normalized(diff);
//var offset = vec2_multiply(dir,penetration_depth);
//print(string_replace("offset: val","val",string(offset)));

//x += offset.x;
//y += offset.y;

var is_aabb_cool = false;
switch (other.sprite_index) {
	case spr_collider_arc_nw:
		is_aabb_cool = x < other.bbox_left or y < other.bbox_top;
		break;
	case spr_collider_arc_ne:
		is_aabb_cool = x > other.bbox_right or y < other.bbox_top;
		break;
	case spr_collider_arc_sw:
		is_aabb_cool = x < other.bbox_left or y > other.bbox_bottom;
		break;
	case spr_collider_arc_se:
		is_aabb_cool = x > other.bbox_right or y > other.bbox_bottom;
		break;
}

if (is_aabb_cool) {
	var offset = penetration_depth_circle_aabb(other.bbox_left,other.bbox_top,other.bbox_right,other.bbox_bottom,x,y,sprite_xoffset);
	
	x += offset.x;
	y += offset.y;
	
	exit;
}

var c1pos = new Vector2(x,y);
var c2pos = new Vector2(other.x,other.y);

var diff = vec2_subtract(c1pos,c2pos);
var dist = vec2_length(diff);
var diffrad = max(other.sprite_width,sprite_xoffset) - min(other.sprite_width,sprite_xoffset);

if (dist <= diffrad) exit; 
var penetration_depth = diffrad - dist;
		
var dir = vec2_normalized(diff);
var offset = vec2_multiply(dir,penetration_depth);

x += offset.x;
y += offset.y;