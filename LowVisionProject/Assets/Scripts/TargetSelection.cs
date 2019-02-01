using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetSelection : MonoBehaviour {

    public TargetManager targetManager; 


	// Use this for initialization
	void Start () {
        GameObject tm_object = GameObject.Find("TargetManager");
        targetManager = (TargetManager)tm_object.GetComponent(typeof(TargetManager));
    }


    // if the game has started and the player collides with 
    // a target object, then detect if their selection is correct
    private void OnTriggerEnter(Collider col)
    {
        /*
       if(targetManager.isGameInProgress && col.tag == "Target")
        {
            targetManager.playerSelectedTargetAccuracy(col.transform.position);
        }
        */
    }



}
