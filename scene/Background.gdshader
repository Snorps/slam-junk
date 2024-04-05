shader_type canvas_item;

uniform vec2 Direction = vec2(1.0, 0.0);
uniform float speed = 50;

void fragment()
{
	COLOR=texture(TEXTURE, UV + (Direction + TIME * speed));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
