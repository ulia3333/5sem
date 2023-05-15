using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using TMPro;
using UnityEngine.UI;

public class Pipetka : MonoBehaviour, IPointerClickHandler
{
    public int value;
    public GameObject GGO6;
    Vector3 startPosition;
    Vector3 needPosition;
    float offset = 0;
    Quaternion startRotation;
    Quaternion needRotation;
    public GameObject okylar;
    public Texture tex1;
    public Texture tex2;
    public Texture tex3;
    public Texture tex4;
    public Texture tex5;
    public Text message1;
    public Text message2;
    public Text message3;
    public Text message4;
    public Text message5;
    public int Pipetka_val=0;

    void Start()
    {
        startPosition = transform.position;
        startRotation = transform.rotation;
        needPosition = GGO6.transform.position;
        needRotation = GGO6.transform.rotation;
    }
    public void OnPointerClick(PointerEventData eventData)
    {
        if (state == "Stop")
        {
            if (offset == 0) { state = "Moving"; Pipetka_val = 1; }
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
            offset += 0.01f;
            if (offset >= 1)
            {
                if (value == 1)
                {
                    okylar.GetComponent<Renderer>().material.mainTexture=tex1;
                    message1.text = "1,333";
                }
                if (value == 2)
                {
                    okylar.GetComponent<Renderer>().material.mainTexture=tex2;
                    message2.text = "1,336";

                }
                if (value == 3)
                {
                    okylar.GetComponent<Renderer>().material.mainTexture=tex3;
                    message3.text = "1,3385";
                }
                if (value == 4)
                {
                    okylar.GetComponent<Renderer>().material.mainTexture=tex4;
                    message4.text = "1,341";
                }
                if (value == 5)
                {
                    okylar.GetComponent<Renderer>().material.mainTexture=tex5;
                    message5.text = "1,3435";
                }
                offset = 1;
                state = "Stop";
            }
        }
        if (state == "MovingBack")
        {
            transform.rotation = Quaternion.Slerp(needRotation, startRotation, offset);
            transform.position = Vector3.Lerp(needPosition, startPosition, offset);

            offset += 0.01f;
            if (offset >= 1)
            {
                offset = 0;
                state = "Stop";
            }
        }

    }
}
