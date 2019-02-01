// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This code is related to an answer I provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/

Shader "ScotomaOpaque"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		_MaskColor ("Mask Color", Color) = (0,0,0,0)
		_MaskRadius ("Mask Radius", Range(0,1)) = 0
		[Toggle(INVERT_MASK)] _INVERT_MASK ("Mask Invert", Float) = 0
	}
	SubShader
	{
		Tags { "Queue"="Overlay"}
		Cull Off ZWrite Off ZTest Always	// No culling or depth

		Pass
		{
			//#include "UnityCG.cginc"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0		//this feature only exists startign with shader model 3.0 
			#pragma shader_feature INVERT_MASK


			struct v2f {
				float2 uv     : TEXCOORD0; 				//float4 vertex : SV_POSITION;
			};											//float2 screenPos : TEXCOORD1;


			v2f vert (
                float4 vertex : POSITION, // vertex position input
                float2 uv : TEXCOORD0, // texture coordinate input
                out float4 outpos : SV_POSITION // clip space position output
				)
			{
                v2f o;
                o.uv = uv;
                outpos = UnityObjectToClipPos(vertex);
                return o;

			//#if UNITY_UV_STARTS_AT_TOP
			//	if (_MainTex_TexelSize.y < 0)
			//		o.uv.y = 1 - o.uv.y;
			//#endif
			}
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize; 
			float _MaskRadius;
			float4 _MaskColor; 



            fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{		
				half4 screen_col = tex2D(_MainTex, i.uv);
				half4 col = tex2D(_MainTex, i.uv);
				float radius = _MaskRadius/2;
				float center = 0.5; 

		        half2 dir = center - i.uv;						//vector to the middle of the screen
				half dist = sqrt(dir.x*dir.x + dir.y*dir.y);	//distance to center
        		dir = dir/dist; 		        				//normalize direction
        		         		                 		         		        
				bool inverse = true;			
				#if INVERT_MASK
					inverse = false; //weight = 1 - weight;
				#endif


				if (inverse && dist <= radius) {
					//col.rgb = _MaskColor;
					//col.rgb = clamp(col.rgb, 0, 1.0);
					discard;
					//clip(-1); // clips if negative. Why even bother rendering this? See previous if need black for blur
				}
				else if (!inverse && dist >= radius) {
					//clip(-1);
					discard;
				}				       
				return col;
			}
			ENDCG
		}
	}
}

					// PLAYING WITH LERP AND FIRE
					// Blend in mask color depending on the weight
					//col.rgb = lerp(_ScreenParams.rgb, col.rgb, weight);

					// Blend in mask color depending on the weight
					// Additionally also apply a blend between mask and scene
					//col.rgb = lerp(col.rgb, lerp(_MaskColor.rgb, col.rgb, weight), _MaskColor.a);
					//col.rgb = lerp(screen_col.rgb, lerp(_MaskColor.rgb, screen_col.rgb*weight, weight), _MaskColor.a);
					//col.rgb = lerp(screen_col.rgb, lerp(screen_col.rgb, _MaskColor.rgb, 1), _MaskColor.a);
					//col = dist*col;
					//col = dist/radius;
					//col.rgb = lerp(screen_col.rgb, col.rgb, 0.5); // interpolate linearly base in distance from center					
