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

vec4 moebiusize(float u, float v){

  vec4 mob;

  mob.x = (1 + (v*0.5) * cos(u*0.5)) * cos(u);
  mob.y = (1 + (v*0.5) * cos(u*0.5)) * sin(u);
  mob.z = (v*0.5) * sin(u*0.5);
  return mob;

}

void main(){
  // USE GL_LINES (as cpu app directive) FOR BETTER RENDERING


  vec4 movingUV = vec4(fract(gl_Vertex.x + time * 0.001), fract(gl_Vertex.y + uvwControl.y), fract(gl_Vertex.z + uvwControl.z), 1);
  //vec3 toSphereRange = vec3(movingUV.x * (TWO_PI), movingUV.y * (TWO_PI * time * 0.002), movingUV.z * TWO_PI);
  vec3 toSphereRange = vec3(movingUV.x * (TWO_PI * time * 0.01), movingUV.y * (TWO_PI * time * 0.001), movingUV.z * TWO_PI);
  vec4 spherized = vec4(1);
  spherized.x =  cos(toSphereRange.x) * tan(toSphereRange.y);
  spherized.y = tan(toSphereRange.y) * cos(toSphereRange.y);
  spherized.z = cos(toSphereRange.x);

  //spherized.y = spherized.y * 1 - distance(vec3(0), gl_Vertex.xyz);

  spherized = rotateY(time * 0.0085) * spherized;

  vec4 scaled = scale(vec3(100)) * spherized;

	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	gl_FrontColor =  gl_Vertex;		
}
