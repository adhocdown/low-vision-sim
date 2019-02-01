using UnityEngine;
using System.Collections;


// I CANT FIGURE HOW TO MAKE THE TEXTURE INTERACT PROPERLY WITH THE SCRIPT
// WILL RETURN TO LATER
// ALSO NEEDS STRENGTH PARAM TO BE LINKED HERE (not just in DISTORTION shader)

// Note: if want effect on multiple cameras, must make copy of the material in the Awake method to ensure every
// 		 script has its own instance. Then you may tweak them individually without any problem 

[ExecuteInEditMode]
public class CRTEffect : MonoBehaviour {

	public Material material;
	//public Shader shader;

	void OnAwake() {
		//material.Shader = shader; 
		//material.shader = shader;
		//material.Material.Shader = shader; 
	}

	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination) {
		Graphics.Blit (source, destination, material);
	}
}
