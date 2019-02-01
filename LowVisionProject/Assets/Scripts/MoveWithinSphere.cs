using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveWithinSphere : MonoBehaviour {

    public float radius;
    public float speed;
    public float maxTimeToChangeDirection;
    private float timeToChangeDirection; 
    private float curTime;
    private Vector3 targetLocation; 


    private Vector3 centerPosition;

    // Use this for initialization
    void Start() {
        radius = 4; //radius of *black circle*
        speed = 1;
        maxTimeToChangeDirection = 1.5f; 
        centerPosition = transform.parent.position; //.gameObject.transform.position;         
        timeToChangeDirection = Random.Range(0.5f, maxTimeToChangeDirection); 
        curTime = timeToChangeDirection;
        transform.position = centerPosition +  new Vector3(Random.Range(-radius, radius), Random.Range(-radius, radius), Random.Range(-radius/2, radius/2));
        targetLocation = new Vector3(Random.Range(-radius, radius), Random.Range(-radius, radius), Random.Range(-radius/2, radius/2));

    }

    // Update is called once per frame 
    void Update() {
        //Vector3 newLocation = new Vector3(Mathf.PingPong(Time.time, 8) - 4, Mathf.PingPong(Time.time, 8) - 4, Mathf.PingPong(Time.time, 8) - 4);
        curTime -= Time.deltaTime;

        if (curTime <= 0)
        {
            targetLocation = centerPosition +  new Vector3(Random.Range(-radius, radius), Random.Range(-radius, radius), Random.Range(-radius/2, radius/2));
            curTime = timeToChangeDirection;
        }
        ChangeDirection();


        /*
        rigidbody.velocity = transform.up * 2;

        float distance = Vector3.Distance(transform.position, centerPosition);
        if (distance > radius) //If the distance is less than the radius, it is already within the circle.
        {
            Vector3 fromOriginToObject = newLocation - centerPosition; //~GreenPosition~ - *BlackCenter*
            fromOriginToObject *= radius / distance; //Multiply by radius //Divide by Distance
            newLocation = centerPosition + fromOriginToObject; //*BlackCenter* + all that Math
        }
        */
    }

    private void ChangeDirection()
    {
        float step = speed * Time.deltaTime;
        transform.position = Vector3.MoveTowards(transform.position, targetLocation, step);

    }

    private void ChangeDirection2()
    {
        float angle = Random.Range(0f, 360f);
        Quaternion quat = Quaternion.AngleAxis(angle, Vector3.forward);
        Vector3 newUp = quat * Vector3.up;
        newUp.z = 0;
        newUp.Normalize();
        transform.up = newUp;
        timeToChangeDirection = 1.5f;
    }

}
