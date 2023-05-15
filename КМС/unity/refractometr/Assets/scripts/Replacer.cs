using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Replacer : MonoBehaviour
{
    bool move = false;
    Vector3 startPosition;
    Vector3 needPosition;
    float speed = 0.006f;
    float offset = 0;
    Quaternion startRotation;
    Quaternion needRotation;
    public GameObject GO10;
    public GameObject GO8;
    public GameObject GO4;
    public GameObject GO6;


    void FixedUpdate()
    {
        // startPosition = transform.position;
        // startRotation = transform.rotation;

        if (move)
        {
            offset += speed;
            transform.position = Vector3.Lerp(startPosition, needPosition, offset);
            transform.rotation = Quaternion.Slerp(startRotation, needRotation, offset);
            if (offset >= 1)
            {
                move = false;
                offset = 0;
            }
        }
    }

    public void MoveToMiro()
    {
        if (!move)
        {
            move = true;
            offset = 0;
            startPosition = transform.position;
            startRotation = transform.rotation;
            needPosition = GO10.transform.position;
            needRotation = GO10.transform.rotation;
        }

    }
    

    public void MoveToZastejka()
    {
        if (!move)
        {
            move = true;
            offset = 0;
            startPosition = transform.position;
            startRotation = transform.rotation;
            needPosition = GO8.transform.position;
            needRotation = GO8.transform.rotation;
        }

    }
    public void MoveToOkular()
    {
        if (!move)
        {
            move = true;
            offset = 0;
            startPosition = transform.position;
            startRotation = transform.rotation;
            needPosition = GO4.transform.position;
            needRotation = GO4.transform.rotation;
        }

    }
    
    public void MoveToprizma()
    {
        if (!move)
        {
            move = true;
            offset = 0;
            startPosition = transform.position;
            startRotation = transform.rotation;
            needPosition = GO6.transform.position;
            needRotation = GO6.transform.rotation;
        }

    }
}