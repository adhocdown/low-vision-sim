// This code is related to an answer a user provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/
// Previously "ScreenTransitionImageEffect"
// I have modified the code to create a scalable scotoma for a macular degeneration simulation


using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
//[RequireComponent(typeof(Camera))]
//[AddComponentMenu("Image Effects/Screen Transition")]
public class ScotomaOpaque : MonoBehaviour
{
	/// Provides a shader property that is set in the inspector
	/// and a material instantiated from the shader


	public float maskRadius = 0.5f;
	public Color maskColor = Color.black;
	public bool maskInvert = false;

	public Shader shader;
	private Material opaqueMaterial; 

	void Awake() {
		//shader = new Material (Shader.Find ("ScotomaOpaque"));
		opaqueMaterial = new Material (shader);
	
	}
		

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Skips the use of the shader, if the effect has been disabled 
		if (!enabled)
		{
			Graphics.Blit(source, destination);
			return;
		}
		//opaqueMaterial.SetVector ("_Parameter", new Vector4 (1.0f, 1.0f, 0.0f, 0.0f));
		opaqueMaterial.SetColor("_MaskColor", maskColor);
		opaqueMaterial.SetFloat ("_MaskRadius", maskRadius);
		opaqueMaterial.SetTexture("_MainTex", source);

		if (opaqueMaterial.IsKeywordEnabled("INVERT_MASK") != maskInvert)
		{
			if (maskInvert)
				opaqueMaterial.EnableKeyword("INVERT_MASK");
			else
				opaqueMaterial.DisableKeyword("INVERT_MASK");
		}

		Graphics.Blit(source, destination, opaqueMaterial);
	}
}

