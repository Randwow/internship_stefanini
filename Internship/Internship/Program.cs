using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Internship
{

    class MainClass
    {
        public static void myMenu() {
            Console.WriteLine("Пожалуйста, выберите опцию");
            Console.WriteLine("1) Добавить блюдо");
            Console.WriteLine("2) Выход");

        }

        public static void Main(string[] args)
        {
            List<CooksClass> some_cooks = new List<CooksClass>();
            some_cooks.Add(new CooksClass("John", 0));
            some_cooks.Add(new CooksClass("Nick", 0));
            some_cooks.Add(new CooksClass("Albert", 0));
            some_cooks.Add(new CooksClass("Stefan", 0));
            some_cooks.Add(new CooksClass("Ion", 0));


            IngredientClass potato = new IngredientClass();
            potato.Name = "Potato";
            potato.Price = 10;
            IngredientClass tomato = new IngredientClass();
            tomato.Name = "Tomato";
            tomato.Price = 15;
            IngredientClass meat = new IngredientClass();
            meat.Name = "Meat";
            meat.Price = 30;
            IngredientClass fish = new IngredientClass();
            fish.Name = "Fish";
            fish.Price = 40;
            IngredientClass paste = new IngredientClass();
            paste.Name = "Paste";
            paste.Price = 20;
            IngredientClass mushrooms = new IngredientClass();
            mushrooms.Name = "Mushrooms";
            mushrooms.Price = 10;

            List<IngredientClass> fried_potatoes = new List<IngredientClass>();
            fried_potatoes.Add(potato);
            List<IngredientClass> paste_with_tomato = new List<IngredientClass>();
            paste_with_tomato.Add(paste);
            paste_with_tomato.Add(tomato);
            List<IngredientClass> meat_with_potatoes = new List<IngredientClass>();
            meat_with_potatoes.Add(meat);
            meat_with_potatoes.Add(potato);
            List<IngredientClass> fish_with_potatoes = new List<IngredientClass>();
            fish_with_potatoes.Add(fish);
            fish_with_potatoes.Add(potato);
            List<IngredientClass> mushrooms_with_potatoes_with_tomato = new List<IngredientClass>();
            mushrooms_with_potatoes_with_tomato.Add(mushrooms);
            mushrooms_with_potatoes_with_tomato.Add(potato);
            mushrooms_with_potatoes_with_tomato.Add(tomato);
            List<IngredientClass> potato_with_fish = new List<IngredientClass>();
            potato_with_fish.Add(potato);
            potato_with_fish.Add(fish);


            List<DishClass> some_dishes = new List<DishClass>();
            some_dishes.Add(new DishClass("Fried Potatoes" , "This is a very tasty dish", 10, fried_potatoes));
            some_dishes.Add(new DishClass("Paste with Tomato", "This is a very tasty dish", 10, paste_with_tomato));
            some_dishes.Add(new DishClass("Meat With Potatoes", "This is a very tasty dish", 10, meat_with_potatoes));
            some_dishes.Add(new DishClass("Fish with Potatoes", "This is a very tasty dish", 10, fish_with_potatoes));
            some_dishes.Add(new DishClass("Mushrooms with Potatoes with Tomato", "This is a very tasty dish", 10, mushrooms_with_potatoes_with_tomato));
            some_dishes.Add(new DishClass("Potato with Fish", "This is a very tasty dish", 10, potato_with_fish));

            foreach (DishClass item in some_dishes)
            {

                Console.WriteLine("Name of dish is " + item._name_of_dish + ", Dish price is " + item._price_of_dish + ", Dish description " + item._description_of_dish + ", Time of cooking " + item._time_of_cooking + ", Ingredients: " + item.get_ingredient_list() + "\n");
            }

            bool cycle_temp = true;
            string name_temp;
            myMenu();
            int temp = Convert.ToInt32(Console.ReadLine());
            while (cycle_temp)
            {
                switch (temp)
                {
                    case 0:

                        myMenu();

                            temp = Convert.ToInt32(Console.ReadLine());
                        break;

                    case 1:

                        bool allSame = some_cooks.All(item => item.Number_of_orders == 5);
                        if (allSame)
                        {
                            Console.WriteLine("К сожалению все повара заняты :(");
                            temp = 0;
                            break;
                        }

                        Console.WriteLine("Пожалуйста, введите блюдо из меню");
                        name_temp = Console.ReadLine();

                        if (!string.IsNullOrEmpty(name_temp) && some_dishes.Exists(item => item._name_of_dish == name_temp))
                        {
                            var min = some_cooks.OrderBy(item => item.Number_of_orders).First();
                            var index = some_cooks.IndexOf(min);
                            some_cooks[index].Number_of_orders++;
                            Console.WriteLine($"Ваше блюдо {name_temp} было передано повару {some_cooks[index].Name} примерное ожидание выполнения блюда = {some_cooks[index].Number_of_orders*10}");
                        }

                        temp = 0;
                        break;

                    case 2:

                        Console.WriteLine("Досвидания");
                        cycle_temp = false;
                        break;
                }
            }
        }
    }
}
