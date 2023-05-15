using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class PanelMove : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    RectTransform UIGameobject;                      // трансформация UI Панели
    float width;                                                        // ширина панели
    float changeX;                                                   // смещение панели
    float speedPanel;                                             // скорость закрытия панели

    enum states
    {                                             // перечисление состояний панели
        open,                                                        //открыта
        close,                                                        //закрыта
        opening,                                                  //открывается
        closing                                                     //закрывается
    }
    states state = states.open;                         // изначальное состояние закрытое

    void Start()
    {                                                  //инициализация переменных
        UIGameobject = gameObject.GetComponent<RectTransform>();    // объект панели
        width = UIGameobject.sizeDelta.x;         // определение ширины панели
        speedPanel = 8;                                           // скорость движения панели 
    }
    void Update()
    {
        if (state == states.closing)
        {
            float x = UIGameobject.anchoredPosition.x;
            float y = UIGameobject.anchoredPosition.y;
            x += speedPanel;
            changeX += speedPanel;
            UIGameobject.anchoredPosition = new Vector2(x, y);
            if (changeX > width)
            {
                state = states.close;
                changeX = 0;
            }
        }
        if (state == states.opening)
        {
            float x = UIGameobject.anchoredPosition.x;
            float y = UIGameobject.anchoredPosition.y;
            x -= speedPanel;
            changeX += speedPanel;
            UIGameobject.anchoredPosition = new Vector2(x, y);
            if (changeX > width)
            {
                state = states.open;
                changeX = 0;
            }

        }
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (state == states.close) state = states.opening;
    }
    public void OnPointerExit(PointerEventData eventData)
    {
        if (state == states.open) state = states.closing;
    }
}

