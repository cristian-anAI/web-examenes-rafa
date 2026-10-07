import { useState, type FormEvent } from 'react'
import { Link, Navigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { isSupabaseConfigured } from '../lib/supabaseClient'

function LoginPage() {
  const { session, signIn } = useAuth()
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  if (session) return <Navigate to="/" replace />

  async function handleSubmit(event: FormEvent) {
    event.preventDefault()
    setSubmitting(true)
    setError(null)
    const message = await signIn(username, password)
    setSubmitting(false)
    if (message) setError(message)
  }

  return (
    <main className="shell auth-shell">
      <form className="auth-card" onSubmit={handleSubmit}>
        <p className="eyebrow">Examenes</p>
        <h1>Iniciar sesion</h1>
        {!isSupabaseConfigured && (
          <p className="auth-warning">
            Supabase no esta configurado todavia (faltan VITE_SUPABASE_URL / VITE_SUPABASE_ANON_KEY).
          </p>
        )}
        <label>
          Usuario
          <input
            value={username}
            onChange={(event) => setUsername(event.target.value)}
            autoComplete="username"
            required
          />
        </label>
        <label>
          Contrasena
          <input
            type="password"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            autoComplete="current-password"
            required
          />
        </label>
        {error && <p className="auth-error">{error}</p>}
        <button className="primary-button" type="submit" disabled={submitting || !isSupabaseConfigured}>
          {submitting ? 'Entrando...' : 'Entrar'}
        </button>
        <p className="auth-footnote">
          No tienes cuenta? <Link to="/registro">Registrate aqui</Link>
        </p>
      </form>
    </main>
  )
}

export default LoginPage
