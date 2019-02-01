// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'



Shader "MyShaders/Shaders101"
{

	SubShader {


		 Pass 
		 {
			//Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			//////////////////////////////////////////////////////
			//  appdata defines the infromation we are getting from each vertex on the mesh
			//  TEXCOORD0 is the first UV coordinate
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			// defines what information we're passing into the fragment function
			// providing data to vertex programs: Unity Documentation Page
			// vertex data is identified by Gc/HLSL semantics, and must be from the following list:
			// POSITION; NORMAL; TEXCOORD0; TEXCOORD1,2,3,4; TANGENT; COLOR
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				};

			// takes our appdata struct as a parameter; returns v2f
			// looks at postion of the vertex (vector3) in the mesh's local coordinate system
			// initializes a v2f var and sets its vertex variable

			// mul() performs matrix multiplication on that local vertex to take the from a point relative to the object
			// and transforms it into a point on the screen (sound familiar?)
			v2f vert (appdata v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.uv = v.uv;  //pass the UV as is to our frag function
				return o;
			}

			//////////////////////////////////////////////////////
			//sampler2D _MainTex;
			//float4 _Color;

			// FINALLY. frag takes our v2f struct and returns
			// a color in the form oa a float4 variable

			// turns potential pixesl into c  olors on the screen
			// even though our vert shader only passes along 4 unique UV values
			// get every value in between thanks to linear interpolation
			float4 frag (v2f i) : SV_Target
			{
				//fixed4 col = tex2D(_MainTex, i.uv); 				// sample the texture
				//float4 color = tex2D(_MainTex, i.uv) * _Color;
				//return color;
				return float4 (i.uv.y/2, 1-i.uv.y/2, 1, 1); // color pixels using data from the mesh
				//return float4(1, 0.6, 0, 1); // orange
			}
			//////////////////////////////////////////////////////
			ENDCG
					
		}
	} //eoSubShader
}
