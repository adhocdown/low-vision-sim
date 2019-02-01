// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'



// SHADING IN THE WORLD SPACE
// Let's change the fragment color depending on an object's position in the world
// Important Applications: shading with lights, environment maps

// STEP ONE: 	TRANSFORMING FROM OBJECT TO WORLD SPACE
//		(local object space -> universal world space)
// The TRANSFORMATION from OBJ -> WRLD SPACE is put into a 4x4 matrix
// = the MODEL MATRIX  or the MODEL TRANSFORMATION 
// param in CG 		  = 	_Object2World 
// definition (do not use)= 	uniform float4x4 _Object2World;
// Unity sets the values of the uniform parameters, so we won't worry about it. 
// The shader transforms the vertex position to world space and gives it to the fragment shader in the output structure. 
// In this project, the fragment shader will interpolate position in relation to the origin of the world coordinate system 
// between one of two colors set. 

Shader "Cg shading in world space" {
   Properties {
      _Point ("a point in world space", Vector) = (0., 0., 0., 1.0)
      _DistanceNear ("threshold distance", Float) = 30.0
      _ColorNear ("color near to point", Color) = (0.0, 1.0, 0.0, 1.0)
      _ColorFar ("color far from point", Color) = (0.3, 0.3, 0.3, 1.0)
   }
   
   SubShader {
      Pass {
         CGPROGRAM

         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc" 
            // defines _Object2World and _World2Object

         // uniforms corresponding to properties
         uniform float4 _Point;
         uniform float _DistanceNear;
         uniform float4 _ColorNear;
         uniform float4 _ColorFar;

         struct vertexInput {
            float4 vertex : POSITION;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 position_in_world_space : TEXCOORD0;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output; 
 
            output.pos =  UnityObjectToClipPos(input.vertex);
            output.position_in_world_space = 
               mul(unity_ObjectToWorld, input.vertex);
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR 
         {
             float dist = distance(input.position_in_world_space, 
               _Point);
               // computes the distance between the fragment position 
               // and the position _Point.
            
            if (dist < _DistanceNear)
            {
               return _ColorNear; 
            }
            else
            {
               return _ColorFar; 
            }
         }
 
         ENDCG  
      }
   }
}