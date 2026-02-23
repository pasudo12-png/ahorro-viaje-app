-- =============================================================
-- AHORRO DE VIAJE ENTRE AMIGOS
-- Script SQL para Supabase
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- =============================================================

-- ----------------------------------------------------------------
-- 1. TABLAS
-- ----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS trips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  destination TEXT NOT NULL,
  currency TEXT NOT NULL DEFAULT 'COP',
  target_amount NUMERIC,
  trip_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS travelers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contributions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  traveler_id UUID NOT NULL REFERENCES travelers(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL CHECK (amount > 0),
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- 2. ROW LEVEL SECURITY (RLS)
-- ----------------------------------------------------------------

ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE travelers ENABLE ROW LEVEL SECURITY;
ALTER TABLE contributions ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------
-- 2a. TRIPS
-- ----------------------------------------------------------------

-- Lectura pública: cualquiera puede leer (para el link compartido)
CREATE POLICY "trips_public_read"
  ON trips FOR SELECT
  USING (true);

-- Solo usuarios autenticados pueden insertar
CREATE POLICY "trips_auth_insert"
  ON trips FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Solo usuarios autenticados pueden actualizar
CREATE POLICY "trips_auth_update"
  ON trips FOR UPDATE
  USING (auth.role() = 'authenticated');

-- Solo usuarios autenticados pueden eliminar
CREATE POLICY "trips_auth_delete"
  ON trips FOR DELETE
  USING (auth.role() = 'authenticated');

-- ----------------------------------------------------------------
-- 2b. TRAVELERS
-- ----------------------------------------------------------------

CREATE POLICY "travelers_public_read"
  ON travelers FOR SELECT
  USING (true);

CREATE POLICY "travelers_auth_insert"
  ON travelers FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "travelers_auth_update"
  ON travelers FOR UPDATE
  USING (auth.role() = 'authenticated');

CREATE POLICY "travelers_auth_delete"
  ON travelers FOR DELETE
  USING (auth.role() = 'authenticated');

-- ----------------------------------------------------------------
-- 2c. CONTRIBUTIONS
-- ----------------------------------------------------------------

CREATE POLICY "contributions_public_read"
  ON contributions FOR SELECT
  USING (true);

CREATE POLICY "contributions_auth_insert"
  ON contributions FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "contributions_auth_update"
  ON contributions FOR UPDATE
  USING (auth.role() = 'authenticated');

CREATE POLICY "contributions_auth_delete"
  ON contributions FOR DELETE
  USING (auth.role() = 'authenticated');

-- ----------------------------------------------------------------
-- FIN DEL SCRIPT
-- ----------------------------------------------------------------
-- Ahora ve a Authentication > Users en Supabase y crea
-- el usuario administrador manualmente con email y contraseña.
-- ----------------------------------------------------------------
