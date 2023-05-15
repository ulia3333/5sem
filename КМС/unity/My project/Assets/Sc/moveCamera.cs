using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class moveCamera : MonoBehaviour
{
    [SerializeField]
    Transform targetPos;
    int sensivity = 2;
    int maxdistance = 90;
    int mindistance = 0;

    //  ФУНКЦИЯ ОГРАНИЧЕНИЯ ПРЕДЕЛОВ ДВИЖЕНИЯ КАМЕРЫ
    bool ControlDistance(float distance)
    {
        if (distance > mindistance && distance < maxdistance) return true;
        return false;
    }

    // ВРАЩЕНИЕ ВОКРУГ ЦЕНТРАЛЬНОЙ ТОЧКИ УСТАНОВКИ С ЗАЖАТОЙ ПРАВОЙ КЛАВИШЕЙ МЫШИ
    void Update()
    {
        if (Input.GetMouseButton(1))
        {
            transform.RotateAround(targetPos.position, Vector3.up, Input.GetAxis("Mouse X") * sensivity);
        }
        // ДВИЖЕНИЯ КАМЕРЫ В СТОРОНЫ КЛАВИШАМИ

        float x = Input.GetAxis("Horizontal");
        if (x != 0)
        {
            Vector3 newpos = transform.position + (transform.TransformDirection(new Vector3(x, 0, 0))) / (sensivity * 2);
            if (ControlDistance(Vector3.Distance(newpos, targetPos.position))) transform.position = newpos;
        }

        // ПРИБЛИЖЕНИЕ И УДАЛЕНИЕ КАМЕРЫ ОТ УСТАНОВКИ ПРОКРУТКОЙ КОЛЕСА МЫШИ
        if (Input.GetAxis("Mouse ScrollWheel") != 0)
        {
            Vector3 newpos = transform.position + transform.TransformDirection(Vector3.forward * Input.GetAxis("Mouse ScrollWheel") * 12);
            if (ControlDistance(Vector3.Distance(newpos, targetPos.position))) transform.position = newpos;
        }

    }
    public void AppExit()
    {
        Application.Quit();
    }
}
