/// @func penetration_depth_circle_circle
/// @desc returns shortest distance out of other circle
/// cx1,cy1	center position of circle 1
/// cr1		radius of circle 1
/// cx2,cy2	center position of circle 2
/// cr2		radius of circle 2
//function penetration_depth_circle_circle(cx1,cy1,cr1,cx2,cy2,cr2) {
//	var c1pos = new Vector2(cx1,cy1);
//	var c2pos = new Vector2(cx2,cy2);
//	var diff = vec2_subtract(c1pos,c2pos);
//	var dist = vec2_length(diff);
//	var sumrad = cr1 + cr2;
	
//	if (dist > sumrad) return new Vector2(0,0);
	
//	var penetration_depth = sumrad - dist;
		
//	var dir = vec2_normalized(diff);
//	return vec2_multiply(dir,penetration_depth);
//}

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