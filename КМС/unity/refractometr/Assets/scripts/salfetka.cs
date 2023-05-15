using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;


public class salfetka : MonoBehaviour, IPointerClickHandler
{
  
    public GameObject GGGO6;
    Vector3 startPosition;
    Vector3 needPosition;
    float offset = 0;
    Quaternion startRotation;
    Quaternion needRotation;
    public int salfetka_val=0;


    void Start()
    {
        startPosition = transform.position;
        startRotation = transform.rotation;
        needPosition = GGGO6.transform.position;
        needRotation = GGGO6.transform.rotation;
    }
    public void OnPointerClick(PointerEventData eventData)
    {
        if (state == "Stop")
        {
            if (offset == 0) { state = "Moving"; salfetka_val++; }
            else { state = "MovingBack"; offset = 0; }
        }
    }
    string state = "Stop";

    void Update()
    {
        if (state == "Moving")
        {
            transform.rotation = Quaternion.Slerp(startRotation, needRotation, offset);
            transform.position = Vector3.Lerp(startPosition, needPosition, offset);
            offset += 0.05f;
            if (offset >= 1)
            {
                offset = 1;
                state = "Stop";
            }
        }
        if (state == "MovingBack")
        {
            transform.rotation = Quaternion.Slerp(needRotation, startRotation, offset);
            transform.position = Vector3.Lerp(needPosition, startPosition, offset);

            offset += 0.05f;
            if (offset >= 1)
            {
                offset = 0;
                state = "Stop";
            }
        }

    }
}