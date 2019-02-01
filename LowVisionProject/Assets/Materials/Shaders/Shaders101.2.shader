// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




// Well put: shaders are a bottomless pit 

Shader "MyShaders/Shaders101.2"
{

	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex ("Second Texture", 2D) = "white" {}
		_Tween ("Tween", Range(0, 1)) = 0
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags 
		{
			"Queue" = "Transparent"  // makes sprites render AFTER the opaque geometry in the scene
									// prevents quirk behavior when your custom shader overlaps with opaque geometry
		 	"PreviewType" = "Plane"
		 }

		 Pass 
		 {
		 	// Define Blend Mode to achieve transparency! == ALPHA BLENDING ==
		 	// take src color * src alpha + dst color * (1-srcalpha)
			Blend SrcAlpha OneMinusSrcAlpha
			// For addidtive blending 
			//Blend One One
			Cull Off // ZWrite Off ZTest Always

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
			sampler2D _MainTex;
			sampler2D _SecondTex;
			float4 _Color;
			float _Tween;

			// FINALLY. frag takes our v2f struct and returns
			// a color in the form oa a float4 variable

			// turns potential pixesl into c  olors on the screen
			// even though our vert shader only passes along 4 unique UV values
			// get every value in between thanks to linear interpolation
			float4 frag (v2f i) : SV_Target
			{				
				float4 color1 = tex2D(_MainTex, i.uv);
				float4 color2 = tex2D(_SecondTex, i.uv);

				float4 color = lerp(color1, color2, _Tween) * _Color;  // lerp strikes again (linear interp)
				//float4 color = tex2D(_MainTex, i.uv) * _Color; 

				return color;
			}
			//////////////////////////////////////////////////////
			ENDCG
					
		}
	} //eoSubShader
}


// FOR PIXEL LUMINANCE USE THIS EQUATION::
// PIXEL LUMINANCE = ( 0.3 * RED ) + ( 0.59 * GREEN ) + ( 0.11 * BLUE ) 
// 	COLOR =  FLOAT4 ( LUMINANCE, LUMINANCE, LUMINANCE, ALPHA ) 
// 	you can plug into all 3 of the r,g,b values to get a grayscale sprite
// 	and then combine the color blending code from earlier -> smoother color blending