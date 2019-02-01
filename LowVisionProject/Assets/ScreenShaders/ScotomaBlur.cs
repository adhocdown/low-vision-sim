
using System;
using UnityEngine;
using System.Collections;


[ExecuteInEditMode]
[RequireComponent (typeof(Camera))]

public class ScotomaBlur : MonoBehaviour
{
		// Variables for Platform Defines and Screen Position
		PlatformDefines hmd; 
		bool islefteye;

		public float x_scale;
		public float y_scale; 
		public float x_trans;
		public float y_trans;

		// Variables for Mask Materials 
		private  Material blurMaterial; 
		public Texture2D maskTexture;
		public Color maskColor = Color.black;

		// Variables for Blur  
		[Range(0, 2)]  
		public int downsample = 1;
		[Range(0.0f, 10.0f)]  
		public float blurSize = 3.0f;
		[Range(0, 4)]
		public int blurIterations = 2;
		 
		
	void Awake() { 
        // note: if using Gear: use FastMaskBlur
        //       else .. still use FastMaskBlur
		blurMaterial = new Material(Shader.Find("FastMaskBlur"));

        if (transform.name == "LeftEyeAnchor")
            islefteye = true;
        else { islefteye = false; }
    }

    private void Start()
    {
        // Grab platform/HMD information from the Game Manager GO 
        GameObject gameManager = GameObject.FindGameObjectWithTag("Manager");
        hmd = gameManager.GetComponentInParent<PlatformDefines>();
        Debug.Log(hmd);

        // scale 
        scaleFactor();
    }


    // This function handles the screen shader 
    public void OnRenderImage (RenderTexture source, RenderTexture destination) {
			 
            // No blur
			if (blurIterations == 0 && blurSize == 0 && downsample == 0)  {
				Graphics.Blit (source, destination);
				return;  
			 } 	

            // Yes blur 
			float widthMod = 1.0f / (1.0f * (1<<downsample));			 
			blurMaterial.SetVector ("_Parameter", new Vector4 (blurSize * widthMod, -blurSize * widthMod, 0.0f, 0.0f));
			source.filterMode = FilterMode.Bilinear; 
	
			// rt = downsample screenshot  
			int rtW = source.width >> downsample;
			int rtH = source.height >> downsample;
			RenderTexture rt = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
			
			// Blit to rt
			rt.filterMode = FilterMode.Bilinear;
			//Graphics.Blit (source, rt, blurMaterial, 0);
			Graphics.Blit (source, rt);  
			 
			// maskTexture = source screenshot             
			// rt3 = final version (combines rt/rt2 (blurry) and maskTexture (clear)  
			
		/*
			RenderTexture.active = source; 
			maskTexture = new Texture2D (source.width, source.height, TextureFormat.RGB24, false);
			maskTexture.ReadPixels( new Rect( 0, 0, source.width, source.height), 0, 0); 
			maskTexture.Apply();    
			blurMaterial.SetTexture("_MaskTex", maskTexture); 	*/	  
			 
			for(int i = 0; i < blurIterations; i++) {

				float iterationOffs = (i*1.0f);
				blurMaterial.SetVector ("_Parameter", new Vector4 (blurSize * widthMod + iterationOffs, -blurSize * widthMod - iterationOffs, 0.0f, 0.0f));

				// vertical blur
				RenderTexture rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
				rt2.filterMode = FilterMode.Bilinear;
				Graphics.Blit (rt, rt2, blurMaterial, 1);
				RenderTexture.ReleaseTemporary (rt);
				rt = rt2;

				// horizontal blur
				rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
				rt2.filterMode = FilterMode.Bilinear;
				Graphics.Blit (rt, rt2, blurMaterial, 2);
				RenderTexture.ReleaseTemporary (rt);
				rt = rt2;
			}

			//RenderTexture rt3 = RenderTexture.GetTemporary (source.width, source.height, 0, source.format);
			//rt3.filterMode = FilterMode.Bilinear;  
			//Graphics.Blit (rt, rt3, blurMaterial, 0);  

			//Graphics.Blit (rt3, destination);
			Graphics.Blit (rt, destination);
			RenderTexture.ReleaseTemporary (rt);
	}


    // Function: Scale scotoma to match pixel count and FOV of VR head-mounted display
    // Set parameters for shader (translation, scale, mask texture)
	void scaleFactor() 
	{		
		float x_pixel_count = hmd.myHMD.screen_dimension_x * (60 / hmd.myHMD.fov_x);
		float y_pixel_count = hmd.myHMD.screen_dimension_y * (60 / hmd.myHMD.fov_y); 
		x_scale = hmd.myHMD.fov_x / 60;  
		y_scale = hmd.myHMD.fov_y / 60;

		Debug.Log ("pixelcnt:  " + x_pixel_count + ", " + y_pixel_count);
		Debug.Log ("scale:  " + x_scale + ", " +  y_scale);

		x_trans = (hmd.myHMD.screen_dimension_x - x_pixel_count)/2;
		y_trans = (hmd.myHMD.screen_dimension_y - y_pixel_count)/2;
		x_trans /= hmd.myHMD.screen_dimension_x;
		y_trans /= hmd.myHMD.screen_dimension_y;
		x_trans *= x_scale;
		y_trans *= y_scale;

		Debug.Log ("trans:  " + x_trans + ", " +  y_trans);

		// set parameters for shader
		blurMaterial.SetColor("_MaskColor", maskColor);
		blurMaterial.SetFloat ("_XScale", x_scale);
		blurMaterial.SetFloat ("_YScale", y_scale);
		blurMaterial.SetFloat ("_XTrans", x_trans);
		blurMaterial.SetFloat ("_YTrans", y_trans);
		blurMaterial.SetTexture("_MaskMapTex", maskTexture);

	}

	public void changeMaskTexture(string imgName)
	{		
		maskTexture = Resources.Load(imgName, typeof(Texture2D)) as Texture2D;	
		blurMaterial.SetTexture("_MaskMapTex", maskTexture);
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

        // reassign maskTexture to appropriate scotoma 
		maskTexture = Resources.Load (texImage, typeof(Texture2D)) as Texture2D;
        changeMaskTexture(texImage);
        //Debug.Log (maskTexture);

	}
	

}

