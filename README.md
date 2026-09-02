# 🚀 Pixel Finance — Guide de Déploiement Web (Vercel + Supabase + Google Auth)

Ce dossier contient l'application web complète **Pixel Finance**, prête pour un déploiement instantané sur **Vercel** avec persistance sur **Supabase** et connexion **Google (Gmail)**.

---

## 📦 Contenu du Pack de Déploiement

- `index.html` : Application web complète (Cockpit, Budget, Fiscalité BE/FR, Simulateur FIRE, Timeline, Import, Académie).
- `vercel.json` : Configuration de routage et de sécurité optimisée pour Vercel.
- `supabase_schema.sql` : Script SQL de création des tables (`profiles`, `user_plans`), triggers et sécurité RLS.
- `supabase_config.js` : Configuration des identifiants Supabase.
- `pixel_finance_logo.jpg` : Logo officiel Pixel Finance.

---

## 🛠️ Guide de Mise en Ligne en 3 Étapes Rapides

### ÉTAPE 1 : Configurer votre Base Supabase (2 minutes)
1. Rendez-vous sur [Supabase.com](https://supabase.com) et créez un projet gratuit (ou ouvrez votre projet existant).
2. Dans le menu de gauche, cliquez sur **SQL Editor** puis **New query**.
3. Copiez l'intégralité du contenu du fichier `supabase_schema.sql` et cliquez sur **Run**.
   - *Cela crée les tables `profiles` et `user_plans` avec la sécurité Row Level Security (RLS) active.*
4. Allez dans **Project Settings → API** et copiez :
   - **Project URL** (ex: `https://xyzabcdef.supabase.co`)
   - **Project API Keys → `anon` `public`** (ex: `eyJhbGciOiJIUzI1...`)

---

### ÉTAPE 2 : Activer la Connexion Google (Gmail)
1. Dans votre Dashboard Supabase, allez dans **Authentication → Providers**.
2. Cliquez sur **Google** et basculez l'interrupteur sur **Enable Google provider**.
3. Récupérez votre **Redirect URI** affichée par Supabase (ex: `https://xyzabcdef.supabase.co/auth/v1/callback`).
4. Rendez-vous sur la [Google Cloud Console](https://console.cloud.google.com/) :
   - Créez un projet → **API et services → Écran de consentement OAuth** (User Type: Externe).
   - Allez dans **Identifiants → Créer des identifiants → ID client OAuth** (Application Web).
   - Dans **URIs de redirection autorisés**, collez l'URL de callback de Supabase.
   - Copiez le **Client ID** et le **Client Secret** et collez-les dans Supabase, puis cliquez sur **Save**.

---

### ÉTAPE 3 : Déployer sur Vercel (1 minute)

#### Option A : Déploiement via GitHub & Vercel (Recommandé)
1. Déposez ce dossier `PixelFinance_Web` sur un dépôt GitHub (public ou privé).
2. Rendez-vous sur [Vercel.com](https://vercel.com) et connectez-vous.
3. Cliquez sur **Add New... → Project** et sélectionnez votre dépôt.
4. Cliquez sur **Deploy**. En 15 secondes, votre application est en ligne avec une URL sécurisée en HTTPS !

#### Option B : Déploiement direct avec Vercel CLI
Ouvrez un terminal dans ce dossier et tapez :
```bash
npx vercel
```
Suivez les instructions à l'écran : votre application sera déployée immédiatement.

---

## 🔑 Connexion dans l'Application

Une fois déployé :
1. Ouvrez votre site web Pixel Finance.
2. Cliquez sur **Connexion** (ou sur l'icône de nuage `Local`).
3. Cliquez sur **Configuration Supabase** pour coller votre `Project URL` et votre `Anon Key`.
4. Cliquez sur **Se connecter avec Google (Gmail)** :
   - Votre photo et votre nom s'affichent instantanément.
   - Toutes vos simulations et plans sont sauvegardés dans le Cloud en temps réel.
   - Retrouvez vos données sur votre smartphone, tablette ou ordinateur sans aucune perte !
