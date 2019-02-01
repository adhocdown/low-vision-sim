

// The scanlines are sampled from a texture, which has been imported in the inspector
// with Wrap Mode: Repeat. This will repeat the texture over the entire screen
// Thanks to the variable _maskSize, it is possible to decide how ibig the texture will be

Shader "Hidden/CRTDiffuse"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MaskTex ("Mask texture", 2D) = "white" {}
		_maskBlend ("Mask blending", Float) = 0.5
		_maskSize ("Mask Size", Float) = 1
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
			uniform sampler2D _MaskTex;

			fixed _maskBlend;
			fixed _maskSize; 

			fixed4 frag (v2f_img i) : COLOR
			{
				fixed4 mask = tex2D(_MaskTex, i.uv * _maskSize);
				fixed4 base = tex2D(_MainTex, i.uv);
				return lerp(base, mask, _maskBlend );
			}


			ENDCG
		}
	}
}
