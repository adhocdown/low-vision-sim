using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerInput : MonoBehaviour
{
    //private screenManager so; // for changes to screens
    //public int plane_index; 

    public float scaleFactor; // 0.01
    public float minScale;  //0.3
    public float maxScale;  //4

    private int lengthOfLineRenderer = 2;

    Vector3[] anchorPoints;
    Vector3[] curPoints;

    public GameObject menu;
    private bool isActive;

    // Use this for initialization
    void Start()
    {
        menu = GameObject.FindGameObjectWithTag("Menu");
        isActive = true;

        anchorPoints = new Vector3[lengthOfLineRenderer];
        curPoints = new Vector3[lengthOfLineRenderer]; // 2
        //plane_index = 3;
    }

    // Update is called once per frame
    void Update()
    {

        Vector3 LHandPos = transform.position + OVRInput.GetLocalControllerPosition(OVRInput.Controller.LTouch);
        Vector3 RHandPos = transform.position + OVRInput.GetLocalControllerPosition(OVRInput.Controller.RTouch);

        // Draw line between trigger buttons
        // scale player using difference between initial distance between controllers
        // and end distance between controllers
        //if (OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.LTouch) > 0 &&
        //            OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.RTouch) > 0) {
        //    curPoints[0] = LHandPos;
        //    curPoints[1] = RHandPos;
        //    scalePlayer(anchorPoints, curPoints);
        //else {
        //    anchorPoints[0] = LHandPos;
        //    anchorPoints[1] = RHandPos;
        //}
        if (OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.LTouch) > 0 ||
                    OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.RTouch) > 0) 
        {
            //Input.GetMouseButtonDown(0); 
        }


        // Change Image planes (x, y, z) -> (coronal, axial, saggital)
        if (OVRInput.GetDown(OVRInput.Button.Two))
        {
            isActive = !isActive;
            menu.SetActive(isActive);

        }



    }

    void scalePlayer(Vector3[] initPos, Vector3[] endPos)
    {
        float initDistance = Vector3.Distance(initPos[1], initPos[0]);
        float endDistance = Vector3.Distance(endPos[1], endPos[0]);

        float scaleValue = (endDistance - initDistance) / initDistance;
        Vector3 scaleVector = new Vector3(scaleValue, scaleValue, scaleValue) * -scaleFactor;

        if (transform.localScale.x + scaleVector.x >= minScale
            && transform.localScale.x + scaleVector.x <= maxScale)
            transform.localScale = transform.localScale + scaleVector;

        //print("scaleVector:" + scaleVector + "localScale: " + transform.localScale );
    }
  
}
