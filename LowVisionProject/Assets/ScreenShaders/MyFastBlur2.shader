// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This code is related to an answer I provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/

Shader "MyFastBlur2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		_MaskTex ("Mask Texture", 2D) = "white" {}
		_MaskRadius ("Mask Radius", Range(0,1)) = 0
		[Toggle(INVERT_MASK)] _INVERT_MASK ("Mask Invert", Float) = 0
	}





	SubShader
	{
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
				half2 uv : TEXCOORD0;
				half2 uv21 : TEXCOORD1;
				half2 uv22 : TEXCOORD2;
				half2 uv23 : TEXCOORD3;
			};											//float2 screenPos : TEXCOORD1;


			v2f vert (
                float4 vertex : POSITION, // vertex position input
                float2 uv : TEXCOORD0, // texture coordinate input
				float2 uv21 : TEXCOORD1,
				float2 uv22 : TEXCOORD2,
				float2 uv23 : TEXCOORD3,
                out float4 outpos : SV_POSITION // clip space position output
				)
			{
                v2f o;
                o.uv = uv;
                o.uv21 = uv21;
                o.uv22 = uv22;
                o.uv23 = uv23;
                outpos = UnityObjectToClipPos(vertex);
                return o;
			}
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _MainTex_TexelSize; 
			float _MaskRadius;



            fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{		
				half4 screen_col = tex2D(_MainTex, i.uv);
				fixed4 color = tex2D (_MainTex, i.uv);
				float4 mask = tex2D(_MaskTex, i.uv);


				float radius = _MaskRadius/2;
				float center = 0.5; 

		        half2 dir = center - i.uv;						//vector to the middle of the screen
				half dist = sqrt(dir.x*dir.x + dir.y*dir.y);	//distance to center
        		dir = dir/dist; 		        				//normalize direction
        		         		                 		         		        
				bool inverse = true;			
				#if INVERT_MASK
					inverse = false; 
				#endif 


				if (inverse && dist <= radius) {
					color += tex2D (_MainTex, i.uv21);
					color += tex2D (_MainTex, i.uv22);
					color += tex2D (_MainTex, i.uv23);	
					color = color / 4;			 	
				}
				else if (!inverse && dist >= radius) {
					color += tex2D (_MainTex, i.uv21);
					color += tex2D (_MainTex, i.uv22);
					color += tex2D (_MainTex, i.uv23);
					color = color / 4; 
				}  
				else {
					color = mask;
				}	
				return color;

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
