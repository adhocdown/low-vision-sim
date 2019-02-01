

// The distortion on CRT monitors is due to the curvature of the glass where th image is projected.
// To replicate this effect, we'll need an extra texture called _DisplacementTx. 
// It's red and green channels will inicate how to displace pixels on the X and Y axes, respectively.
// Since colors in an image go from 0 to , we'll rescale them from   -1 to +1.

// NOTE: the quality of the CRT distortion heavilt depends on the displacement texture which is provided
// The materials one I use is borrowed from the alan Zucconi's turotial


Shader "Hidden/Distortion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementTex ("Displacement texture", 2D) = "white" {}
		_Strength ("My range", Range(0.0, 1.0)) = 0.5
	}
	SubShader
	{
		// No culling or depth
		//Cull Off ZWrite Off ZTest Always
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _DisplacementTex;
			float _Strength;

			//uniform sampler2D _MaskTex;

			fixed4 frag (v2f_img i) : COLOR
			{
				half2 n = tex2D(_DisplacementTex, i.uv);
				half2 d = n * 2 - 1;
				i.uv += d * _Strength;
				i.uv = saturate(i.uv);

				float4 c = tex2D(_MainTex, i.uv);
				return c;
			}


			ENDCG
		}
	}
}
