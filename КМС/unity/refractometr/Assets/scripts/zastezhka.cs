using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;


public class zastezhka : MonoBehaviour, IPointerClickHandler
{
    public int zastezhka_val=0;
    public void OnPointerClick(PointerEventData eventData)
    {
        if (state == "Stop")
        {
            if (delta == 0) { state = "Moving"; zastezhka_val = 1; }
            else { state = "MovingBack"; delta = 0; zastezhka_val = 0; }
        }
    }
    string state = "Stop";
    Quaternion startRotation;
    Quaternion needRotation = Quaternion.Euler(45, -45, 0);
    float delta = 0;
    // Start is called before the first frame update
    void Start()
    {
        startRotation = transform.rotation;
    }
    void Update()
    {
        if (state == "Moving")
        {
            transform.rotation = Quaternion.Slerp(startRotation, needRotation, delta);
            delta += 0.01f;
            if (delta >= 1)
            {
                delta = 1;
                state = "Stop";
            }
        }
        if (state == "MovingBack")
        {
            transform.rotation = Quaternion.Slerp(needRotation, startRotation, delta);
            delta += 0.01f;
            if (delta >= 1)
            {
                delta = 0;
                state = "Stop";
            }
        }

    }
}
