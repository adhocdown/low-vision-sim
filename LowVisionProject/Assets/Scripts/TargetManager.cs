using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TargetManager : MonoBehaviour {

    public bool isGameInProgress;
    public int rows;
    public int cols;

    public int test_sequence_length;
    public int index_in_sequence;
    public int[] test_sequence; 


    public GameObject[] targetArray;
    public GameObject targetObject;

    //public GameObject gameMenu;
    public GameObject audioManager;
    public AudioClip good_ding;
    public AudioClip bad_ding; 

    private IEnumerator coroutine;

    // For UI Elements
    public Slider rowSlider;
    public Slider colSlider;
    public Slider targetSlider;
    int[] temp_vars;


    // Use this for initialization
    void Start () {
        isGameInProgress = false;
        index_in_sequence = 0;

        spawnPrefabs();
        assignSequence();
        // For UI Elements
        //rowSlider.onValueChanged.AddListener(delegate { RowChangeCheck(); });
        temp_vars = new int[3];
        temp_vars[0] = rows;
        temp_vars[1] = cols;
        temp_vars[2] = test_sequence_length; 

        // get child game object (game menu)
        // gameMenu = transform.GetChild(0).gameObject; 

       
        //rowSlider.onValueChanged.AddListener(delegate { RowChangeCheck(); });
        //colSlider.onValueChanged.AddListener(delegate { ColChangeCheck(); });
        //targetSlider.onValueChanged.AddListener(delegate { TargetChangeCheck(); });
        //rowSlider.onValueChanged.AddListener(RowChangeCheck);
        //RowChangeCheck(rowSlider.value); 
    }


    void spawnPrefabs()
    {
        targetArray = new GameObject[rows * cols];
        for (int y = 0; y < cols; y++)
        {
            for (int x = 0; x < rows; x++)
            {
                int index = x + y * cols;
                // instantiate and make child of current gameobject
                //targetArray[index] = new target;
                targetArray[index] = GameObject.Instantiate(targetObject, new Vector3(x - (rows * 0.5f) + 0.5f, y + 0.5f, transform.position.z), Quaternion.identity);
                targetArray[index].transform.parent = transform;
                targetArray[index].GetComponent<MeshRenderer>().material.color = new Color(1, 1, 1); //new Color(Random.Range(0, 1.0f), Random.Range(0, 1.0f), Random.Range(0, 1.0f), Random.Range(0, 1.0f));                
            }
        }
    }

    // THIS IS NOT CORRECT - FIX IT WHEN NOT EXHAUSTED
    void destroyPrefabs()
    {
        for (int y = 0; y < cols; y++)
        {
            for (int x = 0; x < rows; x++)
            {
                int index = x + y * cols;
                Destroy(targetArray[index]); 
            }
        }
    }

    void assignSequence()
    {
        test_sequence = new int[test_sequence_length];
        for (int i=0; i<test_sequence_length; i++)
        {
            test_sequence[i] = Random.Range(0, ((rows*cols))); 
        }
    }

    IEnumerator PlaySequence(float time)
    {
        for (int i = 0; i < test_sequence_length; i++)
        {
            targetArray[test_sequence[i]].GetComponent<ChangeColor>().changeColorBlue(); //changeColorRandom();
            yield return new WaitForSeconds(time);
            targetArray[test_sequence[i]].GetComponent<ChangeColor>().changeColorWhite();
        }
    }

    public void playerSelectedTargetAccuracy(Vector3 playerSelectedpos) {

        if (index_in_sequence >= (test_sequence_length)) {
            isGameInProgress = false;
            print("game over");
            return; 
        }
            

        Vector3 curTargetpos = targetArray[test_sequence[index_in_sequence]].transform.position; 
        float distance = Vector3.Distance(playerSelectedpos, curTargetpos);
        if (distance == 0)
        {
            targetArray[test_sequence[index_in_sequence]].GetComponent<ChangeColor>().changeColorCorrect(1.0f);
            audioManager.GetComponent<AudioSource>().PlayOneShot(good_ding, 0.7f); 
        }
        else
        {
            int index = Mathf.RoundToInt((playerSelectedpos.x - 0.5f + (rows * 0.5f)) + ((playerSelectedpos.y) - 0.5f) * cols);
            audioManager.GetComponent<AudioSource>().PlayOneShot(bad_ding, 0.7f);

            targetArray[index].GetComponent<ChangeColor>().changeColorError(1.0f);
            targetArray[test_sequence[index_in_sequence]].GetComponent<ChangeColor>().changeColorCorrect(1.0f);
        }
        index_in_sequence += 1;
        if (index_in_sequence == test_sequence_length)
        {
            isGameInProgress = false;
            //gameMenu.SetActive(true);
        }
    }

    // Update is called once per frame
    void Update () {
        if (Input.GetKeyDown(KeyCode.Q) && !isGameInProgress)
        {
            StartGame();
            print("start!");
        }
    }

    // HandUI Functions
    public void StartGame()
    {
        if (!isGameInProgress)
        {
            assignSequence();
            StartCoroutine(PlaySequence(1.0f));
            isGameInProgress = true;
            index_in_sequence = 0;
            // deactivate Menu
            //gameMenu.SetActive(false);
        }
    }


    // Invoked when the value of the slider changes.
    public void RowChangeCheck()
    {
       
        temp_vars[0] = Mathf.RoundToInt(rowSlider.value);         
        rowSlider.GetComponentInChildren<Text>().text = temp_vars[0].ToString() + " Rows";  //.GetComponent<GUIText>().text = ToString(rowSlider.value) + "Rows";
    }
    public void ColChangeCheck()
    {
        temp_vars[1] = Mathf.RoundToInt(colSlider.value);
        colSlider.GetComponentInChildren<Text>().text = temp_vars[1].ToString() + " Cols";  //.GetComponent<GUIText>().text = ToString(rowSlider.value) + "Rows";

    }
    public void TargetChangeCheck()
    {
        temp_vars[2] = Mathf.RoundToInt(targetSlider.value);
        targetSlider.GetComponentInChildren<Text>().text = temp_vars[2].ToString() + " Targets";  //.GetComponent<GUIText>().text = ToString(rowSlider.value) + "Rows";

    }
    public void SetAllVars()
    {
        isGameInProgress = true;
        destroyPrefabs();
        rows = temp_vars[0];
        cols = temp_vars[1];
        test_sequence_length = temp_vars[2];
        spawnPrefabs();
        isGameInProgress = false;

    }

}
