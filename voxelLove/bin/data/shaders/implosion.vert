#version 120

// WORK ON GAUSSING THE DISTANCE/THRESHOLD

const float PI = 3.1415926535897932384626433832795;
const float TWO_PI = PI * 2.;
const float HALF_PI = 1.57079632679489661923;
const float QUARTER_PI = 0.785398163397448309616;

uniform float time;
uniform vec3 uvwControl;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 scale(vec4 point, vec3 factor){

  mat4 scaleMatrix;
	scaleMatrix[0] = vec4(factor.x,0.,0.,0.);
	scaleMatrix[1] = vec4(0.,factor.y,0.,0.);
	scaleMatrix[2] = vec4(0.,0.,factor.z,0.);
	scaleMatrix[3] = vec4(0.,0.,0.,1.);

	return scaleMatrix * point;
}

// NOT USING IT
float gaussian( float c, float w, float x )
{
    //IQUILEZ usefull little functions (cubicPulse)
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

// NOT USING IT
float gain(float x, float k) 
{
    float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
    return (x<0.5)?a:1.0-a;
}

void main() {

	vec4 vCentered = (gl_Vertex * 2.) - vec4(1.);
  //vec4 vCenteredCycle = fract(vCentered * 2.);
  vec2 normMouse = mouse / resolution;
  //vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
  //mouseCentered.y = 1. - mouseCentered.y;
  float time = time * 0.005;

  float distToCorner = distance(vec3(0),vec3(1));

  vec4 positivePoint = abs(vCentered);
  //vec4 positivePoint = abs(vCenteredCycle);
  //vec4 threshold = vec4(vec3(normMouse.y),0.);
  //vec4 threshold = vec4(vec3(fract(uvwControl.x)),0.);
  vec4 threshold = vec4(vec3(fract(time) * distToCorner),0.);

  float limit = uvwControl.y;
  float distToPoint = distance(vec4(0),positivePoint);
  float distToThreshold = distance(vec4(0),threshold); // REDUNDANT

  int check = int(abs(distToThreshold - distToPoint) > limit);

  
  vec4 pushed = vCentered * check;
  
  
  vec4 scaled = scale(pushed, vec3(100.) );
  

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
  gl_Position = finalPos;

	//gl_Color is the color of the Vertex (needs to be, otherWise = black) (passed onto frag)
	//gl_Color is read-only (used as a pass-through). Use gl_FrontColor instead;
	//vec2 screenAndMousePosX = (mouse + (gl_ModelViewMatrix * vertexInModelSpace).xy) * 0.01;
	
	gl_FrontColor = gl_Vertex;		
}
