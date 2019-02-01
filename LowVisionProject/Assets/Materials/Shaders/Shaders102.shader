// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// IMAGE EFFECTS
// 	What do the coordinates of a screen look like?
	//	Previously, we colored a quad based on the UV coordinates of the mesh.
	//	The screen is basically one big quad that covers your viewing window 
	// 	It is rendered as normal with the color buffer being filled up as various objects are rendered out
	//  but before the contents of the buffer are blasted to the screen, WE CAN MODIFY THINGS
		//  VISUALIZE A WATER GUN lol

	// Use ""OnRenderImage(source, destination)" to access this point in the pipeline
		// THE TIP OF THE WATER GUN
	// Source = contains all the color an depth buffer information rendered thus far
	// Destination = rendered texture which = the camera's target (the screen)



Shader "MyShaders/Shaders102" {

	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0, 0.1)) = 1

	}

	SubShader {
		Tags 
		{
			"Queue" = "Transparent"  // makes sprites render AFTER the opaque geometry in the scene
									// prevents quirk behavior when your custom shader overlaps with opaque geometry
		 	"PreviewType" = "Plane"
		 }

		 Pass 
		 {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			//////////////////////////////////////////////////////
			//  appdata defines the infromation we are getting from each vertex on the mesh
			//  TEXCOORD0 is the first UV coordinate
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.uv = v.uv;  
				return o;
			}

			//////////////////////////////////////////////////////
			sampler2D _MainTex;
			sampler2D _DisplaceTex;
			float _Magnitude;

			// FINALLY. frag takes our v2f struct and returns
			// a color in the form oa a float4 variable 

			// turns potential pixesl into c  olors on the screen
			// even though our vert shader only passes along 4 unique UV values
			// get every value in between thanks to linear interpolation
			float4 frag (v2f i) : SV_Target
			{				

				// Animates Ripple effect
				float2 distuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2); 
				float2 disp = tex2D(_DisplaceTex, distuv).xy; 

				//float2 disp = tex2D(_DisplaceTex, i.uv).xy;  		// sample float from Displacement Map with our regular uv coordinates
				disp = ( (disp*2) - 1)  *  _Magnitude;				// look familiar? (pushes values from [0,1] to [-1,1] AND THEN* _Magnitude
																	// NOW sample our _MainTex per normal, but also add displacement value to our UV coordinates
				float4 color = tex2D(_MainTex, i.uv + disp); 	    // bring in a texture sample and 
				//color *= float4(i.uv.x, i.uv.y, 0, 1); 			// and multiply that agains the UV color FOR TRIPPY EFFECT

				return color;
			}
			//////////////////////////////////////////////////////
			ENDCG
					
		}
	} //eoSubShader
}


// THE TRICKY BIT
// RED VALUES	 	= Offsets on the x axis
// GREEN VALUES		= Offsets on the y axit

// This Distortion Map tactic is ofen used for effect like heat waves, which call for full screen visual distortion
// But it should also be animated, right? 
// We can animate with just one more line of code + ""_Time ""
// _Time accessed via "" #include "UnityCG.cginc ""
// _Time.x   ==   1/20th of the current time
// _Time.y	 ==   the current game time