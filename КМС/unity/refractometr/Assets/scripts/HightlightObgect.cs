using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HightlightObgect : MonoBehaviour
{
    private Texture defaultTexture;
    public Texture NewTexture;

    // Start is called before the first frame update
    void Start()
    {
        defaultTexture = GetComponent<Renderer>().material.mainTexture;
        //NewTexture = Resources.Load("red") as Texture;
    }

    // Update is called once per frame
    void Update()
    {

    }
    public void ButnEnter()   // надвинули курсор на кнопку
    {
        GetComponent<Renderer>().material.mainTexture = NewTexture;

    }

    public void ButnExit()     // убрали курсор с кнопки
    {
        GetComponent<Renderer>().material.mainTexture = defaultTexture;
    }
}
