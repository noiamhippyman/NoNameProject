var offset = penetration_depth_circle_aabb(other.x,other.y,other.x + other.sprite_width,other.y + other.sprite_height,x,y,sprite_xoffset);

x += offset.x;
y += offset.y;