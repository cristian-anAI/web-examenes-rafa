import { NavLink, Outlet } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

function AppLayout() {
  const { profile, signOut } = useAuth()

  return (
    <main className="shell">
      <header className="topbar">
        <a className="brand" href="#/">
          <span className="brand-mark">ER</span>
          <span>Examenes Rafa</span>
        </a>
        <div className="user-area">
          <span className="status-dot" />
          <span>{profile?.display_name ?? 'Participante'}</span>
          <button className="sign-out" type="button" onClick={() => void signOut()}>Salir</button>
        </div>
      </header>

      <nav className="nav-tabs" aria-label="Navegacion principal">
        <NavLink to="/" end className={({ isActive }) => (isActive ? 'active' : '')}>Resumen</NavLink>
        <NavLink to="/rankings" className={({ isActive }) => (isActive ? 'active' : '')}>Clasificaciones</NavLink>
        <NavLink to="/cuenta" className={({ isActive }) => (isActive ? 'active' : '')}>Cuenta</NavLink>
      </nav>

      <section className="page-body">
        <Outlet />
      </section>

      <footer>
        <span>web-examenes-rafa</span>
        <span>GitHub Pages + Supabase</span>
      </footer>
    </main>
  )
}

export default AppLayout
