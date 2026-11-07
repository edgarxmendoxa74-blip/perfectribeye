-- ==============================================================================
-- THE PERFECT RIBEYE PH - COMPLETE DATABASE & ADMIN DASHBOARD SETUP
-- ==============================================================================

-- 1. TRIGGER FUNCTION FOR UPDATED_AT TIMESTAMP
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. DROP EXISTING TABLES IF ANY
DROP TABLE IF EXISTS add_ons CASCADE;
DROP TABLE IF EXISTS variations CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS site_settings CASCADE;

-- ==============================================================================
-- CATEGORIES TABLE
-- ==============================================================================
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

CREATE POLICY "categories_select_policy" ON categories FOR SELECT TO public USING (true);
CREATE POLICY "categories_insert_policy" ON categories FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "categories_update_policy" ON categories FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "categories_delete_policy" ON categories FOR DELETE TO public USING (true);

CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- SEED CATEGORIES
INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  ('australian-beef', 'Australian Beef', '🇦🇺', 1, true),
  ('australian-striploin', 'Australian Marbled Striploin', '🥩', 2, true),
  ('australian-ribeye', 'Australian Ribeye', '🇦🇺', 3, true),
  ('japanese-wagyu', 'Japanese Wagyu', '🇯🇵', 4, true),
  ('usda-ribeye', 'USDA / USA Ribeye', '🇺🇸', 5, true),
  ('wagyu-cubes', 'Wagyu Cubes', '🎲', 6, true);

-- ==============================================================================
-- MENU ITEMS TABLE
-- ==============================================================================
CREATE TABLE menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  base_price decimal(10,2) NOT NULL,
  category text NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
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

CREATE POLICY "menu_items_select_policy" ON menu_items FOR SELECT TO public USING (true);
CREATE POLICY "menu_items_insert_policy" ON menu_items FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "menu_items_update_policy" ON menu_items FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "menu_items_delete_policy" ON menu_items FOR DELETE TO public USING (true);

CREATE TRIGGER update_menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_menu_items_category ON menu_items(category);
CREATE INDEX idx_menu_items_base_price ON menu_items(base_price);

-- ==============================================================================
-- VARIATIONS TABLE (e.g. Cuts, Thickness, Weight)
-- ==============================================================================
CREATE TABLE variations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE variations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "variations_select_policy" ON variations FOR SELECT TO public USING (true);
CREATE POLICY "variations_insert_policy" ON variations FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "variations_update_policy" ON variations FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "variations_delete_policy" ON variations FOR DELETE TO public USING (true);

-- ==============================================================================
-- ADD-ONS TABLE (e.g. Butter, Sauces, Sides)
-- ==============================================================================
CREATE TABLE add_ons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  category text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "add_ons_select_policy" ON add_ons FOR SELECT TO public USING (true);
CREATE POLICY "add_ons_insert_policy" ON add_ons FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "add_ons_update_policy" ON add_ons FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "add_ons_delete_policy" ON add_ons FOR DELETE TO public USING (true);

-- ==============================================================================
-- PAYMENT METHODS TABLE
-- ==============================================================================
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

CREATE POLICY "payment_methods_select_policy" ON payment_methods FOR SELECT TO public USING (true);
CREATE POLICY "payment_methods_insert_policy" ON payment_methods FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "payment_methods_update_policy" ON payment_methods FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "payment_methods_delete_policy" ON payment_methods FOR DELETE TO public USING (true);

CREATE TRIGGER update_payment_methods_updated_at
  BEFORE UPDATE ON payment_methods
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- SEED PAYMENT METHODS
INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, sort_order, active) VALUES
  ('gcash', 'GCash', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 1, true),
  ('maya', 'Maya (PayMaya)', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 2, true),
  ('bank-transfer', 'Bank Transfer', 'Account: 1234-5678-9012', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 3, true),
  ('cod', 'Cash on Delivery', 'Pay upon delivery', 'The Perfect Ribeye PH', 'placeholder', 4, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  account_number = EXCLUDED.account_number,
  account_name = EXCLUDED.account_name,
  qr_code_url = EXCLUDED.qr_code_url,
  active = EXCLUDED.active,
  sort_order = EXCLUDED.sort_order;

-- ==============================================================================
-- SITE SETTINGS TABLE
-- ==============================================================================
CREATE TABLE site_settings (
  id text PRIMARY KEY,
  value text NOT NULL,
  type text NOT NULL DEFAULT 'text',
  description text,
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "site_settings_select_policy" ON site_settings FOR SELECT TO public USING (true);
CREATE POLICY "site_settings_insert_policy" ON site_settings FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "site_settings_update_policy" ON site_settings FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "site_settings_delete_policy" ON site_settings FOR DELETE TO public USING (true);

CREATE TRIGGER update_site_settings_updated_at
  BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- SEED SITE SETTINGS
INSERT INTO site_settings (id, value, type, description) VALUES
  ('site_name', 'The Perfect Ribeye PH', 'text', 'The name of the restaurant'),
  ('site_logo', '/ThePerfectRibeyePH_logo.jpg', 'image', 'The logo image URL for the site'),
  ('site_description', 'Premium Steaks & Ribeye - The Perfect Ribeye PH', 'text', 'Short description of the restaurant'),
  ('currency', '₱', 'text', 'Currency symbol for prices'),
  ('currency_code', 'PHP', 'text', 'Currency code for payments')
ON CONFLICT (id) DO UPDATE SET value = EXCLUDED.value;

-- ==============================================================================
-- STORAGE BUCKET & POLICIES (For Image Uploads in Admin Dashboard)
-- ==============================================================================
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'menu-images',
  'menu-images',
  true,
  5242880,
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO UPDATE SET public = true;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Public Access for menu-images'
  ) THEN
    CREATE POLICY "Public Access for menu-images" ON storage.objects
      FOR SELECT TO public USING (bucket_id = 'menu-images');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Public Upload for menu-images'
  ) THEN
    CREATE POLICY "Public Upload for menu-images" ON storage.objects
      FOR INSERT TO public WITH CHECK (bucket_id = 'menu-images');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Public Update for menu-images'
  ) THEN
    CREATE POLICY "Public Update for menu-images" ON storage.objects
      FOR UPDATE TO public USING (bucket_id = 'menu-images');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Public Delete for menu-images'
  ) THEN
    CREATE POLICY "Public Delete for menu-images" ON storage.objects
      FOR DELETE TO public USING (bucket_id = 'menu-images');
  END IF;
END $$;

-- ==============================================================================
-- SEED STEAK MENU ITEMS (Organized by Category, Price Low to High)
-- ==============================================================================

-- 1. AUSTRALIAN BEEF
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye steak with excellent fat distribution. Rich, buttery flavor perfect for grilling. Sold per kilo.', 1450.00, 'australian-beef', true, true, '/s4.jpg');

-- 2. AUSTRALIAN MARBLED STRIPLOIN
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Striploin', 'Premium Australian marbled striploin cut. Tender and flavorful with beautiful marbling throughout. Sold per kilo.', 1450.00, 'australian-striploin', true, true, '/s1.jpg');

-- 3. AUSTRALIAN RIBEYE
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye with excellent marbling. Juicy and flavorful, perfect for any cooking method. Sold per kilo.', 1450.00, 'australian-ribeye', true, true, '/s4.jpg'),
  ('AUS Giant Marbled Ribeye', 'Extra-large Australian marbled ribeye cut. Perfect for sharing or special occasions. Premium quality with exceptional marbling. Sold per kilo.', 1450.00, 'australian-ribeye', true, true, '/s6.jpg'),
  ('AUS Artisan Ribeye', 'Artisan-grade Australian ribeye, hand-selected for superior quality. Exceptional tenderness and rich beef flavor. Sold per kilo.', 1650.00, 'australian-ribeye', false, true, '/s2.jpg'),
  ('Premium Australian Ribeye', 'Top-tier Australian ribeye with wagyu-level marbling. The ultimate steak experience with melt-in-your-mouth texture. Sold per kilo.', 1999.00, 'australian-ribeye', true, true, '/s8.jpg');

-- 4. JAPANESE WAGYU
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Japanese Wagyu Cubes', 'Authentic Japanese Wagyu beef cubes. Incredibly marbled with signature buttery texture. Perfect for sukiyaki, yakiniku, or pan-searing. Sold per kilo.', 1250.00, 'japanese-wagyu', true, true, '/s3.jpg');

-- 5. USDA / USA RIBEYE
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('All Grilled Ribeye', 'Classic USDA grilled ribeye, perfect char and seasoning. A steakhouse favorite at home. Sold per kilo.', 1399.00, 'usda-ribeye', false, true, '/s5.jpg'),
  ('USDA Ribeye (High Quality)', 'High quality USDA ribeye with excellent fat content. Rich, beefy flavor with perfect marbling. Sold per kilo.', 1399.00, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USDA Tender Ribeye', 'USDA certified tender ribeye, known for its exceptional tenderness and juicy flavor. A customer favorite. Sold per kilo.', 1399.00, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USA Ribeye (Mighty Cuts)', 'Premium USA ribeye with mighty large portions. Thick cuts with impressive marbling and bold American beef flavor. Sold per kilo.', 1450.00, 'usda-ribeye', false, true, '/s6.jpg'),
  ('USA Ribeye', 'Premium USA ribeye with artisan-level quality. Hand-selected for optimal flavor and tenderness. Sold per kilo.', 1650.00, 'usda-ribeye', false, true, '/s2.jpg'),
  ('USA Ribeye (Wagyu Cuts)', 'Premium USA ribeye featuring wagyu-style cuts. Exceptional marbling rivaling true wagyu beef. Sold per kilo.', 1999.00, 'usda-ribeye', true, true, '/s8.jpg');

-- 6. WAGYU CUBES
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Japanese Wagyu Cubes', 'Premium Japanese Wagyu beef cut into perfect cubes. Ideal for hot pot, stir-fry, or teppanyaki. Exceptional marbling and melt-in-your-mouth texture. Sold per kilo.', 1250.00, 'wagyu-cubes', true, true, '/s3.jpg');

-- ==============================================================================
-- OPTIONAL SEED: SAMPLE VARIATIONS & ADD-ONS FOR RIBEYE STEAKS
-- ==============================================================================
-- Add thickness / weight variations to AUS Marbled Ribeye
INSERT INTO variations (menu_item_id, name, price)
SELECT id, '500g Cut', 0.00 FROM menu_items WHERE name = 'AUS Marbled Ribeye' AND category = 'australian-ribeye' LIMIT 1;

INSERT INTO variations (menu_item_id, name, price)
SELECT id, '1kg Cut', 0.00 FROM menu_items WHERE name = 'AUS Marbled Ribeye' AND category = 'australian-ribeye' LIMIT 1;

-- Add butter / sauce add-ons to Australian Ribeye
INSERT INTO add_ons (menu_item_id, name, price, category)
SELECT id, 'Truffle Butter', 120.00, 'Butter' FROM menu_items WHERE name = 'AUS Marbled Ribeye' AND category = 'australian-ribeye' LIMIT 1;

INSERT INTO add_ons (menu_item_id, name, price, category)
SELECT id, 'Red Wine Demi-Glace Sauce', 95.00, 'Sauces' FROM menu_items WHERE name = 'AUS Marbled Ribeye' AND category = 'australian-ribeye' LIMIT 1;

