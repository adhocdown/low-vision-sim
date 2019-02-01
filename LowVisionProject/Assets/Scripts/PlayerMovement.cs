using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update()
	{
		var x = Input.GetAxis("Horizontal") * Time.deltaTime * 150.0f;
		var z = Input.GetAxis("Vertical") * Time.deltaTime * 10.0f;

		transform.Rotate(0, x, 0);
		transform.Translate(0, 0, z);

        if (Input.GetKeyDown(KeyCode.Q))
        {
            // change scotoma 

        }

	}
}
