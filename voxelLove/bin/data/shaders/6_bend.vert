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

mat4 rotateX(float angle){
	float c = cos(angle);
	float s = sin(angle);
    return mat4(
        vec4(1.,0.,0.,0),
        vec4(0.,c,-s,0.),
        vec4(0.,s,c,0.),
        vec4(0.,0.,0.,1.));
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

mat4 rotateZ(float angle){
	float c = cos(angle);
	float s = sin(angle);
    return mat4(
        vec4(c,-s,0.,0),
        vec4(s,c,0.,0.),
        vec4(0.,0.,1.,0.),
        vec4(0.,0.,0.,1.));
}

void main() {

	//vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
	vec4 vCentered = vec4(gl_Vertex.x - 0.5, gl_Vertex.y, gl_Vertex.z - 0.5,1.0);
	//vec2 normMouse = mouse / resolution;
	//vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
	//mouseCentered.y = 1. - mouseCentered.y;
	vCentered = scale(vec3(0.5,1.,0.5)) * vCentered;

	float swivelLimit = 0.3;
	vec4 bendPivot = vec4(0,uvwControl.y,0,1);
	vec3 axisSwivel = vec3(sin(time * 0.12) * swivelLimit, 1, cos(time * 0.06) * swivelLimit);
	//vec3 axisSwivel = vec3(uvwControl.x * swivelLimit, 1, uvwControl.z * swivelLimit);
	vec3 angle = vec3(axisSwivel) * PI;
	vec3 angleFromCenter = angle * (gl_Vertex.y);

	//float offSetted = vCentered.y + (fract((uvwControl.y * 2.)) * 2 - 1);

	vec4 final = rotateX(angleFromCenter.x) * vCentered;
	final = rotateZ(angleFromCenter.z) * (final - bendPivot);
	//final += sign(vCentered);

	final+= bendPivot;

	vec4 scaled = scale(vec3(100)) * final;
	

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	gl_FrontColor = gl_Vertex; // gl_Color -> read-only
}
