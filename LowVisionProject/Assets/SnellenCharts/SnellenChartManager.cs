using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnellenChartManager : MonoBehaviour {

    public GameObject SnellenChartPlane;
    public Texture[] textures;
    public int index; 

    public Renderer rend;

    void Start()
    {
        rend = GetComponent<Renderer>();
        index = 0; 
    }


    // Update is called once per frame
    void Update () {

        if (Input.GetKeyDown("space"))
        {
            if (textures.Length == 0)
                return;
            if (index >= textures.Length)
                index = 0; 

            Debug.Log("SnellenChart" + index); 
            rend.material.mainTexture = textures[index];
            index++; 
            

        }
    }
}
