using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Okylar_c : MonoBehaviour
{
    public int Okylar_c_val = 0;
    void Start()
    {
        Close(); 				//  Закрываем окно в момент начала игры. 
    }
    public int value = 0;
    public void OnOpenSettings()
    {
        if (value == 0) //  Открываем всплывающее окно. 
        {
            Open();
        }
        else
        {
            Close();
        }

    }

    public void Open()
    {
        gameObject.SetActive(true);        //   Активируем объект, чтобы открыть окно.  
        value = 1;
        Okylar_c_val = 1;
    }
    public void Close()
    {
        gameObject.SetActive(false);      // Деактивируем объект, чтобы закрыть окно.  
        value = 0;
    }
}
