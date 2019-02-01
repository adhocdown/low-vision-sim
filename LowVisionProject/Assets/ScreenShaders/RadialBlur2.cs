using UnityEngine;

[ExecuteInEditMode]
public class RadialBlur : MonoBehaviour
{
	public Shader rbShader;

	public float blurStrength = 2.2f;
	public float blurWidth = 1.0f;

	private Material rbMaterial = null;

	private Material GetMaterial()
	{
		if (rbMaterial == null)
		{
			rbMaterial = new Material(rbShader);
			rbMaterial.hideFlags = HideFlags.HideAndDontSave;
		}
		return rbMaterial;
	}

	void Start()
	{
		rbShader = Shader.Find("RadialBlur2");
		if (rbShader == null)
		{
			Debug.LogError("shader missing!", this);
		}
	}

	void OnRenderImage(RenderTexture source, RenderTexture dest)
	{
		GetMaterial().SetFloat("_BlurStrength", blurStrength);
		GetMaterial().SetFloat("_BlurWidth", blurWidth);
		//ImageEffects.BlitWithMaterial(GetMaterial(), source, dest);
		Graphics.Blit(source, dest, GetMaterial());

	}
}