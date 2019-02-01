using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleManager : MonoBehaviour {

    public GameObject[] bubbleArray;
    public GameObject bubbleObject;

    public GameObject audioManager;
    public AudioClip good_ding;

    private IEnumerator coroutine;
    public float radius = 2.0f;
    public float min_pos = 0.5f;
    public float displace_z = 1.0f; 
    public float speed = 1;
    public int num_bubbles = 3;


    // Use this for initialization
    void Start () {
        spawnPrefabs();
    }

    // Update is called once per frame
    void Update () {
		
	}

    public void spawnPrefabs()
    {
        bubbleArray = new GameObject[num_bubbles];
        for (int i = 0; i < num_bubbles; i++)
        {
            // instantiate and make child of current gameobject 
            // targetArray[index] = new target;   
            Vector3 position_in_sphere = changePosition();

            bubbleArray[i] = GameObject.Instantiate(bubbleObject, transform.position, Quaternion.identity);
            bubbleArray[i].transform.parent = transform;
            bubbleArray[i].transform.position = position_in_sphere;

            bubbleArray[i].GetComponent<MeshRenderer>().material.color = new Color(Random.Range(0, 1.0f), Random.Range(0, 1.0f), Random.Range(0, 1.0f), Random.Range(0, 1.0f));                
        }
    }


    public void removePrefabs()
    {
        foreach (Transform child in transform)
            GameObject.Destroy(child.gameObject);
    }

    public Vector3 getNewBubble()
    {
        play_ding();
        return changePosition(); 
    }

    public Vector3 changePosition()
    {
        return new Vector3(Random.Range(-2*radius, 2*radius), Random.Range(min_pos, radius/2), (Random.Range(min_pos, radius)- displace_z));
    }


    public void play_ding()
    {
        audioManager.GetComponent<AudioSource>().PlayOneShot(good_ding, 0.15f);
    }

}
