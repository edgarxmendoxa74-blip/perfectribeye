/*
  =====================================================
  THE PERFECT RIBEYE PH - COMPLETE DATABASE SETUP
  =====================================================
  
  Premium Steak Menu with Categories:
  1. Australian Beef
  2. Australian Marbled Striploin  
  3. Australian Ribeye
  4. Japanese Wagyu
  5. USDA / USA Ribeye
  6. Wagyu Cubes

  All prices in Philippine Peso (₱)
  Organized by price: lowest to highest per category
  =====================================================
*/

-- =====================================================
-- STEP 1: Create updated_at trigger function
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- =====================================================
-- STEP 2: Create categories table
-- =====================================================
DROP TABLE IF EXISTS add_ons CASCADE;
DROP TABLE IF EXISTS variations CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

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

DROP POLICY IF EXISTS "Anyone can read categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users can manage categories" ON categories;
DROP POLICY IF EXISTS "Anyone can insert categories" ON categories;
DROP POLICY IF EXISTS "Anyone can update categories" ON categories;
DROP POLICY IF EXISTS "Anyone can delete categories" ON categories;

-- Allow reading all active categories
CREATE POLICY "Anyone can read categories"
  ON categories FOR SELECT TO public
  USING (true);

-- Allow inserting categories from admin panel
CREATE POLICY "Anyone can insert categories"
  ON categories FOR INSERT TO public
  WITH CHECK (true);

-- Allow updating categories from admin panel
CREATE POLICY "Anyone can update categories"
  ON categories FOR UPDATE TO public
  USING (true) WITH CHECK (true);

-- Allow deleting categories from admin panel
CREATE POLICY "Anyone can delete categories"
  ON categories FOR DELETE TO public
  USING (true);

DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert steak categories (organized by menu sections)
INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  ('australian-beef', 'Australian Beef', '🇦🇺', 1, true),
  ('australian-striploin', 'Australian Marbled Striploin', '🥩', 2, true),
  ('australian-ribeye', 'Australian Ribeye', '🇦🇺', 3, true),
  ('japanese-wagyu', 'Japanese Wagyu', '🇯🇵', 4, true),
  ('usda-ribeye', 'USDA / USA Ribeye', '🇺🇸', 5, true),
  ('wagyu-cubes', 'Wagyu Cubes', '🎲', 6, true);

-- =====================================================
-- STEP 3: Create menu_items table
-- =====================================================
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

DROP POLICY IF EXISTS "Anyone can read menu items" ON menu_items;
DROP POLICY IF EXISTS "Authenticated users can manage menu items" ON menu_items;
DROP POLICY IF EXISTS "Anyone can insert menu items" ON menu_items;
DROP POLICY IF EXISTS "Anyone can update menu items" ON menu_items;
DROP POLICY IF EXISTS "Anyone can delete menu items" ON menu_items;

-- Allow reading all menu items
CREATE POLICY "Anyone can read menu items"
  ON menu_items FOR SELECT TO public
  USING (true);

-- Allow inserting menu items from admin panel
CREATE POLICY "Anyone can insert menu items"
  ON menu_items FOR INSERT TO public
  WITH CHECK (true);

-- Allow updating menu items from admin panel
CREATE POLICY "Anyone can update menu items"
  ON menu_items FOR UPDATE TO public
  USING (true) WITH CHECK (true);

-- Allow deleting menu items from admin panel
CREATE POLICY "Anyone can delete menu items"
  ON menu_items FOR DELETE TO public
  USING (true);

DROP TRIGGER IF EXISTS update_menu_items_updated_at ON menu_items;
CREATE TRIGGER update_menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category);
CREATE INDEX IF NOT EXISTS idx_menu_items_base_price ON menu_items(base_price);

-- =====================================================
-- STEP 4: Create variations table
-- =====================================================
CREATE TABLE variations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE variations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read variations" ON variations;
DROP POLICY IF EXISTS "Authenticated users can manage variations" ON variations;
DROP POLICY IF EXISTS "Anyone can insert variations" ON variations;
DROP POLICY IF EXISTS "Anyone can update variations" ON variations;
DROP POLICY IF EXISTS "Anyone can delete variations" ON variations;

-- Allow reading all variations
CREATE POLICY "Anyone can read variations"
  ON variations FOR SELECT TO public
  USING (true);

-- Allow inserting variations from admin panel
CREATE POLICY "Anyone can insert variations"
  ON variations FOR INSERT TO public
  WITH CHECK (true);

-- Allow updating variations from admin panel
CREATE POLICY "Anyone can update variations"
  ON variations FOR UPDATE TO public
  USING (true) WITH CHECK (true);

-- Allow deleting variations from admin panel
CREATE POLICY "Anyone can delete variations"
  ON variations FOR DELETE TO public
  USING (true);

-- =====================================================
-- STEP 5: Create add_ons table
-- =====================================================
CREATE TABLE add_ons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  category text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read add-ons" ON add_ons;
DROP POLICY IF EXISTS "Authenticated users can manage add-ons" ON add_ons;
DROP POLICY IF EXISTS "Anyone can insert add-ons" ON add_ons;
DROP POLICY IF EXISTS "Anyone can update add-ons" ON add_ons;
DROP POLICY IF EXISTS "Anyone can delete add-ons" ON add_ons;

-- Allow reading all add-ons
CREATE POLICY "Anyone can read add-ons"
  ON add_ons FOR SELECT TO public
  USING (true);

-- Allow inserting add-ons from admin panel
CREATE POLICY "Anyone can insert add-ons"
  ON add_ons FOR INSERT TO public
  WITH CHECK (true);

-- Allow updating add-ons from admin panel
CREATE POLICY "Anyone can update add-ons"
  ON add_ons FOR UPDATE TO public
  USING (true) WITH CHECK (true);

-- Allow deleting add-ons from admin panel
CREATE POLICY "Anyone can delete add-ons"
  ON add_ons FOR DELETE TO public
  USING (true);

-- =====================================================
-- STEP 6: Create payment_methods table
-- =====================================================
CREATE TABLE IF NOT EXISTS payment_methods (
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

DROP POLICY IF EXISTS "Anyone can read active payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Authenticated users can manage payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Anyone can read all payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Anyone can insert payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Anyone can update payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Anyone can delete payment methods" ON payment_methods;

-- Allow reading all payment methods (for admin panel to show inactive ones too)
CREATE POLICY "Anyone can read all payment methods"
  ON payment_methods FOR SELECT TO public
  USING (true);

-- Allow inserting payment methods from admin panel
CREATE POLICY "Anyone can insert payment methods"
  ON payment_methods FOR INSERT TO public
  WITH CHECK (true);

-- Allow updating payment methods from admin panel
CREATE POLICY "Anyone can update payment methods"
  ON payment_methods FOR UPDATE TO public
  USING (true) WITH CHECK (true);

-- Allow deleting payment methods from admin panel
CREATE POLICY "Anyone can delete payment methods"
  ON payment_methods FOR DELETE TO public
  USING (true);

DROP TRIGGER IF EXISTS update_payment_methods_updated_at ON payment_methods;
CREATE TRIGGER update_payment_methods_updated_at
  BEFORE UPDATE ON payment_methods
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, sort_order, active) VALUES
  ('gcash', 'GCash', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 1, true),
  ('maya', 'Maya (PayMaya)', '09XX XXX XXXX', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 2, true),
  ('bank-transfer', 'Bank Transfer', 'Account: 1234-5678-9012', 'The Perfect Ribeye PH', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=300&h=300&fit=crop', 3, true),
  ('cod', 'Cash on Delivery', 'Pay upon delivery', 'The Perfect Ribeye PH', 'placeholder', 4, true)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- STEP 7: Create site_settings table
-- =====================================================
CREATE TABLE IF NOT EXISTS site_settings (
  id text PRIMARY KEY,
  value text NOT NULL,
  type text NOT NULL DEFAULT 'text',
  description text,
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read site settings" ON site_settings;
DROP POLICY IF EXISTS "Authenticated users can manage site settings" ON site_settings;

CREATE POLICY "Anyone can read site settings"
  ON site_settings FOR SELECT TO public
  USING (true);

CREATE POLICY "Authenticated users can manage site settings"
  ON site_settings FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

DROP TRIGGER IF EXISTS update_site_settings_updated_at ON site_settings;
CREATE TRIGGER update_site_settings_updated_at
  BEFORE UPDATE ON site_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

INSERT INTO site_settings (id, value, type, description) VALUES
  ('site_name', 'The Perfect Ribeye PH', 'text', 'The name of the restaurant'),
  ('site_logo', '/ThePerfectRibeyePH_logo.jpg', 'image', 'The logo image URL for the site'),
  ('site_description', 'Premium Steaks & Ribeye - The Perfect Ribeye PH', 'text', 'Short description of the restaurant'),
  ('currency', '₱', 'text', 'Currency symbol for prices'),
  ('currency_code', 'PHP', 'text', 'Currency code for payments')
ON CONFLICT (id) DO UPDATE SET value = EXCLUDED.value;

-- =====================================================
-- STEP 8: Create storage bucket for menu images
-- =====================================================
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'menu-images',
  'menu-images',
  true,
  5242880,
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
) ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- STEP 9: INSERT MENU ITEMS (Organized by Category, Price Low to High)
-- =====================================================

-- ═══════════════════════════════════════════════════
-- CATEGORY: AUSTRALIAN BEEF (🇦🇺)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye steak with excellent fat distribution. Rich, buttery flavor perfect for grilling. Sold per kilo.', 1450, 'australian-beef', true, true, '/s4.jpg')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════
-- CATEGORY: AUSTRALIAN MARBLED STRIPLOIN (🥩)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Striploin', 'Premium Australian marbled striploin cut. Tender and flavorful with beautiful marbling throughout. Sold per kilo.', 1450, 'australian-striploin', true, true, '/s1.jpg')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════
-- CATEGORY: AUSTRALIAN RIBEYE (🇦🇺)
-- Price: Low to High (₱1,450 → ₱1,650 → ₱1,999)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('AUS Marbled Ribeye', 'Premium Australian marbled ribeye with excellent marbling. Juicy and flavorful, perfect for any cooking method. Sold per kilo.', 1450, 'australian-ribeye', true, true, '/s4.jpg'),
  ('AUS Giant Marbled Ribeye', 'Extra-large Australian marbled ribeye cut. Perfect for sharing or special occasions. Premium quality with exceptional marbling. Sold per kilo.', 1450, 'australian-ribeye', true, true, '/s6.jpg'),
  ('AUS Artisan Ribeye', 'Artisan-grade Australian ribeye, hand-selected for superior quality. Exceptional tenderness and rich beef flavor. Sold per kilo.', 1650, 'australian-ribeye', false, true, '/s2.jpg'),
  ('Premium Australian Ribeye', 'Top-tier Australian ribeye with wagyu-level marbling. The ultimate steak experience with melt-in-your-mouth texture. Sold per kilo.', 1999, 'australian-ribeye', true, true, '/s8.jpg')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════
-- CATEGORY: JAPANESE WAGYU (🇯🇵)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Japanese Wagyu Cubes', 'Authentic Japanese Wagyu beef cubes. Incredibly marbled with signature buttery texture. Perfect for sukiyaki, yakiniku, or pan-searing. Sold per kilo.', 1250, 'japanese-wagyu', true, true, '/s3.jpg')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════
-- CATEGORY: USDA / USA RIBEYE (🇺🇸)
-- Price: Low to High (₱1,399 → ₱1,450 → ₱1,650 → ₱1,999)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('All Grilled Ribeye', 'Classic USDA grilled ribeye, perfect char and seasoning. A steakhouse favorite at home. Sold per kilo.', 1399, 'usda-ribeye', false, true, '/s5.jpg'),
  ('USDA Ribeye (High Quality)', 'High quality USDA ribeye with excellent fat content. Rich, beefy flavor with perfect marbling. Sold per kilo.', 1399, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USDA Tender Ribeye', 'USDA certified tender ribeye, known for its exceptional tenderness and juicy flavor. A customer favorite. Sold per kilo.', 1399, 'usda-ribeye', true, true, '/s7.jpg'),
  ('USA Ribeye (Mighty Cuts)', 'Premium USA ribeye with mighty large portions. Thick cuts with impressive marbling and bold American beef flavor. Sold per kilo.', 1450, 'usda-ribeye', false, true, '/s6.jpg'),
  ('USA Ribeye', 'Premium USA ribeye with artisan-level quality. Hand-selected for optimal flavor and tenderness. Sold per kilo.', 1650, 'usda-ribeye', false, true, '/s2.jpg'),
  ('USA Ribeye (Wagyu Cuts)', 'Premium USA ribeye featuring wagyu-style cuts. Exceptional marbling rivaling true wagyu beef. Sold per kilo.', 1999, 'usda-ribeye', true, true, '/s8.jpg')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════
-- CATEGORY: WAGYU CUBES (🎲)
-- ═══════════════════════════════════════════════════
INSERT INTO menu_items (name, description, base_price, category, popular, available, image_url) VALUES
  ('Japanese Wagyu Cubes', 'Premium Japanese Wagyu beef cut into perfect cubes. Ideal for hot pot, stir-fry, or teppanyaki. Exceptional marbling and melt-in-your-mouth texture. Sold per kilo.', 1250, 'wagyu-cubes', true, true, '/s3.jpg')
ON CONFLICT DO NOTHING;

-- =====================================================
-- SETUP COMPLETE! 
-- The Perfect Ribeye PH database is now ready.
-- 
-- Categories: 6
-- Menu Items: 14 steaks (organized by price low→high)
-- Payment Methods: 3 (GCash, Maya, Bank Transfer)
-- =====================================================
