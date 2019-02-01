using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class prismEffect : MonoBehaviour {

    private float rotation = 17.0f;


    // Update is called once per frame
    void Update () {
        // Change Image planes (x, y, z) -> (coronal, axial, saggital)
        if (OVRInput.GetDown(OVRInput.Button.Two))
        {
           
            transform.Rotate(0, rotation, 0);
            rotation = -rotation;


        }
    }
}
