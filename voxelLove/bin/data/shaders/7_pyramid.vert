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

void main() {

	//vec4 preOffset = gl_Vertex;
	//preOffset.y += (time * 0.005);
	//preOffset.y = fract(preOffset.y);
	vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
	//vec2 normMouse = mouse / resolution;
	//vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
	//mouseCentered.y = 1. - mouseCentered.y;

	float stairCount = 10;

	vec4 movingV = vec4(vCentered);
	//movingV.y += fract( gl_Vertex.y + (time * 0.005));// * 2 - 1; //* sign(movingV.y);
	movingV.y += sin((time * 0.01)) * 2 - 1;
	float atStep = floor(abs(movingV.y) * stairCount) / stairCount;

	vec4 final = vec4(gl_Vertex);
	//final.x *= float(movingV.x < 1.- atStep);
	final.x *= step(atStep, 1 - movingV.x);
	//final.z *= float(movingV.z < 1.- atStep);
	final.z *= step(atStep, 1 - movingV.z);

	float removeZeta0 = float(final.z > 0.01);
	float removeX0 = float(final.x > 0.01);

	vec4 scaled = scale(vec3(100.)) * final;

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	gl_FrontColor = gl_Vertex * (removeZeta0 * removeX0);// * selected; // gl_Color -> read-only
}
