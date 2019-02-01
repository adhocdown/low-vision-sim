
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This code is related to an answer I provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/

Shader "Hidden/ScreenTransitionImageEffect"
{ 
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask Texture", 2D) = "white" {}
		_MaskRadius ("Mask Radius", Range(0,1)) = 0
		_MaskValue ("Mask Value", Range(0,6)) = 0.5
		_MaskSpread ("Mask Spread", Range(0,1)) = 0.5
		_MaskColor ("Mask Color", Color) = (0,0,0,1)
		[Toggle(INVERT_MASK)] INVERT_MASK ("Mask Invert", Float) = 0

		_XScale("X Scale", Float) = 1
		_YScale("Y Scale", Float) = 1
		_XTrans("X Scale", Float) = 1
		_YTrans("Y Scale", Float) = 1
	}

	SubShader
	{
		Tags { "Queue"="Overlay"}
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			#include "UnityCG.cginc"

			#pragma shader_feature INVERT_MASK
			float4 _MainTex_TexelSize; 
			float _XScale;
			float _YScale;
			float _XTrans;
			float _YTrans;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				float2 uv2	  : TEXCOORD1;

			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv     : TEXCOORD0;
				float2 uv2	  : TEXCOORD1;
			};

			v2f vert (appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); //*((_MainTex_TexelSize*0.5)/2); 
				o.uv = v.uv; 
				//o.uv2 = v.uv; 
				//o.uv2 = v.uv2 * _XScale - 1;  

				o.uv2 = float2((v.uv2.x*_XScale) - _XTrans, (v.uv2.y*_YScale) - _YTrans ); // import this factor from start
				//o.uv2 = float2((v.uv2.x* _XScale) , (v.uv2.y * _YScale) ); // import this factor from start



				#if UNITY_UV_STARTS_AT_TOP	//VERTICAL FLIP IF NECESSARY 
					if (_MainTex_TexelSize.y < 0) {
						o.uv.y = 1 - o.uv.y;
						o.uv2.y = 1 - o.uv2.y;
						}
				#endif

				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float _MaskRadius;
			float _MaskValue;
			float _MaskSpread;
			float4 _MaskColor;  

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);

				//float xFOVFactor = 110/30; 
				//float yFOVFactor = 90/30;  // input value on top will change 
				//float2 screenUV = _ScreenParams.xy/ _ScreenParams.w;
				//screenUV *= float2(1,1);
				//float4 mask = tex2D(_MaskTex, screenUV);
				float4 mask = tex2D(_MaskTex, i.uv2);


				//o.uv2 = float2((v.uv2.x*_XScale), (v.uv2.y * _YScale));
				float4 p = i.vertex;	   // true pixel value 
				//p.xy /= _ScreenParams.xy;  // allows (0-1 range) 


				// Scale 0..255 to 0..254 range.
				float alpha = mask.a * (1 - 1/255.0);			
				float radius = _MaskRadius/2;
				float center = 0.5; 


				//if (  (p.x < _ScreenParams.x*2/ xFOVFactor) && (p.y < _ScreenParams.y*2/ yFOVFactor)  ) {
				//	col.rgb = mask.rgb;
				//	//col.rgb = float4(0,1,1,1);
				//	return col; 
				//}


				//vector to the middle of the screen
		        half2 dir = center - i.uv;
		        half dist = sqrt(dir.x*dir.x + dir.y*dir.y);	//distance to center
        		dir = dir/dist;					        		//normalize direction




        		float weight = 0;
        		//if (dist <= radius) {
        			if (mask.a >= 0.01) {
        				weight = smoothstep(_MaskValue - _MaskSpread, _MaskValue, alpha);						
        				}
        			//weight = smoothstep(_MaskValue - _MaskSpread, _MaskValue, alpha);

        		//}        	




				// If the mask value is greater than the alpha value,
				// we want to draw the mask.
				//float weight = step(_MaskValue, alpha);
				//float weight = smoothstep(_MaskValue - _MaskSpread, _MaskValue, alpha);

				//weight = mask.a; //smoothstep(_MaskColor, alpha);
				weight = alpha; 

				//#if INVERT_MASK
					weight = 1 - weight;
				//#endif
				// Blend in mask color depending on the weight
				col.rgb = lerp(_MaskColor, col.rgb, weight);
				// Additionally also apply a blend between mask and scene
				//col.rgb = lerp(col.rgb, lerp(_MaskColor.rgb, col.rgb, weight), _MaskColor.a);

				return col;
			}



			ENDCG
		}
	}
}
