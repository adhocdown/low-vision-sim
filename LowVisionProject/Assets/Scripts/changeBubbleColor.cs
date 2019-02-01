using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class changeBubbleColor : MonoBehaviour {

    


    // if the game has started and the player collides with 
    // a target object, then detect if their selection is correct
    private void OnTriggerEnter(Collider col)
    {
        changeColorRandom();
        //changePosition();
        transform.position = GetComponentInParent<BubbleManager>().getNewBubble();
    }


    public void changeColorRandom()
    {
        transform.GetComponent<MeshRenderer>().material.color = new Color(Random.Range(0, 0.5f), Random.Range(0, 0.5f), Random.Range(0, 0.5f), Random.Range(0.6f, 1.0f));
    }
    
}
