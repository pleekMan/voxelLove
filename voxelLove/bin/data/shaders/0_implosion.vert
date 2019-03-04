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

	vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
  vec2 normMouse = mouse / resolution;
  //vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
  //mouseCentered.y = 1. - mouseCentered.y;
  float time = time * 0.005;

  float distToCorner = distance(vec3(0),vec3(1));

  vec4 positivePoint = abs(vCentered);
  vec4 threshold = vec4(vec3(fract(time) * distToCorner),0.);

  float limit = uvwControl.y;
  float distToPoint = distance(vec4(0),positivePoint);
  float distToThreshold = distance(vec4(0),threshold); // REDUNDANT

  int check = int(abs(distToThreshold - distToPoint) > limit);

  vec4 pushed = vCentered * check;
  
  vec4 scaled = scale(vec3(100.)) * pushed;
  
	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
  gl_Position = finalPos;
	
	gl_FrontColor = gl_Vertex; // gl_Color -> read-only
}
