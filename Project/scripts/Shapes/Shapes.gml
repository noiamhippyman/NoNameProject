/// @func Shape
function Shape(inst_id,pos_x,pos_y) constructor {
	instance = inst_id;
	origin = new Vector2(pos_x,pos_y);
	
	static get_global_position = function() {
		if (instance_exists(instance)) {
			var len = vec2_length(origin);
			var dir = point_direction(0,0,origin.x,origin.y) + instance.image_angle;
			return new Vector2(
				instance.x + lengthdir_x(len,dir),
				instance.y + lengthdir_y(len,dir)
			);
			//gpos = vec2_add(gpos,new Vector2(instance.x,instance.y));
		} else {
			return origin;
		}
	}
}

#region Circle

/// @func Circle
function Circle(inst_id,pos_x,pos_y,_radius) : Shape(inst_id,pos_x,pos_y) constructor {
	//origin = new Vector2(pos_x,pos_y);
	radius = _radius;
}

/// @func circle_create
function circle_create(inst_id,pos_x,pos_y,radius) {
	return new Circle(inst_id,pos_x,pos_y,radius);
}

/// @func circle_destroy
function circle_destroy(circle) {
	delete circle.origin;
	delete circle;
}

#endregion

#region Line

/// @func Line
function Line(inst_id,pos_x,pos_y,dir_x,dir_y) : Shape(inst_id,pos_x,pos_y) constructor {
	//origin = new Vector2(pos_x,pos_y);
	angle = new Vector2(dir_x,dir_y);
	
	static get_global_angle = function() {
		if (instance_exists(instance)) {
			var a = point_direction(0,0,angle.x,angle.y) + instance.image_angle;
			//var img_angle = new Vector2(lengthdir_x(1,instance.image_angle),lengthdir_y(1,instance.image_angle));
			return new Vector2(lengthdir_x(1,a),lengthdir_y(1,a));
			//return angle + instance.image_angle;
		} else {
			return angle;
		}
	}
}

/// @func line_create
function line_create(inst_id,pos_x,pos_y,dir_x,dir_y) {
	return new Line(inst_id,pos_x,pos_y,dir_x,dir_y);
}

/// @func line_create_from_angle
function line_create_from_angle(inst_id,pos_x,pos_y,length,angle) {
	var dir_x = lengthdir_x(length,angle);
	var dir_y = lengthdir_y(length,angle);
	return line_create(inst_id,pos_x,pos_y,dir_x,dir_y);
}

/// @func line_destroy
function line_destroy(line) {
	delete line.origin;
	delete line.angle;
	delete line;
}

#endregion

#region LineSegment

/// LineSegment
function LineSegment(inst_id,x1,y1,x2,y2) : Shape(inst_id,x1,y1) constructor {
	//origin = new Vector2(x1,y1);
	endpoint = new Vector2(x2,y2);
	
	static get_end_global_position = function() {
		if (instance_exists(instance)) {
			var len = vec2_length(endpoint);
			var dir = point_direction(0,0,endpoint.x,endpoint.y) + instance.image_angle;
			return new Vector2(
				instance.x + lengthdir_x(len,dir),
				instance.y + lengthdir_y(len,dir)
			);
		} else {
			return endpoint;
		}
	}
}

/// @func line_segment_create
function line_segment_create(inst_id,x1,y1,x2,y2) {
	return new LineSegment(inst_id,x1,y1,x2,y2);
}

/// @func line_segment_destroy
function line_segment_destroy(line_segment) {
	delete line_segment.origin;
	delete line_segment.endpoint;
	delete line_segment;
}

#endregion

#region OrientedRectangle

/// @func OrientedRectangle 
function OrientedRectangle(inst_id,pos_x,pos_y,width,height,_angle) : Shape(inst_id,pos_x,pos_y) constructor {
	//origin = new Vector2(pos_x,pos_y);
	half_size = new Vector2(width/2, height/2);
	angle = _angle;
	
	static get_global_angle = function() {
		if (instance_exists(instance)) {
			return (angle + instance.image_angle) mod 360;
		} else {
			return angle;
		}
	}
}

/// @func oriented_rectangle_create
function oriented_rectangle_create(inst_id,pos_x,pos_y,width,height,angle) {
	return new OrientedRectangle(inst_id,pos_x,pos_y,width,height,angle);
}

/// @func oriented_rectangle_destroy
function oriented_rectangle_destroy(oriented_rectangle) {
	delete oriented_rectangle.origin;
	delete oriented_rectangle.half_size;
	delete oriented_rectangle;
}

#endregion

#region Rectangle

/// @func Rectangle
function Rectangle(inst_id,pos_x,pos_y,width,height) : Shape(inst_id,pos_x,pos_y) constructor {
	//origin = new Vector2(pos_x,pos_y);
	size = new Vector2(width,height);
}

/// @func rectangle_create
function rectangle_create(inst_id,pos_x,pos_y,width,height) {
	return new Rectangle(inst_id,pos_x,pos_y,width,height);
}

/// @func rectangle_destroy
function rectangle_destroy(rectangle) {
	delete rectangle.origin;
	delete rectangle.size;
	delete rectangle;
}

#endregion

#region Debug draw functions

/// @func debug_draw_line
function debug_draw_line(line) {
	var size = max(room_width,room_height) * 2;
	var line_gangle = line.get_global_angle();
	var angle = point_direction(0,0,line_gangle.x,line_gangle.y);
	
	var lpos = line.get_global_position();
	var lx = lpos.x;
	var ly = lpos.y;
	
	var dx = lengthdir_x(size,angle);
	var dy = lengthdir_y(size,angle);
	draw_line(lx-dx,ly-dy,lx+dx,ly+dy);
}

/// @func debug_draw_line_segment
function debug_draw_line_segment(line_segment) {
	var lpos = line_segment.get_global_position();
	var lend = line_segment.get_end_global_position();
	draw_line(
		lpos.x,lpos.y,
		lend.x,lend.y
	);
}

/// @func debug_draw_circle
function debug_draw_circle(circle) {
	var cpos = circle.get_global_position();
	draw_circle(cpos.x,cpos.y,circle.radius,true);
}

/// @func debug_draw_rectangle
function debug_draw_rectangle(rectangle) {
	var rpos = rectangle.get_global_position();
	var x1 = rpos.x;
	var y1 = rpos.y;
	var x2 = x1 + rectangle.size.x;
	var y2 = y1 + rectangle.size.y;
	draw_rectangle(x1,y1,x2,y2,true);
}

/// @func debug_draw_oriented_rectangle
function debug_draw_oriented_rectangle(oriented_rectangle) {
	var x2 = oriented_rectangle.half_size.x;
	var y2 = oriented_rectangle.half_size.y;
	var x1 = -x2;
	var y1 = -y2;
	var rpos = oriented_rectangle.get_global_position();
	var ox = rpos.x;
	var oy = rpos.y;
	var oa = oriented_rectangle.get_global_angle();
	
	matrix_set(matrix_world, matrix_build(ox,oy,0,0,0,oa,1,1,1));
	draw_rectangle(x1,y1,x2,y2,true);
	matrix_set(matrix_world, matrix_build_identity());
}

#endregion