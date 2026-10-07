import { createContext, useContext, useEffect, useState, type ReactNode } from 'react'
import type { Session } from '@supabase/supabase-js'
import { supabase } from '../lib/supabaseClient'
import { usernameToEmail } from '../lib/username'
import type { Profile } from '../types/database'

export interface SignUpInput {
  firstName: string
  lastName: string
  birthDate: string
  username: string
  password: string
  categoryId: string
}

interface AuthContextValue {
  session: Session | null
  profile: Profile | null
  loading: boolean
  signIn: (username: string, password: string) => Promise<string | null>
  signUp: (input: SignUpInput) => Promise<string | null>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!supabase) {
      setLoading(false)
      return
    }

    supabase.auth.getSession().then(({ data }) => setSession(data.session))

    const { data: listener } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      setSession(nextSession)
    })

    return () => listener.subscription.unsubscribe()
  }, [])

  useEffect(() => {
    if (!supabase || !session) {
      setProfile(null)
      setLoading(false)
      return
    }

    let cancelled = false
    setLoading(true)

    supabase
      .from('profiles')
      .select('*')
      .eq('id', session.user.id)
      .single()
      .then(({ data }) => {
        if (!cancelled) {
          setProfile(data ?? null)
          setLoading(false)
        }
      })

    return () => {
      cancelled = true
    }
  }, [session])

  async function signIn(username: string, password: string) {
    if (!supabase) return 'Supabase no esta configurado.'
    const { error } = await supabase.auth.signInWithPassword({
      email: usernameToEmail(username),
      password,
    })
    return error ? 'Usuario o contrasena incorrectos.' : null
  }

  async function signUp(input: SignUpInput) {
    if (!supabase) return 'Supabase no esta configurado.'

    const username = input.username.trim().toLowerCase()
    const { data, error } = await supabase.auth.signUp({
      email: usernameToEmail(username),
      password: input.password,
    })

    if (error) {
      return error.message.toLowerCase().includes('already registered')
        ? 'Ese usuario ya existe, elige otro.'
        : 'No se ha podido crear la cuenta.'
    }

    const userId = data.user?.id
    if (!userId || !data.session) {
      return 'No se ha podido iniciar sesion tras el registro. Contacta con el administrador.'
    }

    const { error: profileError } = await supabase.from('profiles').insert({
      id: userId,
      username,
      display_name: `${input.firstName.trim()} ${input.lastName.trim()}`.trim(),
      first_name: input.firstName.trim(),
      last_name: input.lastName.trim(),
      birth_date: input.birthDate,
      category_id: input.categoryId,
    })

    if (profileError) {
      return 'La cuenta se creo pero no se pudo guardar el perfil. Contacta con el administrador.'
    }

    return null
  }

  async function signOut() {
    if (!supabase) return
    await supabase.auth.signOut()
  }

  return (
    <AuthContext.Provider value={{ session, profile, loading, signIn, signUp, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
