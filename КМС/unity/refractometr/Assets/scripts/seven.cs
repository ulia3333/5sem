using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class seven : MonoBehaviour, IPointerClickHandler
{
    public int seven_val = 0;
    public void OnPointerClick(PointerEventData eventData)
    {
        if (state == "Stop")
        {
            if (delta == 0) { state = "Moving"; seven_val = 1; }
            else { state = "MovingBack"; delta = 0; seven_val = 0; }
        }
    }
    string state = "Stop";
    Quaternion startRotation;
    Quaternion needRotation = Quaternion.Euler(0, -45, -175);
    float delta = 0;
    // Start is called before the first frame update
    void Start()
    {
        startRotation = transform.rotation;
    }
    
    // Update is called once per frame
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
