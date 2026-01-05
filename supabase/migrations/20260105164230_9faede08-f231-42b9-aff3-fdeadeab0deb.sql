-- Create a SECURITY DEFINER function to create barbershops
-- This bypasses RLS and allows registration to work
CREATE OR REPLACE FUNCTION public.create_barbershop(
  p_name TEXT,
  p_slug TEXT,
  p_whatsapp_number TEXT DEFAULT NULL,
  p_logo_url TEXT DEFAULT NULL,
  p_primary_color TEXT DEFAULT '#D4AF37',
  p_secondary_color TEXT DEFAULT '#1a1a2e',
  p_background_color TEXT DEFAULT '#0f0f1a',
  p_text_color TEXT DEFAULT '#ffffff',
  p_owner_email TEXT DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_id uuid;
BEGIN
  -- Insert the barbershop
  INSERT INTO public.barbershops (
    name,
    slug,
    whatsapp_number,
    logo_url,
    primary_color,
    secondary_color,
    background_color,
    text_color,
    active,
    approval_status,
    owner_email
  ) VALUES (
    p_name,
    p_slug,
    p_whatsapp_number,
    p_logo_url,
    p_primary_color,
    p_secondary_color,
    p_background_color,
    p_text_color,
    false,
    'pending',
    p_owner_email
  )
  RETURNING id INTO new_id;
  
  RETURN new_id;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.create_barbershop TO authenticated;