using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class touchColor : MonoBehaviour {


    //private Material m_Material;
    MeshRenderer m_renderer;
    private Color m_color; 

    // Use this for initialization
    void Start () {
        //m_Material = transform.GetComponent<Material>();
        m_renderer = transform.GetComponent<MeshRenderer>();
        //m_color = new Vector4(0.5F, 1, 0.5F, 1); 
        m_color = transform.GetComponent<MeshRenderer>().material.color;
    }

    private void OnTriggerEnter(Collider col)
    {
        //m_renderer.material.color = Color.blue;
    }

    private void OnTriggerExit(Collider col)
    {
       // m_renderer.material.color = m_color;

    }
}


