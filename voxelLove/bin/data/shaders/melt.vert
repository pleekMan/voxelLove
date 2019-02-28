#version 120

// WORK ON GAUSSING THE DISTANCE/THRESHOLD

const float PI = 3.1415926535897932384626433832795;
const float TWO_PI = PI * 2.;
const float HALF_PI = 1.57079632679489661923;
const float QUARTER_PI = 0.785398163397448309616;

uniform vec2 mouse;
uniform vec2 resolution;
//uniform float uTime;
//uniform float vTime;

vec4 scale(vec4 point, vec3 factor){

  mat4 scaleMatrix;
	scaleMatrix[0] = vec4(factor.x,0.,0.,0.);
	scaleMatrix[1] = vec4(0.,factor.y,0.,0.);
	scaleMatrix[2] = vec4(0.,0.,factor.z,0.);
	scaleMatrix[3] = vec4(0.,0.,0.,1.);

	return scaleMatrix * point;
}

//IQUILEZ usefull little functions
// NOT USING IT
float gaussian( float c, float w, float x )
{
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

float parabola( float x, float k )
{
    return pow( 4.0*x*(1.0-x), k );
}

float expStep( float x, float k, float n )
{
    return exp( -k*pow(x,n) );
}

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
  //vec4 vCenteredCycle = fract(vCentered * 2.);
  vec2 normMouse = mouse / resolution;
  //vec2 mouseCentered = (normMouse * 2.) - vec2(1.);
  //mouseCentered.y = 1. - mouseCentered.y;
  
  //float fallShape = vCentered.y - (normMouse.y * 0.5);
  float verticalPushShape = impulse(vCentered.y, 1.1, 5.);
  
  float pushStrength = normMouse.y;
  vec4 pushVector  = vCentered - vec4(0.,vCentered.y,-0.2,1.);
  vec4 pushed = vCentered + (pushVector * verticalPushShape) * pushStrength;
  //pushed.y = clamp(pushed.y, 0 ,1);
  pushed.y = clamp(pushed.y - normMouse.y,0.,1.);

  vec4 scaled = scale(pushed, vec3(100.) );
  

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
  gl_Position = finalPos;

	//gl_Color is the color of the Vertex (needs to be, otherWise = black) (passed onto frag)
	//gl_Color is read-only (used as a pass-through). Use gl_FrontColor instead;
	//vec2 screenAndMousePosX = (mouse + (gl_ModelViewMatrix * vertexInModelSpace).xy) * 0.01;
	
	gl_FrontColor = gl_Vertex;		
}
