import { useAuth } from '../context/AuthContext'

function AccountPage() {
  const { profile, signOut } = useAuth()

  return (
    <section className="next-panel">
      <p className="eyebrow">Cuenta</p>
      <h2>{profile?.display_name}</h2>
      <p>Usuario: {profile?.username}</p>
      <button className="primary-button" type="button" onClick={() => void signOut()}>Cerrar sesion</button>
    </section>
  )
}

export default AccountPage
