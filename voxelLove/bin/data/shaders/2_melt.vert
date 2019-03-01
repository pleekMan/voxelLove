#version 120

const float PI = 3.1415926535897932384626433832795;
const float TWO_PI = PI * 2.;
const float HALF_PI = 1.57079632679489661923;
const float QUARTER_PI = 0.785398163397448309616;

uniform vec2 mouse;
uniform vec2 resolution;
//uniform float uTime;
//uniform float vTime;

mat4 scale(vec3 factor){
  return mat4(
    vec4(factor.x,0.,0.,0.),
    vec4(0.,factor.y,0.,0.),
    vec4(0.,0.,factor.z,0.),
    vec4(0.,0.,0.,1.)
  );
}

//IQUILEZ usefull little functions
float impulse( float k, float x, float xMult )
{
    // xMult -> 10
    // k -> 2
    x *= xMult;
    float h = k*x;
    return h*exp(1.0-h);
}

void main() {

	vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
  vCentered.y = vCentered.y * 0.5 + 0.5;
  vec2 normMouse = mouse / resolution;
  //vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
  //mouseCentered.y = 1. - mouseCentered.y;
  
  float verticalPushShape = impulse(vCentered.y, 1.1, 5.);
  
  float pushStrength = normMouse.y;
  vec4 pushVector  = vCentered - vec4(0.,vCentered.y,-0.2,1.);
  vec4 pushed = vCentered + (pushVector * verticalPushShape) * pushStrength;
  //pushed.y = clamp(pushed.y, 0 ,1);
  pushed.y = clamp(pushed.y - normMouse.y,0.,1.);

  vec4 scaled = scale(vec3(100.)) * pushed;
  
	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
  gl_Position = finalPos;
	
	gl_FrontColor = gl_Vertex; // gl_Vertex -> read-only
}
