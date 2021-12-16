using System;
using System.Collections;
namespace Internship
{
    public class CooksClass
    {
        //private string name;

        //private int number_of_orders;

        public string Name    {get; set;}

        public int Number_of_orders { get; set; }

        public CooksClass(string _name, int number_of_order)
        {
            Name = _name;

            Number_of_orders = number_of_order;

        }
    }

}
