// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This code is related to an answer I provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/

Shader "MyFastBlur3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		_MaskTex ("Mask Texture", 2D) = "white" {}
		_MaskRadius ("Mask Radius", Range(0,1)) = 0
		[Toggle(INVERT_MASK)] _INVERT_MASK ("Mask Invert", Float) = 0
	}

	CGINCLUDE 

		sampler2D _MainTex;
		sampler2D _MaskTex;
		float4 _MainTex_TexelSize; 
		float _MaskRadius;

		uniform half4 _Parameter; //delete? 


		struct v2f {
			half2 uv : TEXCOORD0;
			half2 uv21 : TEXCOORD1;
			half2 uv22 : TEXCOORD2;
			half2 uv23 : TEXCOORD3;
		};											


		v2f vert (
            float4 vertex : POSITION, // vertex position input THIS IS A MESS. CLEAN IT UP
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

			
			float buffer = radius/3;  // temp 
			fixed4 debug_color = float4 (0,1,0,0); 

			// BLUR OUTER
			if (inverse) {
				float weight = abs(dist - buffer);
				if (dist <= radius) 
					color = mask;									
				//else if (dist > radius && weight <= radius) {
					//color += tex2D (_MainTex, i.uv21);
					//color += tex2D (_MainTex, i.uv22);
					//color += tex2D (_MainTex, i.uv23);	
					//color = color / 4;
				//	color = lerp(screen_col, lerp(screen_col, mask, (radius-buffer)/weight), (radius-buffer)/weight); 

				//	}
				else 
					color = lerp(mask, screen_col, 1-dist); //(radius-buffer)/weight); 
					//color = screen_col;

			}

			// BLUR CENTER
			else if (!inverse) {
				float weight = abs(dist + buffer); 
				if (dist >= radius) // out of radius. keep clear
					color = mask;	

				//else if (dist-buffer < radius && weight >= radius) {	// middle range. blend with lerp. 
					//float my_weight = clamp(weight*0.95/(radius+buffer), 0, 1.0); 
					//color = lerp(mask, screen_col, my_weight); 
					//color = lerp(mask, lerp(mask, screen_col, dist*2 ), screen_col.a); 
					//color = lerp( screen_col, lerp(screen_col, lerp(screen_col, mask, weight/(radius+buffer)), weight/(radius+buffer)), weight/(radius+buffer)); 
					//color = lerp(screen_col, mask, weight/(radius)); 
					//color += lerp(screen_col, tex2D (_MainTex, i.uv21), weight/(radius));
					//color += lerp(screen_col, tex2D (_MainTex, i.uv22), weight/(radius+buffer));
					//color += lerp(screen_col, tex2D (_MainTex, i.uv23), weight/(radius+buffer));
					//color = float4 (0,1,1,0); 
				//}
				else {// within radius. full blur. 
						color = screen_col; 
						color += lerp(screen_col, mask, dist); 
						color = color/2; 
						}

			}  
		
			color.a = mask.a * screen_col.a;
			//clamp(color, 0.1, 0.9);
			return color;
		}

			// VERTICAL AND HORIZONTAL BLUR BABIES
			// weight curves
		static const half curve[7] = { 0.0205, 0.0855, 0.232, 0.324, 0.232, 0.0855, 0.0205 };  // gauss'ish blur weights

		static const half4 curve4[7] = { half4(0.0205,0.0205,0.0205,0), half4(0.0855,0.0855,0.0855,0), half4(0.232,0.232,0.232,0),
			half4(0.324,0.324,0.324,1), half4(0.232,0.232,0.232,0), half4(0.0855,0.0855,0.0855,0), half4(0.0205,0.0205,0.0205,0) };

		#include "UnityCG.cginc"


		struct v2f_withBlurCoords8 
		{
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			half2 offs : TEXCOORD1;
		};	

		v2f_withBlurCoords8 vertBlurHorizontal (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = UnityObjectToClipPos (v.vertex);
			
			o.uv = half4(v.texcoord.xy,1,1);
			o.offs = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _Parameter.x;

			return o; 
		}
		
		v2f_withBlurCoords8 vertBlurVertical (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = UnityObjectToClipPos (v.vertex);
			
			o.uv = half4(v.texcoord.xy,1,1);
			o.offs = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _Parameter.x;
			 
			return o; 
		}	


		half4 fragBlur8 ( v2f_withBlurCoords8 i ) : SV_Target
		{
			half2 uv = i.uv.xy; 
			half2 netFilterWidth = i.offs;  
			half2 coords = uv - netFilterWidth * 3.0;  
			
			half4 color = 0;
  			for( int l = 0; l < 7; l++ )  
  			{   
				half4 tap = tex2D(_MainTex, coords);
				color += tap * curve4[l];
				coords += netFilterWidth;
  			}
			return color;
		} 
				 
	ENDCG


	SubShader
	{
		Cull Off ZWrite Off ZTest Always	// No culling or depth. double check these for optimization 

		// 0
		Pass
		{
			//#include "UnityCG.cginc"
			//Lighting Off
			Blend SrcAlpha OneMinusSrcAlpha
			//Blend DstColor SrcColor
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0		//this feature only exists startign with shader model 3.0 
			#pragma shader_feature INVERT_MASK
			ENDCG
		} 
		// 1
		Pass 
		{
			ZTest Always
			Cull Off
			CGPROGRAM 			
			#pragma vertex vertBlurVertical
			#pragma fragment fragBlur8
			ENDCG 
		}
		// 2
		Pass 
		{		
			ZTest Always
			Cull Off
			CGPROGRAM
			#pragma vertex vertBlurHorizontal
			#pragma fragment fragBlur8 //frag
			ENDCG
		}				
	
	}
	FallBack Off
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
