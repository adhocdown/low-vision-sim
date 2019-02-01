

using UnityEngine;
using System.Collections;

// Rendering with material in a nut shell = Graphics.Blit
// so we can previoew image effect in editor
[ExecuteInEditMode]
[RequireComponent (typeof(Camera))]

public class blur_simple : MonoBehaviour {

	//public Shader blurShader; 
	public Material blurMaterial; // there's no need to create a mess of materials + corresponding shaders. procedurally generate these


	[Range(0.0f, 10.0f)]
	public float blurSize = 3.0f;  //Iterations; 		// SliderJoint2D to ControllerColliderHit how many blur iterations we perform
	[Range(0, 20)]
	public int blurIterations;  /// Using multiple iterations is the same as using a larger kernel!! (costs less far less than the massive number os famples required to do large blurs) 
	[Range(0, 2)]
	public int downsample;

	void Awake() { 
		//blurMaterial = new Material(Shader.Find("MyShaders/BoxBlur"));
		//blurMaterial = new Material(Shader.Find("Hidden/FastBlur"));
		//blurMaterial = new Material(Shader.Find("Hidden/BlurEffectConeTap"));
		blurMaterial = new Material(Shader.Find("Hidden/SeparableBlurPlus"));

	}


	// EX of ping pong approach to a 3x3 kernel with multiple Blit iterations 
	/*RenderTexture Blur(RenderTexture source, int iterations) {
		RenderTexture rt = source;
		Material mat = new Material (Shader.Find ("Blur"));
		RenderTexture blit = RenderTexture.GetTemporary ((int)Resolution, (int)Resolution);
		for (int i = 0; i < blurIterations; i++) {
			Graphics.SetRenderTarget (blit);
			GL.Clear (true, true, Color.black);
			Graphics.Blit (rt, blit, mat); 
			GL.Clear (true, true, Color.black);
			Graphics.Blit (blit, rt, mat);
		}
		RenderTexture.ReleaseTemporary (blit);
		return rt; 
	}*/

	// generate a temporary rendered texture that is the same WIDTH and HEIGHT as our source
	// and then do a PLANE BLIT from the source to the temp txt (rt)

	// generate ANOTHER temp rendered texture and BLIT rt into it (we'll call this 2nd copy rt2)
	// the blurred image is now in rt2, so we can RELEASE rt
	// then set rt = rt2 (basically update rt to rt2 as you add info) 
	// this maintains rt as a reference to our blurred image regardless of whether we loop or exit

	// FINALLY BLIT rt to our destination
	// and RELEASE rt into the void 

	// NOTE: DownRes -> bit shifted versions of the source width and height 
	//					this way the image will always be scaled down in powers of two 
	// THIS BENEFIT IS TWOFOLD
	// Not only are we blurring fewer pixels with every interation
	// but thanks to bilinear scaling, the DownRes image is naturally a bit blurrier 
	// so fewer blur steps need to be take ;) 


	void OnRenderImage (RenderTexture src, RenderTexture dst) {

		//float widthMod = 1.0f / (1.0f * (1<<downsample));
		//BlurMaterial.SetVector ("_Parameter", new Vector4 (blurSize * widthMod, -blurSize * widthMod, 0.0f, 0.0f));
		//src.filterMode = FilterMode.Bilinear; // ??

		int rtW = src.width >> downsample;   
		int rtH = src.height >> downsample;  
		//float widthMod = 1.0f / (1.0f * (1<<downsample));


		RenderTexture rt = RenderTexture.GetTemporary (rtW, rtH, 0, src.format);	//downsample
		Graphics.Blit (src, rt); 

		// CURRENTLY ITERATIONS DOES NOTHING 
		for (int i = 0; i < blurIterations; i++) { 
			// Seperable Operations 
			// vertical blur
			RenderTexture rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, src.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2); //, blurMaterial, 1 + passOffs);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;

			// horizontal blur
			rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, src.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2); //, blurMaterial, 2 + passOffs);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;

		}

		Graphics.Blit (rt, dst);
		RenderTexture.ReleaseTemporary (rt); 
	}


}


// COMMON PRACTICE ALERT FOR IMAGE EFFECTS
// It is common practice to store textures here and there temporarily 
// while you build up your desired effect! 