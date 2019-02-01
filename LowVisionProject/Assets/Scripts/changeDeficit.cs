using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class changeDeficit : MonoBehaviour
{

    ScotomaOpaqueMask opaque_mask;
    ScotomaBlur blur_mask;
    public int active_mask_mode; // communicate with OnGazeDetection so mask no appear in UI
    public int prev_mask_mode; // communicate with OnGazeDetection so mask no appear in UI

    //public Texture2D maskTexture;


    // Use this for initialization
    void Start()
    {
        opaque_mask = gameObject.GetComponent<ScotomaOpaqueMask>();
        blur_mask = gameObject.GetComponent<ScotomaBlur>();
        active_mask_mode = 0;
        prev_mask_mode = 0; 
    }

    public void changeMask(int num)
    {

        //Texture2D inputTex = (Texture2D)Resources.Load(texImage, typeof(Texture2D));
        //cameraTex = (Texture2D)Resources.Load(texImage, typeof(Texture2D));
        opaque_mask.changeDeficit(num);
        blur_mask.changeDeficit(num);
        //cameraTex = Resources.Load (texImage) as Texture2D;
       // Debug.Log(maskTexture);
    }

    public void activateMaskMode(int num)
    {
        // if 0 - nothing
        // if 1 - blur
        // if 2 - mask
        if (num != 3)
            prev_mask_mode = num;

        active_mask_mode = num;
        opaque_mask.enabled = false;
        blur_mask.enabled = false;
        switch (num)
        {
            case 0:
                opaque_mask.enabled = false;
                blur_mask.enabled = false;
                break;
            case 1:
                opaque_mask.enabled = false;
                blur_mask.enabled = true;
                break;
            case 2:
                opaque_mask.enabled = true;
                blur_mask.enabled = false;
                break;
            default:                
                opaque_mask.enabled = false;
                blur_mask.enabled = false;
                break;
        }
    }

}