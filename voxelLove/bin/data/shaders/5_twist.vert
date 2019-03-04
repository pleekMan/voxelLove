#version 120

const float PI = 3.1415926535897932384626433832795;
const float TWO_PI = PI * 2.;
const float HALF_PI = 1.57079632679489661923;
const float QUARTER_PI = 0.785398163397448309616;

uniform float time;
uniform vec3 uvwControl;
uniform vec2 mouse;
uniform vec2 resolution;

mat4 scale(vec3 factor){
  return mat4(
    vec4(factor.x,0.,0.,0.),
    vec4(0.,factor.y,0.,0.),
    vec4(0.,0.,factor.z,0.),
    vec4(0.,0.,0.,1.)
  );
}

mat4 rotateY(float angle){
	float c = cos(angle);
	float s = sin(angle);
    return mat4(
        vec4(c,0.,-s,0),
        vec4(0.,1.,0.,0.),
        vec4(s,0.,c,0.),
        vec4(0.,0.,0.,1.));
}

void main() {

	vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
	//vCentered.y = vCentered.y * 0.5 + 0.5;
	//vec2 normMouse = mouse / resolution;
	//vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
	//mouseCentered.y = 1. - mouseCentered.y;

	float offsetY = gl_Vertex.y + (time * 0.01 * uvwControl.y);
	float angleMult = uvwControl.x * 5.;
	vec4 twisted = rotateY((offsetY * angleMult) * PI) * vCentered;

	vec4 scaled = scale(vec3(50.,100.,50.) * uvwControl.z * 2.) * twisted;
	

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	gl_FrontColor = gl_Vertex; // gl_Color -> read-only
}
