// This code is related to an answer a user provided in the Unity forums at:
// http://forum.unity3d.com/threads/circular-fade-in-out-shader.344816/
// Previously "ScreenTransitionImageEffect"
// I have modified the code to create a scalable scotoma for a macular degeneration simulation


using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
[AddComponentMenu("Image Effects/Screen Transition")]
public class ScotomaOpaqueMask : MonoBehaviour
{
    /// Provides a shader property that is set in the inspector
    /// and a material instantiated from the shader
    public Shader shader;
	PlatformDefines hmd; 

    [Range(0,2.0f)]
    public float maskValue;
	public float maskSpread;
	public float maskRadius;
    public Color maskColor = Color.black;
    public Texture2D maskTexture;
    public bool maskInvert;

	public float x_scale;
	public float y_scale; 
	public float x_trans;
	public float y_trans; 

    private Material m_Material;
    private bool m_maskInvert;
	bool islefteye;

    Material material
    {
        get
        {
            if (m_Material == null)
            {
                m_Material = new Material(shader);
                m_Material.hideFlags = HideFlags.HideAndDontSave;
            }
            return m_Material;
        }
    }

    private void Awake()
    {
        //if (GetComponent<Camera>().stereoTargetEye.Equals("Left"))
        if (transform.name == "LeftEyeAnchor")
            islefteye = true;
        else { islefteye = false; }

    }

    void Start()
    {
        // Disable if we don't support image effects
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false; 
            return;
        }

        shader = Shader.Find("Hidden/ScreenTransitionImageEffect");

        // Disable the image effect if the shader can't 
        // run on the users graphics card 
        if (shader == null || !shader.isSupported)
            enabled = false;

		// Grab platform/HMD information from the Game Manager GO 
		//int num = PlatformDefines.hmd_id;  
		GameObject gameManager = GameObject.FindGameObjectWithTag ("Manager");
		hmd = gameManager.GetComponent<PlatformDefines> ();
		scaleFactor(); 


    } 

	void scaleFactor() {
		float x_pixel_count = hmd.myHMD.screen_dimension_x * (60 / hmd.myHMD.fov_x);
		float y_pixel_count = hmd.myHMD.screen_dimension_y * (60 / hmd.myHMD.fov_y); 
		x_scale = hmd.myHMD.fov_x / 60;  
		y_scale = hmd.myHMD.fov_y / 60;

		
		x_trans = (hmd.myHMD.screen_dimension_x - x_pixel_count)/2;
		y_trans = (hmd.myHMD.screen_dimension_y - y_pixel_count)/2;
		x_trans /= hmd.myHMD.screen_dimension_x;
		y_trans /= hmd.myHMD.screen_dimension_y;
		x_trans *= x_scale;
		y_trans *= y_scale;

        Debug.Log("pixelcnt:  " + x_pixel_count + ", " + y_pixel_count);
        Debug.Log("scale:  " + x_scale + ", " + y_scale);
        //Debug.Log ("trans:  " + x_trans + ", " +  y_trans);


    }

    void OnDisable() 
    {
        if (m_Material)
        {
            DestroyImmediate(m_Material);
        }
    }
		

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (!enabled)
        {
            Graphics.Blit(source, destination);
            return;
        }

		material.SetColor("_MaskColor", maskColor);
        material.SetFloat("_MaskValue", maskValue);
		material.SetFloat ("_MaskRadius", maskRadius);
		material.SetFloat ("_MaskSpread", maskSpread);
		material.SetTexture("_MainTex", source);
        material.SetTexture("_MaskTex", maskTexture);

		material.SetFloat ("_XScale", x_scale);
		material.SetFloat ("_YScale", y_scale);
		material.SetFloat ("_XTrans", x_trans);
		material.SetFloat ("_YTrans", y_trans);

        if (material.IsKeywordEnabled("INVERT_MASK") != maskInvert) 
        {
            if (maskInvert)
                material.EnableKeyword("INVERT_MASK");
            else
                material.DisableKeyword("INVERT_MASK");
        }

        Graphics.Blit(source, destination, material);
    }

    
	public void changeDeficit(int num) {
		string texImage = "";


		switch (num) {
		case 0:
			texImage = "_black";
			break;
		case 1:
			texImage = (islefteye) ? "homonymous_hemianopia_incomplete_left_clamp30_gaussian": "homonymous_hemianopia_incomplete_right_clamp30_gaussian";
			break;
		case 2:
			texImage = (islefteye) ? "homonymous_hemianopia_complete_left_clamp30_gaussian": "homonymous_hemianopia_complete_right_clamp30_gaussian";
			break;
		case 3:
			texImage = (islefteye) ?  "bitemporal_loss_simulated_left_clamp30_gaussian": "bitemporal_loss_simulated_right_clamp30_gaussian";
			break;
		case 4:
			texImage = (islefteye) ?  "central_scotoma_simulated_left_clamp30_gaussian": "central_scotoma_simulated_right_clamp30_gaussian";
			break;
		default:
			texImage = "_black";
			break;
		}


	
		//Texture2D inputTex = (Texture2D)Resources.Load(texImage, typeof(Texture2D));
		//cameraTex = (Texture2D)Resources.Load(texImage, typeof(Texture2D));
		maskTexture = Resources.Load (texImage, typeof(Texture2D)) as Texture2D;
		//cameraTex = Resources.Load (texImage) as Texture2D;
		//Debug.Log (maskTexture);
       
	}
     

}
