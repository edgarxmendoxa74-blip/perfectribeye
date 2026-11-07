/*
  Fix "new row violates row-level security policy"

  The admin dashboard uses a local password (not Supabase Auth), so all of its
  writes run as the `anon` role. Policies limited to `authenticated` reject them.
  Open writes for site_settings and the menu-images storage bucket, matching the
  other tables.
*/

-- site_settings
DROP POLICY IF EXISTS "Authenticated users can manage site settings" ON site_settings;
DROP POLICY IF EXISTS site_settings_manage ON site_settings;
DROP POLICY IF EXISTS site_settings_write ON site_settings;
CREATE POLICY site_settings_write ON site_settings FOR ALL TO public USING (true) WITH CHECK (true);

-- storage bucket for menu images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('menu-images', 'menu-images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Authenticated users can upload menu images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update menu images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete menu images" ON storage.objects;
DROP POLICY IF EXISTS "Public read access for menu images" ON storage.objects;
DROP POLICY IF EXISTS menu_images_read ON storage.objects;
DROP POLICY IF EXISTS menu_images_insert ON storage.objects;
DROP POLICY IF EXISTS menu_images_update ON storage.objects;
DROP POLICY IF EXISTS menu_images_delete ON storage.objects;

CREATE POLICY menu_images_read ON storage.objects FOR SELECT TO public USING (bucket_id = 'menu-images');
CREATE POLICY menu_images_insert ON storage.objects FOR INSERT TO public WITH CHECK (bucket_id = 'menu-images');
CREATE POLICY menu_images_update ON storage.objects FOR UPDATE TO public USING (bucket_id = 'menu-images') WITH CHECK (bucket_id = 'menu-images');
CREATE POLICY menu_images_delete ON storage.objects FOR DELETE TO public USING (bucket_id = 'menu-images');

-- categories / payment_methods / menu_items / variations / add_ons: make sure anon can write
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['categories','payment_methods','menu_items','variations','add_ons'] LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', t || '_admin_all', t);
    EXECUTE format('CREATE POLICY %I ON %I FOR ALL TO public USING (true) WITH CHECK (true)', t || '_admin_all', t);
  END LOOP;
END $$;
