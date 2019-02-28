#version 120

uniform vec2 mouse;
uniform vec2 resolution;
uniform float uTime;
uniform float vTime;
uniform float wTime;
uniform vec3 piMultipliers;

vec4 scaleUniform(vec4 point, float factor){

  mat4 scaleMatrix;
	scaleMatrix[0] = vec4(factor,0.,0.,0.);
	scaleMatrix[1] = vec4(0.,factor,0.,0.);
	scaleMatrix[2] = vec4(0.,0.,factor,0.);
	scaleMatrix[3] = vec4(0.,0.,0.,1.);

	return scaleMatrix * point;
}

vec4 moebiusize(float u, float v){

  vec4 mob;

  mob.x = (1 + (v*0.5) * cos(u*0.5)) * cos(u);
  mob.y = (1 + (v*0.5) * cos(u*0.5)) * sin(u);
  mob.z = (v*0.5) * sin(u*0.5);
  return mob;

}

void main(){

	//vec4 vCentered = gl_Vertex - vec4(0.5);

  //vec4 moebiusRange;
  //moebiusRange.x = gl_Vertex.x * (0.1  * 3.1415);
  //moebiusRange.y = (gl_Vertex.y * 2) - 1;  
  //vec4 mobVec = moebiusize(mod(uTime,2. * 3.1415), fract(vTime) * 2 - 1 );
  //vec4 newV = scaleUniform(mobVec, 50.);

  vec4 movingUV = vec4(fract(gl_Vertex.x + uTime), fract(gl_Vertex.y + vTime), fract(gl_Vertex.z + wTime), 1);
dfdsc
  vec3 toSphereRange = vec3(movingUV.x * (piMultipliers.x * 3.1415), movingUV.y * (piMultipliers.y * 3.1415), movingUV.z * (piMultipliers.z * 3.1415));
  vec4 spherized = vec4(1);
  spherized.x =  cos(toSphereRange.x) * sin(toSphereRange.y);
  spherized.y = sin(toSphereRange.x) * cos(toSphereRange.x);
  spherized.z = cos(toSphereRange.x);

  // CHECK THIS LINE OUT
  //spherized.y = spherized.y * 1 - distance(vec3(0), gl_Vertex.xyz);

  vec4 scaled = scaleUniform(spherized, 50.);

  //vec4 newV = gl_Vertex;
	vec4 finalPos = gl_ProjectionMatrix  * gl_ModelViewMatrix * scaled;
	gl_Position = finalPos;

	//gl_Color is the color of the Vertex (needs to be, otherWise = black) (passed onto frag)
	//gl_Color is read-only (used as a pass-through). Use gl_FrontColor instead;
	//vec2 screenAndMousePosX = (mouse + (gl_ModelViewMatrix * vertexInModelSpace).xy) * 0.01;
	
	gl_FrontColor =  gl_Color;		
}
