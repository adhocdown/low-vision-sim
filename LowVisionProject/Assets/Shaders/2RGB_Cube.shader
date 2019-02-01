// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// The RGB cube represents the set of available colors (i.e. the gamut of the display)
// That makes it an excellent testing ground to show the effect of color transofrmations
// EX: grayscale, saturation, constrast, hue, etc


Shader "Cg shader for RGB cube" { 
   SubShader { 
      Pass { 
         CGPROGRAM 
 
         #pragma vertex vert // vert function is the vertex shader 
         #pragma fragment frag // frag function is the fragment shader
         #include "UnityCG.cginc" 
 
         // for multiple vertex output parameters an output structure 
         // is defined:
         // we do this because the return instruction can only return ONE VALUE!
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 col : TEXCOORD0;
            float3 norm : NORMAL;  
         };
 
         //vertexOutput vert(float4 vertexPos : POSITION) 
         vertexOutput vert(appdata_full input) 
            // vertex shader 
         {
            vertexOutput output; // we don't need to type 'struct' here
   
            output.pos =  UnityObjectToClipPos(input.vertex); 
            // TASTE THE RAINBOX
            	output.col = input.vertex + float4(0.5, 0.5, 0.5, 0.0); 
            // SINGLE COLOR VERTEX DEBUGGING (aka False-Color Images)
            	//output.col = float4(0.0, input.vertex.y, 0.0f, 1.0); 
			// Uses Text Coords to visualize ? I don't get this one tbh
			// I think it's to test clamping 
            	//output.col = float4((input.normal + float3(1.0, 1.0, 1.0))/2.0, 1.0);
			// See Debugging of Shaders in CG Programming Wikibook for more practice 


            //float val = (output.col.x + output.col.y + output.col.z)/3;
           // float val = (output.col.x *0.299 + output.col.y*0.587 +
            //output.col.z*0.114); 
           	//output.col = float4(val, val, val, output.col.w); 
            //output.col = float4(output.col.x *0.299, output.col.y*0.587 , 
            //output.col.z*0.114, output.col.w); 
               // Here the vertex shader writes output data
               // to the output structure. We add 0.5 to the 
               // x, y, and z coordinates, because the 
               // coordinates of the cube are between -0.5 and
               // 0.5 but we need them between 0.0 and 1.0. 
            return output;
         }


// The main problem, however, is: how do we get any value from the vertex shader 
// to the fragment shader? It turns out that the ONLY way to do this is to use 
// pairs of vertex output parameters and fragment input parameters WITH THE SAME 
// SEMANTICS (TEXCOORD0 in this case)

         float4 frag(vertexOutput input) : COLOR // fragment shader
         {

            return input.col; 
               // Here the fragment shader returns the "col" input 
               // parameter with semantic TEXCOORD0 as nameless
               // output parameter with semantic COLOR.
         }



         // Alternatively, you may use argument sof the vertex shader function 
         // with the OUT qualifier (as an alt to the use of an output structure)

         // HOWEVER, the use of an output structure is more common in practice. 
         // AND  it makes sure that the vertex output parameters nd fragment input
         // paramters have matching semantics 
         /*void vert (float4 vertexPos : POSITION, out float4 pos : SV_POSITION, out float4 col : TEXTCOORD0)        
         {
			pos = mul(UNITY_MATRIX_MVP, vertexPos);
			col = vertexPos + float4(0.5, 0.5, 0.5, 0.0);
			col = float4(col.x *0.21, col.y*0.72, 
            col.z*0.07, col.w); 
			return;          	
         }

         float4 frag(float4 pos : SV_POSITION, float4 col : TEXTCOORD0) : COLOR
         {
            return col;
         }*/
 
         ENDCG  
      }
   }
}