using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class PlayerInput : MonoBehaviour {

	public GameObject myCanvas;
	private bool showCanvas;
	private Texture2D cameraTex;

	// Use this for initialization
	void Start () {
		myCanvas = GameObject.FindGameObjectWithTag ("UI");
		cameraTex = GetComponentInChildren<ScotomaOpaqueMask> ().maskTexture;
		Debug.Log (cameraTex.name);
		showCanvas = true;

	}
	
	// Update is called once per frame
	void Update () {

		if (Input.GetKeyDown (KeyCode.Return)) { //|| Input.GetKeyDown(KeyCode.Mouse0)) {
			Debug.Log ("Enter pressed");
			showCanvas = !showCanvas; 
			myCanvas.SetActive (showCanvas);
			}


		}



}
