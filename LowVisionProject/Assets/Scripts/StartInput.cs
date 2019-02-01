using UnityEngine;
using System.Collections;

using UnityEngine.SceneManagement;
using System.IO;


public class StartInput : MonoBehaviour {

	// use string or Text?
	public string filename; 
	string subjectID; 
	string gender; 
	string age;  
	  

	// Allows data to persist between scenes 
	// use this to access the filename for writing "ingame" data 
	// see: answers.unity3d.com/questions/36738/how-can-i-pass-data-between-two-levels.html
	void Awake() {
		DontDestroyOnLoad (transform.gameObject); 
	}

	void Start() {
		subjectID = "";
		gender = "";
		age = "0"; 
	}

	// !!!!!!!!!!! INGAME INPUTS !!!!!!!!!!!!!
	// They will not work with the start input mechanics
	// move filename 
	/*
	void Update () {
		// Rotation left or right 17 degrees
		if (Input.GetKeyDown(KeyCode.KeypadMinus)) {
			Debug.Log ("Rotate me left"); 
		}
		if (Input.GetKeyDown(KeyCode.KeypadPlus)) {
			Debug.Log ("Rotate me right"); 
		}


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
		if (Input.GetKeyDown ("E")) {
			Debug.Log ("Error"); 
			using (StreamWriter sw = File.AppendText (filename)) {				
				sw.Write("ERR, ");
			}
		}
			
	}*/




	// Set filename and path.
	// Create file if it doesn't exist.
	// Toss error if file does exist. 
	public void create_file() {
		Debug.Log(subjectID);
		Debug.Log (gender);
		Debug.Log(age);

		filename = Application.dataPath + "/Data/subject_" + subjectID + ".txt"; 
		//Debug.Log(filename); 

		if (!File.Exists (filename)) {
			// Create a file to write to
			using (StreamWriter sw = File.CreateText (filename)) {
				sw.WriteLine ("SubjectID, " + subjectID);
				sw.WriteLine ("Gender, " + gender);
				sw.WriteLine ("Age, " + age);
				sw.Close ();
			}
		} else {
			Debug.LogError ("ELSE FILE EXISTS"); 
		}

		// Load Experiment Scene
		SceneManager.LoadScene("Traffic", LoadSceneMode.Single); 
			
	}

	// Record lateral displacement and write it to a file.
	public void append_trial_data(string displacement_data) {
		//calculate lateral displacement beofore recording data
		using (StreamWriter sw = File.AppendText (filename)) {
			sw.Write(displacement_data + ", ");
		}
	}


	// Do not delete. 
	// Event system uses functions to set variables. 
	public void set_subjectID(string id) {
		subjectID = id; 
	} 
	void set_gender(string gen) {
		gender = gen;
	}
	void set_age(string num) {
		age = num;
	}



}


