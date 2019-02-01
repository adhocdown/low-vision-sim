using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class changeSkybox : MonoBehaviour {

	public Material skybox0;
	public Material skybox1;
	public Material skybox2;
	public Material skybox3;
	public Material skybox4;
	public Material skybox5;
    public Material skybox6;
    public Material skybox7;

    BubbleManager touch_game;
    public GameObject text_object;


    private void Start()
    {
        touch_game = gameObject.GetComponentInChildren<BubbleManager>();
    }

    public void changeMaterial(int num) {
        //string texImage = "";
        

        switch (num) {
		case 0:
			RenderSettings.skybox = skybox0; // text environment
			break;
		case 1:
			RenderSettings.skybox = skybox1; // touch environment 
            break;
		case 2:
			RenderSettings.skybox = skybox2;
			break;
		case 3:
			RenderSettings.skybox = skybox3;
			break;
		case 4:
			RenderSettings.skybox = skybox4;
			break;
		case 5:
			RenderSettings.skybox = skybox5;
			break;
        case 6:
            RenderSettings.skybox = skybox6;
            break;
        case 7:
            RenderSettings.skybox = skybox7;
            break;
        default:
			RenderSettings.skybox = skybox0;
			break;
		}


        switch (num) {
        case 0:
                touch_game.removePrefabs();
                //GameObject textObject = GameObject.Instantiate(text_object, transform.parent);
                //textObject.transform.parent = touch_game.transform; 
                break;
        case 1:
                touch_game.removePrefabs();
                touch_game.spawnPrefabs();
            break;
        default:
                touch_game.removePrefabs();
            break;



    }

}



}
