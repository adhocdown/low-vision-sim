using UnityEngine;
using System.Collections;

public class TrafficControl : MonoBehaviour {	

	public bool endStream; 
	public GameObject car;                // The car prefab to be spawned.
	public float spawnTime = 1.5f;            // How long between each spawn.
	public Transform[] spawnPoints;         // An array of the spawn points this car can spawn from.


	void Start ()
	{
		// Call the Spawn function after a delay of the spawnTime and then continue to call after the same amount of time.
		endStream = true; 
		InvokeRepeating ("Spawn", spawnTime, spawnTime);
	}


	void Spawn ()
	{
		// If the player has no health left...
		// If flag for end of round = true
		if(endStream == true)
		{
			// ... exit the function.
			return;
		}

		// Find a random index between zero and one less than the number of spawn points.
		int spawnPointIndex = Random.Range (0, spawnPoints.Length);

		// Create an instance of the car prefab at the randomly selected spawn point's position and rotation.
		Instantiate (car, spawnPoints[spawnPointIndex].position, spawnPoints[spawnPointIndex].rotation);
	}
}
