

// IMAGE EFFECTS are scripts, which once attached to a camera, alter its rendering output. 
// Despite being presented as standeard C# scripts, the actual computation is done using shaders.
// We can apply MATERIALS to render offscreen textures, making them ideal for postprocessing techniques.
// When shaders are used in this fashion, they are often referred to as SCREEN SHADERS

// Note: This shaders is not intended to be used for 3D models. 
// For this reason, its name starts with "HIDDEN/", which won't make it appear in the drop-down menu
// of the material inspector  
Shader "Hidden/SimpleImageEffectsShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_bwBlend ("Black & White blend", Range(0, 1)) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		Fog { Mode off } // idk about this one

		Pass
		{

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"


			uniform sampler2D _MainTex;
			uniform float _bwBlend;


			// This function does not alter the geometry, so there is NO need for a VERTEX function
			// (vert_img)  There's a standerd, "empty" vertex function
			// (v2f_img)  We also don't define any input or output structure, using the standard one provided

			float4 frag(v2f_img i) : COLOR {
				float4 c = tex2D(_MainTex, i.uv);

				// takes the color of the current pixel, sampled from _MainTex, and calculates its grayscaled version
				// The magic numbers .3, .59, and .11 represent the sensitivity of the Human eye to the RGB components 
				//		Note: You can also just average the RGB channels, but the results won't be as nice
				float lum = c.r*0.3 + c.g*.59 + c.b*0.11;
				float3 bw = float3(lum, lum, lum);

				// interpolates the original color with the new one using _bwBlend as a blending coefficient 
				float4 result = c;
				result.rgb = lerp(c.rgb, bw, _bwBlend);
				return result;
			}
			ENDCG
		}
	}

}
