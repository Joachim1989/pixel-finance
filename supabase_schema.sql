-- ==============================================================================
-- PIXEL FINANCE — SUPABASE DATABASE SCHEMA & ROW LEVEL SECURITY (RLS)
-- Exécutez ce script dans l'éditeur SQL de votre Dashboard Supabase (SQL Editor)
-- ==============================================================================

-- 1. Table des profils utilisateurs
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    preferred_country TEXT DEFAULT 'BE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Table des plans financiers et simulations
CREATE TABLE IF NOT EXISTS public.user_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_id TEXT NOT NULL,
    plan_name TEXT NOT NULL,
    country TEXT DEFAULT 'BE',
    is_default BOOLEAN DEFAULT false,
    data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_user_plan_id UNIQUE (user_id, plan_id)
);

-- Index pour des requêtes ultra-rapides
CREATE INDEX IF NOT EXISTS idx_user_plans_user_id ON public.user_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_user_plans_plan_id ON public.user_plans(plan_id);

-- 3. Trigger pour créer automatiquement le profil lors de l'inscription (Google Auth ou Email)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, avatar_url)
    VALUES (
        new.id,
        new.email,
        COALESCE(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
        COALESCE(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture', '')
    )
    ON CONFLICT (id) DO UPDATE
    SET
        email = EXCLUDED.email,
        full_name = EXCLUDED.full_name,
        avatar_url = EXCLUDED.avatar_url,
        updated_at = timezone('utc'::text, now());
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Activation du trigger sur auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT OR UPDATE ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. Trigger pour actualiser updated_at sur user_plans
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_user_plans_updated_at ON public.user_plans;
CREATE TRIGGER trigger_user_plans_updated_at
    BEFORE UPDATE ON public.user_plans
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ==============================================================================
-- 5. ROW LEVEL SECURITY (RLS) — Isolation stricte des données par utilisateur
-- ==============================================================================

-- Activation RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_plans ENABLE ROW LEVEL SECURITY;

-- Politiques RLS pour PROFILES
CREATE POLICY "Les utilisateurs peuvent consulter leur propre profil"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Les utilisateurs peuvent mettre a jour leur propre profil"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

-- Politiques RLS pour USER_PLANS
CREATE POLICY "Les utilisateurs peuvent lire leurs propres plans"
    ON public.user_plans FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Les utilisateurs peuvent creer leurs propres plans"
    ON public.user_plans FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Les utilisateurs peuvent modifier leurs propres plans"
    ON public.user_plans FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Les utilisateurs peuvent supprimer leurs propres plans"
    ON public.user_plans FOR DELETE
    USING (auth.uid() = user_id);
