const USERNAME_DOMAIN = 'participants.local'

/** Supabase Auth needs an email; participants only ever type a username. */
export function usernameToEmail(username: string): string {
  return `${username.trim().toLowerCase()}@${USERNAME_DOMAIN}`
}
