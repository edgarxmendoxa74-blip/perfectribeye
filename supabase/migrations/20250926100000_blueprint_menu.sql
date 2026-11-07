/*
  # Blueprint Cafe Menu

  Adds Blueprint-specific categories and inserts beverages and food items.

  Categories:
    - beverages (Beverages)
    - coffee-classics (Coffee Classics)
    - specialty-drinks (Specialty Drinks)
    - flavored-lattes (Flavored Lattes)
    - non-coffee (Non-Coffee)
    - hotstuff (Pasta & Main Dishes)
*/

-- Ensure categories exist
INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  ('beverages', 'Beverages', '🍵', 10, true),
  ('coffee-classics', 'Coffee Classics', '☕', 11, true),
  ('specialty-drinks', 'Specialty Drinks', '🥤', 12, true),
  ('flavored-lattes', 'Flavored Lattes', '🥛', 13, true),
  ('non-coffee', 'Non-Coffee', '🧉', 14, true),
  ('hotstuff', 'Pasta & Main Dishes', '🍝', 20, true)
ON CONFLICT (id) DO NOTHING;

-- Helper defaults
-- Use simple descriptions; images can be added later via admin

-- Coffee Classics
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Espresso', 'Rich single-shot espresso', 60, 'coffee-classics', true, true, NULL),
  ('Americano', 'Espresso with hot water', 120, 'coffee-classics', false, true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Specialty Drinks
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Blueprint Special', 'Signature house special', 220, 'specialty-drinks', true, true, NULL),
  ('Amerikano', 'House-style Americano', 220, 'specialty-drinks', false, true, NULL),
  ('Cappuccino', 'Espresso with steamed milk foam', 150, 'specialty-drinks', false, true, NULL),
  ('España', 'Inspired specialty latte', 220, 'specialty-drinks', false, true, NULL),
  ('French Vanilla', 'Vanilla-infused latte', 180, 'specialty-drinks', false, true, NULL),
  ('Oatmilk Latte', 'Creamy oat milk latte', 200, 'specialty-drinks', false, true, NULL),
  ('Caramel Macchiato', 'Espresso with caramel and milk', 180, 'specialty-drinks', true, true, NULL),
  ('Macadamia Oat Latte', 'Oat milk latte with macadamia', 200, 'specialty-drinks', false, true, NULL),
  ('Honey Vanilla Oat Latte', 'Honey-vanilla oat milk latte', 200, 'specialty-drinks', false, true, NULL),
  ('Dirty Matcha', 'Matcha with a shot of espresso', 200, 'specialty-drinks', true, true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Flavored Lattes
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Salted Caramel', 'Salted caramel latte', 200, 'flavored-lattes', false, true, NULL),
  ('White Mocha', 'White chocolate mocha', 200, 'flavored-lattes', false, true, NULL),
  ('Spanish Latte', 'Sweetened Spanish-style latte', 220, 'flavored-lattes', true, true, NULL),
  ('Choco Hazelnut', 'Chocolate and hazelnut latte', 220, 'flavored-lattes', false, true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Non-Coffee
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Iced Shaken Strawberry', 'Refreshing strawberry drink', 150, 'non-coffee', false, true, NULL),
  ('Matcha Latte', 'Premium matcha latte', 180, 'non-coffee', true, true, NULL),
  ('Rich Chocolate', 'Thick chocolate drink', 200, 'non-coffee', false, true, NULL),
  ('Pink Guava', 'Guava cooler', 150, 'non-coffee', false, true, NULL),
  ('Triple Peach', 'Peach trio refresher', 150, 'non-coffee', false, true, NULL),
  ('Black Tea & Pomegranate', 'Tea with pomegranate', 150, 'non-coffee', false, true, NULL),
  ('Apple', 'Chilled apple drink', 150, 'non-coffee', false, true, NULL),
  ('Green Tea-Lychee', 'Lychee green tea', 150, 'non-coffee', false, true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Food: Pasta & Main Dishes (HOTSTUFF)
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Sweet Basil Pomodoro', 'Tomato-basil pasta', 0, 'hotstuff', false, false, NULL),
  ('Lemon Caper Agio E Olio', 'Aglio e olio with lemon and capers', 0, 'hotstuff', false, false, NULL),
  ('Savory Amatriciana Duo', 'Smoky tomato and bacon pasta', 0, 'hotstuff', false, false, NULL),
  ('Creamy Tomato Basil Penne Bliss', 'Creamy tomato-basil penne', 0, 'hotstuff', false, false, NULL),
  ('Five-Cheese Lasagna Indulgence', 'Five-cheese lasagna', 0, 'hotstuff', false, false, NULL),
  ('Carbonara', 'Classic carbonara', 0, 'hotstuff', false, false, NULL),
  ('Truffle Cream Special', 'Truffle cream pasta', 0, 'hotstuff', false, false, NULL)
ON CONFLICT (id) DO NOTHING;


