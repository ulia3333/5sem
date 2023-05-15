using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Experimental.UIElements;

public class MenuSteps : MonoBehaviour,IPointerClickHandler
{
    public GameObject Panel;
    
    // Start is called before the first frame update
    void Start()
    {
        Panel.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (state == "OpenMenu")
        {
            Panel.SetActive(true);
            position = 1;
            state = "Click";
        }
        if (state == "CloseMenu")
        {
            Panel.SetActive(false);
            position = 0;
            state = "Click";
        }
    }


    string state = "Click";
    float position = 0;


    public void OnPointerClick(PointerEventData eventData)
    {
        if (state == "Click")
        {
            if (position == 0) { state = "OpenMenu"; }
            else { state = "CloseMenu"; position = 0; }
        }
    }
}
