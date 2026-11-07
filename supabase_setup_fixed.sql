-- THE PERFECT RIBEYE PH - DATABASE SETUP (fixed, simple policy names)

CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS trigger LANGUAGE plpgsql AS 'BEGIN NEW.updated_at = now(); RETURN NEW; END;';

DROP TABLE IF EXISTS add_ons CASCADE;
DROP TABLE IF EXISTS variations CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- CATEGORIES
CREATE TABLE categories (
  id text PRIMARY KEY,
  name text NOT NULL,
  icon text NOT NULL DEFAULT '🥩',
  sort_order integer NOT NULL DEFAULT 0,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY categories_select ON categories FOR SELECT TO public USING (true);
CREATE POLICY categories_insert ON categories FOR INSERT TO public WITH CHECK (true);
CREATE POLICY categories_update ON categories FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY categories_delete ON categories FOR DELETE TO public USING (true);
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  ('australian-beef', 'Australian Beef', '🇦🇺', 1, true),
  ('australian-striploin', 'Australian Marbled Striploin', '🥩', 2, true),
  ('australian-ribeye', 'Australian Ribeye', '🇦🇺', 3, true),
  ('japanese-wagyu', 'Japanese Wagyu', '🇯🇵', 4, true),
  ('usda-ribeye', 'USDA / USA Ribeye', '🇺🇸', 5, true),
  ('wagyu-cubes', 'Wagyu Cubes', '🎲', 6, true);

-- MENU ITEMS
CREATE TABLE menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  base_price decimal(10,2) NOT NULL,
  category text NOT NULL REFERENCES categories(id),
  popular boolean DEFAULT false,
  available boolean DEFAULT true,
  image_url text,
  discount_price decimal(10,2),
  discount_start_date timestamptz,
  discount_end_date timestamptz,
  discount_active boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY menu_items_select ON menu_items FOR SELECT TO public USING (true);
CREATE POLICY menu_items_insert ON menu_items FOR INSERT TO public WITH CHECK (true);
CREATE POLICY menu_items_update ON menu_items FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY menu_items_delete ON menu_items FOR DELETE TO public USING (true);
CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE INDEX idx_menu_items_category ON menu_items(category);
CREATE INDEX idx_menu_items_base_price ON menu_items(base_price);

-- VARIATIONS
CREATE TABLE variations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE variations ENABLE ROW LEVEL SECURITY;
CREATE POLICY variations_select ON variations FOR SELECT TO public USING (true);
CREATE POLICY variations_insert ON variations FOR INSERT TO public WITH CHECK (true);
CREATE POLICY variations_update ON variations FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY variations_delete ON variations FOR DELETE TO public USING (true);

-- ADD-ONS
CREATE TABLE add_ons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  category text NOT NULL,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;
CREATE POLICY add_ons_select ON add_ons FOR SELECT TO public USING (true);
CREATE POLICY add_ons_insert ON add_ons FOR INSERT TO public WITH CHECK (true);
CREATE POLICY add_ons_update ON add_ons FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY add_ons_delete ON add_ons FOR DELETE TO public USING (true);

-- PAYMENT METHODS
DROP TABLE IF EXISTS payment_methods CASCADE;
CREATE TABLE payment_methods (
  id text PRIMARY KEY,
  name text NOT NULL,
  account_number text NOT NULL,
  account_name text NOT NULL,
  qr_code_url text NOT NULL,
  active boolean DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
CREATE POLICY payment_methods_select ON payment_methods FOR SELECT TO public USING (true);
CREATE POLICY payment_methods_insert ON payment_methods FOR INSERT TO public WITH CHECK (true);
CREATE POLICY payment_methods_update ON payment_methods FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY payment_methods_delete ON payment_methods FOR DELETE TO public USING (true);
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, sort_order, active) VALUES
  ('gcash', 'GCash', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 1, true),
  ('maya', 'Maya (PayMaya)', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 2, true),
  ('bank-transfer', 'Bank Transfer', 'Account: 1234-5678-9012', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 3, true),
  ('cod', 'Cash on Delivery', 'Pay upon delivery', 'The Perfect Ribeye PH', 'placeholder', 4, true);

-- SITE SETTINGS
DROP TABLE IF EXISTS site_settings CASCADE;
CREATE TABLE site_settings (
  id text PRIMARY KEY,
  value text NOT NULL,
  type text NOT NULL DEFAULT 'text',
  description text,
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY site_settings_select ON site_settings FOR SELECT TO public USING (true);
CREATE POLICY site_settings_manage ON site_settings FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO site_settings (id, value, type, description) VALUES
  ('site_name', 'The Perfect Ribeye PH', 'text', 'The name of the restaurant'),
  ('site_logo', '/ThePerfectRibeyePH_logo.jpg', 'image', 'The logo image URL for the site'),
  ('site_description', 'Premium Steaks & Ribeye - The Perfect Ribeye PH', 'text', 'Short description of the restaurant'),
  ('currency', '₱', 'text', 'Currency symbol for prices'),
  ('currency_code', 'PHP', 'text', 'Currency code for payments');

-- STORAGE BUCKET
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('menu-images', 'menu-images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
ON CONFLICT (id) DO NOTHING;

-- MENU ITEMS DATA
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye steak with excellent fat distribution. Rich, buttery flavor perfect for grilling. Sold per kilo.', 1450, 'australian-beef', true, true, '/s4.jpg'),
  ('AUS Marbled Striploin', 'Premium Australian marbled striploin cut. Tender and flavorful with beautiful marbling throughout. Sold per kilo.', 1450, 'australian-striploin', true, true, '/s1.jpg'),
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye with excellent marbling. Juicy and flavorful, perfect for any cooking method. Sold per kilo.', 1450, 'australian-ribeye', true, true, '/s4.jpg'),
  ('AUS Giant Marbled Ribeye', 'Extra-large Australian marbled ribeye cut. Perfect for sharing or special occasions. Premium quality with exceptional marbling. Sold per kilo.', 1450, 'australian-ribeye', true, true, '/s6.jpg'),
  ('AUS Artisan Ribeye', 'Artisan-grade Australian ribeye, hand-selected for superior quality. Exceptional tenderness and rich beef flavor. Sold per kilo.', 1650, 'australian-ribeye', false, true, '/s2.jpg'),
  ('Premium Australian Ribeye', 'Top-tier Australian ribeye with wagyu-level marbling. The ultimate steak experience with melt-in-your-mouth texture. Sold per kilo.', 1999, 'australian-ribeye', true, true, '/s8.jpg'),
  ('Japanese Wagyu Cubes', 'Authentic Japanese Wagyu beef cubes. Incredibly marbled with signature buttery texture. Perfect for sukiyaki, yakiniku, or pan-searing. Sold per kilo.', 1250, 'japanese-wagyu', true, true, '/s3.jpg'),
  ('All Grilled Ribeye', 'Classic USDA grilled ribeye, perfect char and seasoning. A steakhouse favorite at home. Sold per kilo.', 1399, 'usda-ribeye', false, true, '/s5.jpg'),
  ('USDA Ribeye (High Quality)', 'High quality USDA ribeye with excellent fat content. Rich, beefy flavor with perfect marbling. Sold per kilo.', 1399, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USDA Tender Ribeye', 'USDA certified tender ribeye, known for its exceptional tenderness and juicy flavor. A customer favorite. Sold per kilo.', 1399, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USA Ribeye (Mighty Cuts)', 'Premium USA ribeye with mighty large portions. Thick cuts with impressive marbling and bold American beef flavor. Sold per kilo.', 1450, 'usda-ribeye', false, true, '/s6.jpg'),
  ('USA Ribeye', 'Premium USA ribeye with artisan-level quality. Hand-selected for optimal flavor and tenderness. Sold per kilo.', 1650, 'usda-ribeye', false, true, '/s2.jpg'),
  ('USA Ribeye (Wagyu Cuts)', 'Premium USA ribeye featuring wagyu-style cuts. Exceptional marbling rivaling true wagyu beef. Sold per kilo.', 1999, 'usda-ribeye', true, true, '/s8.jpg'),
  ('Japanese Wagyu Cubes', 'Premium Japanese Wagyu beef cut into perfect cubes. Ideal for hot pot, stir-fry, or teppanyaki. Exceptional marbling and melt-in-your-mouth texture. Sold per kilo.', 1250, 'wagyu-cubes', true, true, '/s3.jpg');
