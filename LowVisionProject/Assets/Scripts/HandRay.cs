using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandRay : MonoBehaviour {

    Ray pointer;
    LineRenderer lineRenderer;
    Collider mycollider;
    // Use this for initialization
    void Start () {
       mycollider = transform.GetComponent<Collider>();
        Debug.Log(mycollider.bounds.center);
        pointer = new Ray(transform.position, transform.forward);
        lineRenderer = gameObject.AddComponent<LineRenderer>();
        //lineRenderer.useWorldSpace = false;

        lineRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
        lineRenderer.receiveShadows = false;
        lineRenderer.widthMultiplier = 0.02f;
    }

    // Update is called once per frame
    void Update () {

        RaycastHit hit;        
        pointer = new Ray(mycollider.bounds.center, transform.forward);

       
        
        if (Physics.Raycast(pointer, out hit)) 
        {
            //if (hit.collider != null)
            if (hit.transform.gameObject.layer == 5) // UI
            {
                lineRenderer.enabled = true;
                lineRenderer.SetPosition(0, pointer.origin);
                lineRenderer.SetPosition(1, pointer.origin + pointer.direction * 10.0f);
            }
        }
        else
        {
            lineRenderer.enabled = false; 
        }

    } 


}
