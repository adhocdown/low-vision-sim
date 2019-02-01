// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'





Shader "Cg basic shader" { // defines the name of the shader 
   SubShader { // Unity chooses the subshader that fits the GPU best
      Pass { // some shaders require multiple passes
         CGPROGRAM // here begins the part in Unity's Cg

         #pragma vertex vert 
            // this specifies the vert function as the vertex shader 
         #pragma fragment frag
            // this specifies the frag function as the fragment shader

		// vertex shader 
		// vertex shaders are programs that are applied to each vertex (think 3d space)
         float4 vert(float4 vertexPos : POSITION) : SV_POSITION  
         {
            //return mul(UNITY_MATRIX_MVP, vertexPos);
            //flattens geometry  (y coordinate * 0.1)
            //results from a component-wise vector product (see vector and matrix operations for more) 
            return UnityObjectToClipPos(float4(1.0, 0.1, 1.0, 1.0) * vertexPos); 
               // this line transforms the vertex input parameter 
               // vertexPos with the built-in matrix UNITY_MATRIX_MVP
               // and returns it as a nameless vertex output parameter 
         }

         // fragment shader
         // fragment shaders are programs that are applied to each frament (and then pixel) (think image space)
         // Assigns color     
         float4 frag(void) : COLOR 
         {
            //return float4(1.0, 0.0, 0.0, 1.0); 
           return float4(0.6, 1.0, 0.4, 0.6);

               // this fragment shader returns a nameless fragment
               // output parameter (with semantic COLOR) that is set to
               // opaque red (red = 1, green = 0, blue = 0, alpha = 1)
         }

         ENDCG // here ends the part in Cg 
      }
   }
}