using UnityEngine;
using System.Collections;
using System.IO;


public class PersistentInputMgmt : MonoBehaviour {

	string filename;


	// grab filename from previously set filename/path
	void Start() {
		//filename = persistentGameObject.Find ("DataManager").GetComponent(
		GameObject persistentGO = GameObject.Find("DataManager");
		filename = persistentGO.GetComponent<StartInput> ().filename;
	}


	// !!!!!!!!!!! INGAME INPUTS !!!!!!!!!!!!!
	// They will not work with the start input mechanics
	// move filename 
	void Update () {

		// Think about mergins the rotation code and the phase code
		// Rotation left or right 17 degrees 
		/*if (Input.GetKeyDown(KeyCode.KeypadMinus)) {
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.WriteLine ("Rotate me left");
			}
		}
		if (Input.GetKeyDown(KeyCode.KeypadPlus)) {
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.WriteLine ("Rotate me right");
			}		}*/


		// Trial Inputs 
		if (Input.GetKeyDown ("1")) {
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.WriteLine ("Pre Exposure Trial");
			}
		}
		if (Input.GetKeyDown ("2")) {
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.WriteLine ("Prism Exposure Trial");
			}
		}
		if (Input.GetKeyDown ("3")) {
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.WriteLine ("Post Exposure Trial");
			}
		}
			
		// ERROR CATCH 
		// The participant "dropped the ball" ;)
		// Indicates that the previous value contains error
		/*if (Input.GetKeyDown ("E")) {
			Debug.Log ("Error"); 
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.Write("ERR, ");
			}
		} */
			
	}

}
