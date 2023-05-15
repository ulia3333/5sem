using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class six : MonoBehaviour, IPointerClickHandler
{
    public int six_val = 0;
    public void OnPointerClick(PointerEventData eventData)
    {
        if(state == "Stop")
        {
            if(delta == 0) { state = "Moving"; six_val = 1; }
            else { state = "MovingBack"; delta = 0; six_val = 0; }
        }
    }
    string state = "Stop";
    Quaternion startRotation;
    Quaternion needRotation = Quaternion.Euler(0, 135, -180);
    float delta = 0;
    // Start is called before the first frame update
    void Start()
    {
        startRotation = transform.rotation;
    }
    public int GetSixVale()
    {
        return six_val;
    }

    //nach:-90  0  -90
    //kon:0 90  -180
    // Update is called once per frame
    void Update()
    {
        if (state == "Moving") {
            transform.rotation = Quaternion.Slerp(startRotation, needRotation, delta);
            delta += 0.01f;
            if(delta >= 1)
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
