using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class Tasks : MonoBehaviour
{
    public six prizma;
    public zastezhka zastezhka;
    public salfetka salfetka;
    public Pipetka Pipetka1;
    public Pipetka Pipetka2;
    public Pipetka Pipetka3;
    public Pipetka Pipetka4;
    public Pipetka Pipetka5;
    public miror miror;
    public seven seven;
    public Okylar_c Okylar_c;
    public Text message;
    private int val = 0;
    private void Start()
    {
     
    }
    

    public void Task1()      
    {
        
            message.text = "Отстегните застежку и откиньте осветительную призму";
            

    }
    public void Task2()
    {
        if (prizma.six_val == 1 && zastezhka.zastezhka_val == 1)
        {
            message.text = "Протрите призму";
        }
    }
    public void Task3()
    {
        if (salfetka.salfetka_val >= 1) 
        { 

            message.text = "Нанесите раствор на призму";

        }
    }
    public void Task4()
    {
        if (Pipetka1.Pipetka_val == 1 || Pipetka2.Pipetka_val == 1 || Pipetka3.Pipetka_val == 1 || Pipetka4.Pipetka_val == 1 || Pipetka5.Pipetka_val == 1)
        {
            Pipetka1.Pipetka_val = 0;
            Pipetka2.Pipetka_val = 0;
            Pipetka3.Pipetka_val = 0;
            Pipetka4.Pipetka_val = 0;
            Pipetka5.Pipetka_val = 0;
            message.text = "Закройте осветительную призму и застегните застежку";

        }
    }
    public void Task5()
    {
        if (prizma.six_val == 0 && zastezhka.zastezhka_val == 0)
        {
            message.text = "Открыть окно осветительной призмы и зеркало";

        }
    }
    public void Task6()
    {
        if (miror.miror_val == 1 && seven.seven_val == 1)
        {

            message.text = "Получить четкое изображение света и тени в акуляре";
            val=6;

        }
    }
    public void Task7()
    {
        if (val==6)
        {
            message.text = "Измерение зафиксировано в таблице";
            val=7;
        }
    }
    public void Task8()
    {
        if (val == 7)
        {
            message.text = "Закрыть окно осветительной призмы и зеркало";
            val++;

        }
    }
    public void Task9()
    {
        if (miror.miror_val == 0 && seven.seven_val == 0)
        {

            message.text = "Повторить шаги для оставшихся растворов";
            val=0;

        }
    }

}
