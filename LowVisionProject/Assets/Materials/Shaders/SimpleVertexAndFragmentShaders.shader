// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/SimpleVertexAndFragmentShaders"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			struct vertInput {
				float4 pos : POSITION;
			};
			struct vertOutput {
				float4 pos : SV_POSITION;
			};

			// vert function converts the vertices from their native 3D space to their final 2D position on th screen.
			// UNITY_MATRIX_MVP hides the maths behind it 
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
	}
}
