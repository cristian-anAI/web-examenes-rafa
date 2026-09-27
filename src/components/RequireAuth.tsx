import { Navigate, Outlet } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

function RequireAuth() {
  const { session, loading } = useAuth()

  if (loading) return <p className="loading-state">Cargando...</p>
  if (!session) return <Navigate to="/login" replace />
  return <Outlet />
}

export default RequireAuth
