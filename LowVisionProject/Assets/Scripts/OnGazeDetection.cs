using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnGazeDetection : MonoBehaviour {

    Ray pointer;
    changeDeficit[] change_deficits;


    // Use this for initialization
    void Start () {
        pointer = new Ray(transform.position, transform.forward);
        change_deficits = transform.parent.GetComponentsInChildren<changeDeficit>();
        //gameObject.GetComponent<changeDeficit>();
    }

    // Update is called once per frame
    void Update () {
        RaycastHit hit;
        pointer = new Ray(transform.position, transform.forward);

        if (Physics.Raycast(pointer, out hit))
        {
            if (hit.transform.gameObject.layer == 5) // 5 = UI
            {
                // deactivate masks for both eyes
                foreach (changeDeficit component in  change_deficits)                    
                    component.activateMaskMode(3); // 0 = default (trigger temp no mask)
            }
        }
        else
        {
            // activate last active mask mode for both eyes
            if (change_deficits[0].active_mask_mode == 3)
            {
                //change_deficit.activateMaskMode(change_deficit.prev_mask_mode); // 1 = mask, 2 = blur
                foreach (changeDeficit component in change_deficits)
                    component.activateMaskMode(component.prev_mask_mode); // 1 = mask, 2 = blur
            }

        }


    }
}
