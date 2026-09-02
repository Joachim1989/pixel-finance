// ==============================================================================
// PIXEL FINANCE — CONFIGURATION SUPABASE CLOUD
// Renseignez ci-dessous l'URL de votre projet Supabase et votre clé Publique (Anon).
// Vous pouvez également les configurer directement depuis l'interface de l'application !
// ==============================================================================

window.SUPABASE_CONFIG = {
  // Ex: "https://abcdefghijklmnopqrst.supabase.co"
  SUPABASE_URL: window.localStorage.getItem('pixel_supabase_url') || "",
  
  // Ex: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  SUPABASE_ANON_KEY: window.localStorage.getItem('pixel_supabase_anon_key') || ""
};
