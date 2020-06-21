camera = view_get_camera(0);
camera_is_bound = false;

function update(dt) {
	if (instance_exists(camera_target)) {
		var cx = camera_target.x - camera_get_view_width(camera) / 2;
		var cy = camera_target.y - camera_get_view_height(camera) / 2;
		
		camera_set_view_pos(camera,cx,cy);
	}
}
function draw() {}