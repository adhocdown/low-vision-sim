using UnityEngine;
using System.Collections;

// Rendering with material in a nut shell = Graphics.Blit
// so we can previoew image effect in editor
[ExecuteInEditMode]
public class Shaders102 : MonoBehaviour {

	// material used to render the image
	public Material EffectMaterial;

	// Graphics.Blit() = the magic
	// 	Means (basically) "render the material from this source to that destination with this material!"
	//	Assigns the source to the main texture of the material we're using 
	//  (aka _MainTex in the SHADER) 
	void OnRenderImage (RenderTexture src, RenderTexture dst) {
		Graphics.Blit (src, dst, EffectMaterial);
	}
	

}
