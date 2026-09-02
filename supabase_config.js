// ==============================================================================
// PIXEL FINANCE — CONFIGURATION SUPABASE CLOUD
// Renseignez ci-dessous l'URL de votre projet Supabase et votre clé Publique (Anon).
// ==============================================================================

window.SUPABASE_CONFIG = {
  // URL de base de votre projet Supabase (sans /rest/v1 à la fin)
  SUPABASE_URL: window.localStorage.getItem('pixel_supabase_url') || "https://kxbxdcacgbnytggpafre.supabase.co",
  
  // Votre clé publique Anon Supabase
  SUPABASE_ANON_KEY: window.localStorage.getItem('pixel_supabase_anon_key') || ""
};
