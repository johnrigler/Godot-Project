shader_type canvas_item;

uniform float speed = .1;

void vertex() {
	UV.x += TIME * speed;      // Called for every vertex the material is visible on.
}