Shader "Custom/SimpleSurfaceShader" {

	Properties {
		// All the basic types of properties you can have in a shader:
		// 2D -> 	texture (but may alos be initialized to white, gray, or black
		//			use "bump" to indicate that the texture will be used as a normal map
		//			"bump" will auto initialize to gray (#808080) - no bump map
		//_MyTexture ("My texture", 2D) = "white" {}
		//_MyNormalMap ("My normal map", 2D) = "bump" {} // Gray

		//_MyInt ("My integer", int) = 2
		_MyFloat ("My float", Float) = 1.5
		_MyRange ("My range", Range(0.0, 1.0)) = 0.5

		_MyColor ("My color", Color) = (1, 0, 0, 1)      // (R, G, B, A)
		_MyVector ("My Vector4", Vector) = (0, 0, 0, 0)  // (x, y, z, w)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

	}

	SubShader {
		///////////////////////////////////////////////////////////////////////////////////////////
		// How to reference varibales within Cg/HLSL
		// sampler2D = texture; half4 = vector (36 bits); float4 = color (16 bits)
		//sampler2D _MyTexture;
		//sampler2D _MyNormalMap;
		//int _MyInt;
		//float _MyFloat;
		//float _MyRange;
		//half4 _MyColor;
		//float4 _MyVector;

		///////////////////////////////////////////////////////////////////////////////////////////
		// The body of a shader typically looks like this:

		// Tags: indicate which properties of the shader we are writing 
		// For example, the order in which it should be rendered (QUEUE)
		// For example, how it should be rendered (RENDERTYPE)
		// QUEUE 	is useful to change sorting away from default behavior (sort by detph) for transparent materials
		// 			More specifically, it gives control on the rendering order of each material. Take INT vals. The smaller the #, the sooner it is drawn
		// 			Mnemonic labels also accepted: Background (1000), Geometry (2000), Transparent (3000), Overlay (4000)
		//			BG	= bg, skyboxes;  Geo = default for most solid objects;  Trnsp = glass, fire, particles, water, etc.;  Ovrly = lensflares, GUI elements, texts
		//			Note: can also make relatvie queue vals (1002). but can get nasty quickly

		Tags {
			"Queue" = "Geometry" 
			"RenderType" = "Opaque" 
		}
		// Contains the Cg / HLSL code of the shader
		// The actual CG code is indicated by the CGPROGRAM and ENDCG Directives

		// EXAMPLE OF A SURFACE SHADERS
		CGPROGRAM
			// Uses the Lambertian lighting model
			// (note: shaders taht only used the albedo peropery = diffuse)
			#pragma surface surf Lambert
			sampler2D _MainTex; // the input texture

			struct Input {
				float2 uv_MainText; 
			}; 

			// the imported texture is set as the albedo property of the material
			// in the "surf" function. 
			// Use a very simple surface function, which just samples the texture according to its UV data
			void surf (Input IN, inout SurfaceOutput o) {
				//o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
				o.Albedo = 1; 
			}		
		ENDCG		 
	}
}
