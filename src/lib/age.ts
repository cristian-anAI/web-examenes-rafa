/** Whole years between a YYYY-MM-DD birth date and today. */
export function calculateAge(birthDate: string): number {
  const today = new Date()
  const dob = new Date(birthDate)
  let age = today.getFullYear() - dob.getFullYear()
  const hasHadBirthdayThisYear =
    today.getMonth() > dob.getMonth() ||
    (today.getMonth() === dob.getMonth() && today.getDate() >= dob.getDate())
  if (!hasHadBirthdayThisYear) age -= 1
  return age
}

/**
 * Exam level per the professor's fixed mapping: 2-3/4-5 -> facil,
 * 6-7/8-9 -> medio, 10-11/18-35/+35 -> dificil. Participants never choose this
 * themselves; it is derived from the age category's min_age so it keeps
 * working if new categories are added within the same bands.
 */
export function difficultyForMinAge(minAge: number): 'facil' | 'medio' | 'dificil' {
  if (minAge <= 5) return 'facil'
  if (minAge <= 9) return 'medio'
  return 'dificil'
}

