using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;


// Call this Platform Defines instead 
public class PlatformDefines : MonoBehaviour {

	// using enum here to improve type safety and readability 
	public enum Type {
		Editor,
		Vive,
		OculusCV1,
		Android
		//OculusDK2,
		//Gear // detect if android device? 
		//Cardboard
	}
		

	public struct HMD_DATA {
		public int screen_dimension_x;
		public int screen_dimension_y;
		public float fov_x;		// monocular fov (fov per eye)
		public float fov_y; 
		public float pixel_density;
		public float scale_factor; // may delete later

		public void set_pixel_density() {	// Note: not entirely accurate. verical pixel density may differ. 
			pixel_density = screen_dimension_x / fov_x;
		}

	};


	public HMD_DATA myHMD = new HMD_DATA ();   
	public static int hmd_id; 
	const string model_vive1 = "Vive MV";
	const string model_rift1 = "Oculus Rift CV1";
	const string model_riftdk2 = "Oculus Rift DK2"; 
	//const string model_gear = "Samsung Gear"; // check this (name contains "samsung" :?


	// On Awake():  Detect device/build settings and save indicator
 	void Awake() {
		string model = UnityEngine.XR.XRDevice.model != null ?
			UnityEngine.XR.XRDevice.model : "";  		// conditional operator isn't doing much here but ehhh		

		#if UNITY_STANDALONE_WIN
		if (model == model_vive1)
			hmd_id = (int)Type.Vive;
		else if (model == model_rift1)
			hmd_id = (int)Type.OculusCV1;
		else
			hmd_id = (int)Type.Editor; 
		#endif 

		#if UNITY_ANDROID
		hmd_id = (int)Type.Android;
		#endif 
		//Debug.Log (hmd_id); 

		// Detect hmd. save fov data.
		// Detect screen w/h 
		// Get factor 
		// Use this for initialization
		 
		// set field of view data here
		// grab vertical and horizontal FOV. 
		// grab screen resolution (no need do but may help efficiency)

		myHMD = new HMD_DATA ();  

		// FOV information taken from doc-0k.org/?p=1414
		switch (hmd_id) {
		case (int)Type.Vive:
			Debug.Log ("Vive connected");
			myHMD.screen_dimension_x = 1080;
			myHMD.screen_dimension_y = 1200;
			myHMD.fov_x = 100;
			myHMD.fov_y = 113; 
			myHMD.set_pixel_density ();
				//myHMD.scale_factor = 0;					
			break;
		case (int)Type.OculusCV1:
			Debug.Log ("Oculus CV1 connected");
			myHMD.screen_dimension_x = 1080;
			myHMD.screen_dimension_y = 1200;
			myHMD.fov_x = 84;
			myHMD.fov_y = 93; 
			myHMD.set_pixel_density ();
			break;
		case (int)Type.Android:
			Debug.Log ("Android device connected? Assumes Galaxy S7"); 
			myHMD.screen_dimension_x = 1280;
			myHMD.screen_dimension_y = 1440;
			myHMD.fov_x = 84;	// device dependency. couldn't find straight answer. seems comparable to the cv1 based on vertical (~96)
			myHMD.fov_y = 93; 
			myHMD.set_pixel_density ();
			break;
		default:
			Debug.Log ("No hmd detected [Editor] Assumes specs of DK2"); 
			myHMD.screen_dimension_x = 960;
			myHMD.screen_dimension_y = 1080;
			myHMD.fov_x = 93;	// device dependency. couldn't find straight answer. seems comparable to the cv1 based on vertical (~96)
			myHMD.fov_y = 104; 
			myHMD.set_pixel_density ();
			break;

		//case (int)Type.OculusDK2:
		//		Debug.Log ("Oculus DK2 connected");
		}
		Debug.Log ("After switch statement"); 
	}
		
	

}
