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

void main(){

  vec4 repeat = vec4(fract(gl_Vertex.x * 100.));
  vec4 timeEvolve = repeat + vec4(fract(time * 0.01),0.,0.,0.);
  //vec4 repeat = vec4(fract(timeEvolve * 10));
  
  vec4 tanRange = (timeEvolve * PI) - vec4(HALF_PI);

  vec4 toTanCurtain = vec4(1);
  toTanCurtain.x = gl_Vertex.x;
  toTanCurtain.y = tan(tanRange.x) + (tanRange.x * gl_Vertex.x);
  toTanCurtain.z = gl_Vertex.z * (sin(gl_Vertex.x * (time * 0.01) * 20.));

  toTanCurtain.x -= 0.5; // centering to World


  vec4 scaled = scale(vec3(300.,20.,1000.)) * toTanCurtain;

  //vec4 newV = gl_Vertex;
	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	//gl_Color is the color of the Vertex (needs to be, otherWise = black) (passed onto frag)
	//gl_Color is read-only (used as a pass-through). Use gl_FrontColor instead;
	//vec2 screenAndMousePosX = (mouse + (gl_ModelViewMatrix * vertexInModelSpace).xy) * 0.01;
	
	gl_FrontColor =  gl_Vertex;		
}
