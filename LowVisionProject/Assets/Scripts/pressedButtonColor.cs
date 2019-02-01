using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class pressedButtonColor : MonoBehaviour {


    // call this script when buttons are pressed. use the event system.
    ColorBlock activeColors;
    ColorBlock inactiveColors;

    public void Start()
    {
        inactiveColors = ColorBlock.defaultColorBlock; //child.gameObject.GetComponent<Button>().colors;
        activeColors = inactiveColors;
        activeColors.normalColor = Color.cyan;
        activeColors.pressedColor = Color.cyan;
        activeColors.highlightedColor = Color.cyan;

    }


    // send flag to indicate the  current button
    // find child game object that is this index (set pressed = true)
    // all other children (set pressed =  false)
    public void updateButtonColor(int num)
    {
        // for each child - if cur active change color - else set color to white
        foreach (Transform child in transform)
        {
            if (child.transform.GetSiblingIndex() == num) // is active button
            {
                ColorBlock cb = child.gameObject.GetComponent<Button>().colors = activeColors;
                //Debug.Log(child.transform.GetSiblingIndex());
                //cb.normalColor = Color.cyan;

            }
            else // is not active button
            {
                ColorBlock cb = child.gameObject.GetComponent<Button>().colors = inactiveColors;
                //cb.normalColor = Color.white;
            }

        }
    }
    


}
