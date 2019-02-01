// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// IMAGE EFFECTS CONTINUE
// Let's not use an external map/image
// Part 1: BOX BLUR
	// For each pixel we average its color with that of the adjacent 8 pixels
	// Also, let's make this multi pass to get more blur for our coding buck




Shader "MyShaders/BoxBlur" {

	Properties {
		_MainTex ("Texture", 2D) = "white" {}

	}

	SubShader {

		 // no culling or depth
		 Cull Off ZWrite Off ZTest Always

		 Pass 
		 {
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

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.uv = v.uv;  
				return o;
			}

			//////////////////////////////////////////////////////
			// "" _MainTex_TexelSize "" find this in the scope of your CG shader for an easy way of getting
			//    the actual size of a pixel. 
			// RECALL: 	When working with UVs, #s RANGE from 0 -> 1
			//			so the size of a pixel on the screen is actually going to be like: [1 / 1920 ] X  [1 / 1080] ETC.
			sampler2D _MainTex;
			float _MainTex_TexelSize;

			float4 box(sampler2D tex, float2 uv, float4 size)
			{
				float4 c = ( tex2D(tex, uv + float2(-size.x, size.y))  +  tex2D(tex, uv + float2(0, size.y)) + tex2D(tex, uv + float2(size.x, size.y))  +
						tex2D(tex, uv + float2(-size.x, 0))    +   tex2D(tex, uv + float2(0, 0))    +   tex2D(tex, uv + float2(size.x, 0))    +
						tex2D(tex, uv + float2(-size.x, -size.y))    +   tex2D(tex, uv + float2(0, -size.y))    +   tex2D(tex, uv + float2(size.x, -size.y)) );
				return c/9;
			}



			float4 frag (v2f i) : SV_Target
			{				
				float4 col = box(_MainTex, i.uv, _MainTex_TexelSize);
				return col;
			}
			//////////////////////////////////////////////////////
			ENDCG
					
		}
	} //eoSubShader
}


// THE TRICKY BIT
// RED VALUES	 	= Offsets on the x axis
// GREEN VALUES		= Offsets on the y axit

// This Distortion Map tactic is ofen used for effect like heat waves, which call for full screen visual distortion
// But it should also be animated, right? 
// We can animate with just one more line of code + ""_Time ""
// _Time accessed via "" #include "UnityCG.cginc ""
// _Time.x   ==   1/20th of the current time
// _Time.y	 ==   the current game time