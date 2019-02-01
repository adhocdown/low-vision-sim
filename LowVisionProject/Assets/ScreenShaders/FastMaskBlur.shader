Shader "FastMaskBlur"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {} 	// main
		//_MaskTex ("Mask Texture", 2D) = "white" {} 	// handle mask (scotoma)
		_MaskMapTex ("Mask Map Texture", 2D) = "white" {} 	// handle mask (scotoma)
		_MaskColor ("Mask Color", Color) = (1,0,0,1)
		_Bloom ("Bloom (RGB)", 2D) = "black" {}

		_XScale("X Scale", Float) = 1  // Scale and translation modifiers for screen
		_YScale("Y Scale", Float) = 1
		_XTrans("X Scale", Float) = 1
		_YTrans("Y Scale", Float) = 1
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		//sampler2D _MaskTex;
		sampler2D _MaskMapTex;

		float4 _MaskColor;  
		sampler2D _Bloom;
				
		uniform half4 _MainTex_TexelSize;
		uniform half4 _Parameter;
		float _XScale;
		float _YScale;
		float _XTrans;
		float _YTrans;

		// newbies 
		uniform float _Angle;
		uniform float4 _CenterRadius;


		struct v2f_tap
		{
			float4 pos : SV_POSITION;
			half2 uv20 : TEXCOORD0; 
			half2 uv21 : TEXCOORD1;
			half2 uv22 : TEXCOORD2;
			half2 uv23 : TEXCOORD3;

			half2 uv30 : TEXCOORD4; // my add

		};			


		v2f_tap vert4Tap ( appdata_img v )
		{
			v2f_tap o;			 
			o.pos = UnityObjectToClipPos (v.vertex);

			// no blur
           	//o.uv2 = v.texcoord + _MainTex_TexelSize.xy; 

           	// for blur
			o.uv30 = float2((v.texcoord.x*_XScale) - _XTrans, (v.texcoord.y*_YScale) - _YTrans ); // import this factor from start

			// original
           	o.uv20 = v.texcoord + _MainTex_TexelSize.xy;				
           	o.uv21 = v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,-0.5h);	
			o.uv22 = v.texcoord + _MainTex_TexelSize.xy * half2(0.5h,-0.5h);		
			o.uv23 = v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,0.5h);		

			return o; 
		}	

		// Downsample == 1
		fixed4 fragDownsample ( v2f_tap i ) : SV_Target
		{			
			fixed4 color = tex2D (_MainTex, i.uv20);
			float4 mask = tex2D(_MaskMapTex, i.uv30); // i.uv20 maps to main tex coord (big)


			if (mask.a <= 0.02) {
				return color;
			}

			//return _MaskColor;

			color += tex2D (_MainTex, i.uv21);
			color += tex2D (_MainTex, i.uv22);
			color += tex2D (_MainTex, i.uv23);
			color /= 4;

			color.rgb = lerp(tex2D(_MainTex, i.uv20), color, mask.a);
			return color; 
		}
			

		// weight curves
		static const half curve[7] = { 0.0205, 0.0855, 0.232, 0.324, 0.232, 0.0855, 0.0205 };  // gauss'ish blur weights

		static const half4 curve4[7] = { half4(0.0205,0.0205,0.0205,0), half4(0.0855,0.0855,0.0855,0), half4(0.232,0.232,0.232,0),
			half4(0.324,0.324,0.324,1), half4(0.232,0.232,0.232,0), half4(0.0855,0.0855,0.0855,0), half4(0.0205,0.0205,0.0205,0) };

		struct v2f_withBlurCoords8 
		{
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			half2 offs : TEXCOORD1;
			half2 uv30 : TEXCOORD2;
		};	


		v2f_withBlurCoords8 vertBlurHorizontal (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = UnityObjectToClipPos (v.vertex);

			o.uv = half4(v.texcoord.xy,1,1);
			o.uv30 = float2((v.texcoord.x*_XScale) - _XTrans, (v.texcoord.y*_YScale) - _YTrans ); // import this factor from start


			o.offs = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _Parameter.x;

			return o; 
		}
		
		v2f_withBlurCoords8 vertBlurVertical (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = UnityObjectToClipPos (v.vertex);
			
			o.uv = half4(v.texcoord.xy,1,1); 
			o.uv30 = float2((v.texcoord.x*_XScale) - _XTrans, (v.texcoord.y*_YScale) - _YTrans ); // import this factor from start


			o.offs = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _Parameter.x;
			 
			return o; 
		}	

		half4 fragBlur8 ( v2f_withBlurCoords8 i ) : SV_Target
		{
			//float4 mask = tex2D(_MaskMapTex, i.uv);
			float4 mask = tex2D(_MaskMapTex, i.uv30); // i.uv20 maps to main tex coord (big)

			half4 color = tex2D (_MainTex, i.uv);
			if (mask.a <= 0.02) 
				return color;

				
			half2 uv = i.uv.xy; 
			half2 netFilterWidth = i.offs;  
			half2 coords = uv - netFilterWidth * 3.0;  
			
			color = 0;
  			for( int l = 0; l < 7; l++ )  
  			{   
				half4 tap = tex2D(_MainTex, coords);
				color += tap * curve4[l];
				coords += netFilterWidth;
  			}
			// Scale 0..255 to 0..254 range. 
			float alpha = mask.a * (1 - 1/255.0);
			//alpha = alpha
  			
  			//weight = smoothstep(mask, _MainTex, alpha);
  			//half4 tmpcol = _MaskColor; 
			color.rgb = lerp(tex2D(_MainTex, i.uv), color, mask.a);
			return color; 
		}


					
	ENDCG
	
	SubShader {
	  ZTest Off Cull Off ZWrite Off Blend Off

	// 0
	Pass { 
	
		CGPROGRAM
		
		#pragma vertex vert4Tap
		#pragma fragment fragDownsample // fragment frag 
		
		ENDCG
		 
		}

	// 1
	Pass {
		ZTest Always
		Cull Off
		
		CGPROGRAM 
		
		#pragma vertex vertBlurVertical
		#pragma fragment fragBlur8
		//#pragma fragment fragBlur8
		
		ENDCG 
		}	
		
	// 2
	Pass {		
		ZTest Always
		Cull Off
				
		CGPROGRAM
		
		#pragma vertex vertBlurHorizontal
		#pragma fragment fragBlur8 //frag
		//#pragma fragment fragBlur8


		ENDCG
		}	


	}	

	FallBack Off
}