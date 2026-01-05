-- Allow authenticated users to insert new barbershops
CREATE POLICY "Authenticated users can create barbershops" 
ON public.barbershops 
FOR INSERT 
TO authenticated
WITH CHECK (true);