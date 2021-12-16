using System;
using System.Collections.Generic;

namespace Internship
{
    public class DishClass
    {
        //private string name_of_dish;

        //private double price_of_dish;

        //private string description_of_dish;

        //private int time_of_cooking;

        //private List<IngredientClass> Ingredients;

        public string _name_of_dish { get; set; }

        public double _price_of_dish { get; set; }

        public string _description_of_dish{ get; set; }

        public int _time_of_cooking{ get; set; }

        public List<IngredientClass> _Ingredients { get; set; }


        public DishClass(string _name, string _description, int _time, List<IngredientClass> _Ingredient_List )
        {
            double total_price = 0;
            _name_of_dish = _name;
            _description_of_dish = _description;
            _time_of_cooking = _time;
            _Ingredients = _Ingredient_List;
            foreach (var item in _Ingredient_List) {

                total_price += item.Price; 
            }
            _price_of_dish = total_price * 1.2;
        }

        public string get_ingredient_list() {
            string name_ing= "";
            foreach (var item in _Ingredients) {
                name_ing = name_ing + item.Name + ", ";
            }
            name_ing = name_ing.Remove(name_ing.Length - 2);
            return name_ing;
        }
    }
}
