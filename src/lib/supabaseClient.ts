import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const isSupabaseConfigured = Boolean(supabaseUrl && supabaseAnonKey)

// Only ever use the anon key here. The service_role key must never reach the browser.
// The generic Database schema (src/types/database.ts) does not map cleanly onto the
// createClient<Database> generics for RPC calls, so query results are cast manually
// at each call site instead.
export const supabase = isSupabaseConfigured ? createClient(supabaseUrl, supabaseAnonKey) : null
