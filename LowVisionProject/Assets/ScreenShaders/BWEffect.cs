using UnityEngine;
using System.Collections;


[ExecuteInEditMode]
public class BWEffect : MonoBehaviour {


	public float intensity;
	private Material material;

	// Creates a private material used to the effect
	void Awake () {
		// This creates a private material. We could also provide a material directly from the inspector
		// but there's a risk of that material being shared between other instances of BWEffect
		// (Perhas a better option would be to provide the script the shader itself, rather than using its name as a string!)
		// LOOK INTO THIS ^^^^
		//material = new Material (Shader.Find ("Hidden/BWDiffuse"));
		material = new Material (Shader.Find ("Hidden/SimpleImageEffectsShader"));

	}

	// Postprocess the image
	// invoked very time a new frame has to be rendered on the camera
	// use this event to intercept the current frame and edit it, before it's rendered to the screen
	void OnRenderImage (RenderTexture source, RenderTexture destination) {

		// Skips the usage of the shader, if the effect ahs been disabled. 
		if (intensity == 0) {
			Graphics.Blit (source, destination);
			return;
		}

		// The magic happens here
		// The function Blit takes a source RenderTexture, processes it with the  provided materaial, and renders it onto specified destinations
		// Blit is typically used for postprocessing effect
		// 		so it initializes the poroperty _MainTex of the shader with what the camera has rendered so far
		//			The only paramterer which ahs to be initialized manually is the boolean coefficient. 
		material.SetFloat("_bwBlend", intensity);
		Graphics.Blit (source, destination, material); 
	}
}
