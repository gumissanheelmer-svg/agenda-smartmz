-- Ensure buckets exist and are public
INSERT INTO storage.buckets (id, name, public)
VALUES ('logos', 'logos', true)
ON CONFLICT (id) DO UPDATE SET public = true;

INSERT INTO storage.buckets (id, name, public)
VALUES ('backgrounds', 'backgrounds', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Drop existing policies if any (to recreate clean)
DROP POLICY IF EXISTS "Public read logos" ON storage.objects;
DROP POLICY IF EXISTS "Public read backgrounds" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager upload logos" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager upload backgrounds" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager update logos" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager update backgrounds" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager delete logos" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Manager delete backgrounds" ON storage.objects;

-- SELECT (public read) for logos bucket
CREATE POLICY "Public read logos"
ON storage.objects FOR SELECT
USING (bucket_id = 'logos');

-- SELECT (public read) for backgrounds bucket
CREATE POLICY "Public read backgrounds"
ON storage.objects FOR SELECT
USING (bucket_id = 'backgrounds');

-- INSERT for logos bucket (Admin/Manager only, path must start with their barbershop_id)
CREATE POLICY "Admin/Manager upload logos"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'logos'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);

-- INSERT for backgrounds bucket
CREATE POLICY "Admin/Manager upload backgrounds"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'backgrounds'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);

-- UPDATE for logos bucket
CREATE POLICY "Admin/Manager update logos"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'logos'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);

-- UPDATE for backgrounds bucket
CREATE POLICY "Admin/Manager update backgrounds"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'backgrounds'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);

-- DELETE for logos bucket
CREATE POLICY "Admin/Manager delete logos"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'logos'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);

-- DELETE for backgrounds bucket
CREATE POLICY "Admin/Manager delete backgrounds"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'backgrounds'
  AND auth.uid() IS NOT NULL
  AND public.is_admin_or_manager_of_barbershop(auth.uid(), (storage.foldername(name))[1]::uuid)
);