// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Cg shader with single texture" {
   Properties {
      _MainTex ("Texture Image", 2D) = "white" {} 
         // a 2D texture property that we call "_MainTex", which should
         // be labeled "Texture Image" in Unity's user interface.
         // By default we use the built-in texture "white"  
         // (alternatives: "black", "gray" and "bump").
   }
   SubShader {
      Pass {	
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
                   
         uniform sampler2D _MainTex;	
         uniform float4 _MainTex_ST; 
            // tiling and offset parameters of property

         struct vertexInput {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 tex : TEXCOORD0;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            output.tex = input.texcoord;
            output.pos = UnityObjectToClipPos(input.vertex);
            return output;
         }

         float4 frag(vertexOutput input) : COLOR
         {
            return tex2D(_MainTex, 
               _MainTex_ST.xy * input.tex.xy + _MainTex_ST.zw);	
               // texture coordinates are multiplied with the tiling 
               // parameters and the offset parameters are added
         }

         ENDCG
      }
   }
   Fallback "Unlit/Texture"
}