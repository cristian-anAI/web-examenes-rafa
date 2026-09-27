import { Route, Routes } from 'react-router-dom'
import './App.css'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import TestPage from './pages/TestPage'
import RankingsPage from './pages/RankingsPage'
import AccountPage from './pages/AccountPage'
import AppLayout from './layout/AppLayout'
import RequireAuth from './components/RequireAuth'

function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route element={<RequireAuth />}>
        <Route element={<AppLayout />}>
          <Route path="/" element={<DashboardPage />} />
          <Route path="/tests/:testId" element={<TestPage />} />
          <Route path="/rankings" element={<RankingsPage />} />
          <Route path="/cuenta" element={<AccountPage />} />
        </Route>
      </Route>
    </Routes>
  )
}

export default App
