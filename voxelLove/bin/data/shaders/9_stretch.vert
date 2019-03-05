#version 120

const float PI = 3.1415926535897932384626433832795;
const float TWO_PI = PI * 2.;
const float HALF_PI = 1.57079632679489661923;
const float QUARTER_PI = 0.785398163397448309616;

uniform float time;
uniform vec3 control;
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

// IQUILEZ sync CURVE
float bounce( float x, float k )
{
    float a = PI * (k*x-1.0);
    return sin(a)/a;
}

void main() {

	//vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
	vec4 vCentered = gl_Vertex + vec4(-0.5,0,-0.5,0); // CENTER HORIZONTALLY
	//vec2 normMouse = mouse / resolution;
	//vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
	//mouseCentered.y = 1. - mouseCentered.y;

	//float flexFactor = 1. + control.x;
	float flexFactor = 1. + bounce((time * 0.01), 3.);
	//flexFactor *= 0.9;
	float verticalPush = vCentered.y * flexFactor;
	float normPosY = verticalPush / flexFactor;

	float horizontalPush = sin(normPosY * PI);
	vec4 pushVector = (vCentered - vec4(0,vCentered.y,0,1)) * horizontalPush;
	vec4 final = vCentered;
	final.y = verticalPush;
	final.xz = vCentered.xz - (pushVector.xz * (flexFactor - 1.));

	vec4 scaled = scale(vec3(100.)) * final;
	

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	gl_FrontColor = gl_Vertex; // gl_Color -> read-only
}
