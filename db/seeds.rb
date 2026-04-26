puts "Seeding database..."

# Demo user
demo_user = User.find_or_create_by!(email: "demo@recipebox.dev") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end

puts "  Created user: #{demo_user.email}"

# Helper: find or create an ingredient by name
def ingredient(name)
  Ingredient.find_or_create_by!(name: name.downcase.strip)
end

# Helper: build a recipe with ingredients and tags
def seed_recipe(user:, title:, description:, instructions:, prep_time:, cook_time:, servings:, tags:, ingredients:)
  recipe = Recipe.find_or_create_by!(title: title, user: user) do |r|
    r.description  = description
    r.instructions = instructions
    r.prep_time    = prep_time
    r.cook_time    = cook_time
    r.servings     = servings
    r.public       = true
  end

  tags.each do |tag_name|
    tag = Tag.find_or_create_by!(name: tag_name.downcase.strip)
    RecipeTag.find_or_create_by!(recipe: recipe, tag: tag)
  end

  ingredients.each do |ing_name, quantity, unit|
    ing = Ingredient.find_or_create_by!(name: ing_name.downcase.strip)
    RecipeIngredient.find_or_create_by!(recipe: recipe, ingredient: ing) do |ri|
      ri.quantity = quantity
      ri.unit     = unit
    end
  end

  recipe
end

recipes = [
  {
    title: "Lemon Garlic Chicken",
    description: "A bright, weeknight-friendly chicken dish with crispy skin and a punchy lemon garlic pan sauce.",
    instructions: "1. Pat chicken thighs dry and season with salt and pepper.\n2. Heat olive oil in a skillet over medium-high heat. Sear chicken skin-side down for 7 minutes until golden.\n3. Flip, add garlic and cook 1 minute.\n4. Add lemon juice and zest. Cook 5 more minutes until cooked through.\n5. Rest 3 minutes before serving.",
    prep_time: 10, cook_time: 20, servings: 4,
    tags: ["quick", "dinner"],
    ingredients: [
      ["chicken thighs", 4, "whole"],
      ["garlic",         4, "clove"],
      ["lemon",          1, "whole"],
      ["olive oil",      2, "tbsp"],
      ["salt",           1, "tsp"],
      ["black pepper",   0.5, "tsp"]
    ]
  },
  {
    title: "Pasta Carbonara",
    description: "Classic Roman carbonara — eggs, parmesan, pancetta, no cream.",
    instructions: "1. Cook pasta until al dente. Reserve 1 cup pasta water.\n2. Fry pancetta in a large pan until crispy. Remove from heat.\n3. Whisk eggs and parmesan together.\n4. Add hot pasta to the pancetta pan. Off heat, pour in egg mixture, tossing quickly.\n5. Add pasta water gradually to achieve a silky sauce. Season with black pepper.",
    prep_time: 10, cook_time: 20, servings: 2,
    tags: ["italian", "dinner"],
    ingredients: [
      ["spaghetti",     200, "g"],
      ["eggs",            2, "whole"],
      ["parmesan",       50, "g"],
      ["pancetta",      100, "g"],
      ["garlic",          1, "clove"],
      ["black pepper",    1, "tsp"]
    ]
  },
  {
    title: "Vegetable Stir Fry",
    description: "Fast, colourful stir fry with a savoury soy-sesame sauce. Ready in 15 minutes.",
    instructions: "1. Heat sesame oil in a wok over high heat.\n2. Add garlic and ginger, stir 30 seconds.\n3. Add broccoli, carrots, and bell pepper. Stir fry 5 minutes.\n4. Add soy sauce and cook 2 more minutes.\n5. Serve immediately over rice.",
    prep_time: 10, cook_time: 10, servings: 2,
    tags: ["vegetarian", "quick", "dinner"],
    ingredients: [
      ["broccoli",    200, "g"],
      ["carrots",       2, "whole"],
      ["bell pepper",   1, "whole"],
      ["soy sauce",     3, "tbsp"],
      ["garlic",        2, "clove"],
      ["sesame oil",    1, "tbsp"],
      ["ginger",        1, "tsp"]
    ]
  },
  {
    title: "Banana Pancakes",
    description: "Fluffy pancakes naturally sweetened with ripe bananas. A weekend morning staple.",
    instructions: "1. Mash bananas in a bowl.\n2. Whisk in eggs, milk, and melted butter.\n3. Fold in flour and baking powder until just combined — lumps are fine.\n4. Heat a non-stick pan over medium heat. Pour 1/4 cup batter per pancake.\n5. Cook 2 minutes per side until golden. Serve with maple syrup.",
    prep_time: 5, cook_time: 15, servings: 4,
    tags: ["vegetarian", "quick", "breakfast"],
    ingredients: [
      ["banana",         2, "whole"],
      ["eggs",           2, "whole"],
      ["flour",          1, "cup"],
      ["milk",         0.5, "cup"],
      ["butter",         2, "tbsp"],
      ["baking powder",  1, "tsp"]
    ]
  },
  {
    title: "Caesar Salad",
    description: "Crisp romaine with a sharp, anchovy-free caesar dressing and homemade croutons.",
    instructions: "1. Toast bread cubes in olive oil until golden. Set aside.\n2. Whisk together lemon juice, garlic, parmesan, and olive oil to make dressing.\n3. Toss romaine with dressing.\n4. Top with croutons and extra parmesan.",
    prep_time: 15, cook_time: 10, servings: 2,
    tags: ["vegetarian", "quick", "lunch"],
    ingredients: [
      ["romaine lettuce", 1, "whole"],
      ["parmesan",       30, "g"],
      ["bread",           2, "slice"],
      ["lemon",           1, "whole"],
      ["garlic",          1, "clove"],
      ["olive oil",       3, "tbsp"]
    ]
  },
  {
    title: "Chicken Tikka Masala",
    description: "Tender chicken in a rich, spiced tomato-cream sauce. Serve with basmati rice or naan.",
    instructions: "1. Marinate chicken in yogurt, garlic, and ginger for at least 30 minutes.\n2. Grill or pan-fry chicken until charred. Set aside.\n3. Sauté onion until soft. Add garlic, ginger, and garam masala.\n4. Add tomatoes and simmer 15 minutes.\n5. Stir in cream and chicken. Simmer 5 minutes. Serve.",
    prep_time: 40, cook_time: 30, servings: 4,
    tags: ["dinner"],
    ingredients: [
      ["chicken breast", 600, "g"],
      ["tomatoes",       400, "g"],
      ["cream",          150, "ml"],
      ["garam masala",     2, "tbsp"],
      ["garlic",           4, "clove"],
      ["ginger",           1, "tbsp"],
      ["onion",            1, "whole"],
      ["yogurt",         100, "g"]
    ]
  },
  {
    title: "Avocado Toast",
    description: "Simple, satisfying avocado toast with lemon, red pepper flakes, and good olive oil.",
    instructions: "1. Toast bread until golden.\n2. Mash avocado with lemon juice and salt.\n3. Spread on toast.\n4. Top with red pepper flakes and a drizzle of olive oil.",
    prep_time: 5, cook_time: 3, servings: 1,
    tags: ["vegetarian", "quick", "breakfast"],
    ingredients: [
      ["bread",             2, "slice"],
      ["avocado",           1, "whole"],
      ["lemon",           0.5, "whole"],
      ["salt",              1, "pinch"],
      ["red pepper flakes", 0.25, "tsp"],
      ["olive oil",         1, "tbsp"]
    ]
  },
  {
    title: "Beef Tacos",
    description: "Crispy-shell tacos with seasoned ground beef and all the classic toppings.",
    instructions: "1. Brown ground beef in a pan. Drain fat.\n2. Add taco seasoning and 1/4 cup water. Simmer 5 minutes.\n3. Warm taco shells.\n4. Fill with beef, cheddar, lettuce, tomato, and sour cream.",
    prep_time: 10, cook_time: 15, servings: 4,
    tags: ["dinner", "quick"],
    ingredients: [
      ["ground beef",    500, "g"],
      ["taco shells",      8, "whole"],
      ["cheddar cheese", 100, "g"],
      ["lettuce",          2, "cup"],
      ["tomato",           2, "whole"],
      ["sour cream",      60, "ml"],
      ["taco seasoning",   2, "tbsp"]
    ]
  },
  {
    title: "Tomato Soup",
    description: "Velvety roasted tomato soup. Better than anything from a can.",
    instructions: "1. Roast tomatoes and onion at 200C for 25 minutes.\n2. Blend with vegetable broth until smooth.\n3. Pour into a pot, add butter and cream.\n4. Simmer 5 minutes. Season with salt and fresh basil.",
    prep_time: 10, cook_time: 35, servings: 4,
    tags: ["vegetarian", "lunch", "dinner"],
    ingredients: [
      ["tomatoes",          800, "g"],
      ["onion",               1, "whole"],
      ["garlic",              3, "clove"],
      ["vegetable broth",   500, "ml"],
      ["cream",             100, "ml"],
      ["butter",              2, "tbsp"],
      ["basil",               1, "tbsp"]
    ]
  },
  {
    title: "Chocolate Chip Cookies",
    description: "Crispy edges, chewy centres. The only chocolate chip cookie recipe you need.",
    instructions: "1. Cream butter and both sugars until pale.\n2. Beat in eggs and vanilla.\n3. Fold in flour, baking soda, and salt.\n4. Stir in chocolate chips.\n5. Scoop onto baking sheets. Bake at 180C for 11 minutes.\n6. Cool on the tray for 5 minutes before eating.",
    prep_time: 15, cook_time: 11, servings: 24,
    tags: ["dessert", "baking"],
    ingredients: [
      ["flour",            2.25, "cup"],
      ["butter",           1,    "cup"],
      ["sugar",            0.75, "cup"],
      ["brown sugar",      0.75, "cup"],
      ["eggs",             2,    "whole"],
      ["vanilla extract",  1,    "tsp"],
      ["chocolate chips",  2,    "cup"],
      ["baking soda",      1,    "tsp"],
      ["salt",             1,    "tsp"]
    ]
  }
]

recipes.each do |data|
  recipe = seed_recipe(user: demo_user, **data)
  puts "  Created recipe: #{recipe.title}"
end

puts "Done. #{Recipe.count} recipes, #{Ingredient.count} ingredients, #{Tag.count} tags."
