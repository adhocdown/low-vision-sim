using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeColor : MonoBehaviour {


    private Color m_color;

    void Start()
    {
        //m_Material = transform.GetComponent<Material>();
        //m_renderer = transform.GetComponent<MeshRenderer>();
        //m_color = new Vector4(0.5F, 1, 0.5F, 1); 
        m_color = transform.GetComponent<MeshRenderer>().material.color;
    }

    public void changeColorOriginal()
    {
        transform.GetComponent<MeshRenderer>().material.color = m_color;
    }

    public void changeColorWhite()
    {
        transform.GetComponent<MeshRenderer>().material.SetColor("_Color", Color.white);
    }

    public void changeColorGreen()
    {
        transform.GetComponent<MeshRenderer>().material.SetColor("_Color", Color.green);
    }

    public void changeColorRed()
    {
        transform.GetComponent<MeshRenderer>().material.SetColor("_Color", Color.red);
    }

    public void changeColorBlue()
    {
        transform.GetComponent<MeshRenderer>().material.SetColor("_Color", Color.blue);
    }

    public void changeColorRandom()
    {
        transform.GetComponent<MeshRenderer>().material.color = new Color(Random.Range(0, 0.5f), Random.Range(0, 0.5f), Random.Range(0, 0.5f), Random.Range(0.6f, 1.0f));
    }



    public void changeColorCorrect(float time)
    {
        StartCoroutine(ShowCorrect(time));
    }

    public void changeColorError(float time)
    {
        StartCoroutine(ShowError(time));
    }

    IEnumerator ShowCorrect(float time)
    {
        changeColorGreen();
        yield return new WaitForSeconds(time);
        changeColorOriginal();
    }

    IEnumerator ShowError(float time)
    {
        changeColorRed();
        yield return new WaitForSeconds(time);
        changeColorOriginal();
    }



}
