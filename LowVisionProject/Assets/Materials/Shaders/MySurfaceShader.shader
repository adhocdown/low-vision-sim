// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




// HLSL is the High Level Shading Language for DirectX. Using HLSL, you can create C like 
// programmable shaders for the Direct3D pipeline. 

// The Cg language is primarily modeled on ANSI C, but adopts some ideas from modern languages such as C++ and Java
// and from earlier shading languages such as RenderMan and the Stanford shading lanugage. It's a low-level language 
// with features designed to map as directly as possible to hardware capabilities.




Shader "Custom/MySurfaceShader" {

	Properties {
		// Default types of properties in a shader skeleton 
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		// All the basic types of properties you can have in a shader:
		// 2D -> 	texture (but may alos be initialized to white, gray, or black
		//			use "bump" to indicate that the texture will be used as a normal map
		//			"bump" will auto initialize to gray (#808080) - no bump map

		_MyTexture ("My Texture", 2D) = "white" {}
		_MyNormalMap ("My Normal Map", 2D) = "bump" {} // Gray

		_MyInt ("My Integer", Int) = 2
		_MyFloat ("My Float", Float) = 1.5
		_MyRange ("My Range", Range(0.0, 1.0)) = 0.5

		_MyColor ("My color", Color) = (1, 0, 0, 1)      // (R, G, B, A)
		_MyVector ("My Vector4", Vector) = (0, 0, 0, 0)  // (x, y, z, w)

	}
	// 	Properties { _MainTex ("", any) = "" {} }



	// This is for instructional purposes!
	// Different SubShaders are typically used to target different graphics hardware capabilities
	// with each describiing complete graphics hardware renderin satate and ver/frag programs to use
	// BUT THAT AINT WHAT'S HAPPENING HERE
	// DONT ATTACH THIS TO ANYTHING

	// #1 SubShader demonstrates a simple SURFACE SHADER
	// #2 SubShader demonstrates a VERTEX AND FRAGMENT SHADER 



	// Code of the Shader
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
			void surf (Input IN, inout SurfaceOutput o) {
			//o.Albedo = text2D (_MainTex, IN.uv_MainTex).rgb;
			o.Albedo = 1; 
			}		
		ENDCG
		} 	FallBack "Diffuse"



		///////////////////////////////////////////////////////////////////////////////////////////
		// VERTEX AND FRAGMENT SHADERS
		// V&F shaders work close to the way the GPU renders triangles
		// they have no built-in concept of how light should behave. 
		// The geomery of your model is 1st passed through a function cllaed vert which can alter its vertices
			// Then individual triangles are passed through another function (frag) 
			// which decides the final RGB color for every pixel
		// They are useful for 2D effects, postprocessing, and special 3D effects which are too complex to be expressed as surface shaders

		// EXAMPLE OF A VERTEX AND FRAGMENT SHADER

		// Ther vert function converts the vertices from their native 3D space to their final 2D position on the screen
		// UNITY_MATRIX_MVP hids the maths behind this translation
		// After this, the return of the frag function gives RED color to every pixel. 
		// REMEMBER: The CG section of vertex and fragment shaders needs to be enclosed in 
		//			 a "PASS" section. 
		//			 This is NOT the case for simple surface shaders


	SubShader {
		Pass {
			CGPROGRAM 
			#pragma vertex vert
			#pragma fragment frag

			struct vertInput {
				float4 pos : POSITION;
			};
			struct vertOutput {
				float4 pos : SV_POSITION;
			};

			vertOutput vert(vertInput input) {
				vertOutput o;
				o.pos = UnityObjectToClipPos(input.pos);
				return o;
			}

			half4 frag(vertOutput output) : COLOR {
				return half4 (.9, 0.0, 0.0, 1.0);
			}

			ENDCG
		}
		///////////////////////////////////////////////////////////////////////////////////////////
	}
}
