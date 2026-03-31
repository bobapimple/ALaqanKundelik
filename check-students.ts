import { supabase } from './app/lib/supabase';

async function checkStudents() {
  console.log('--- FETCHING STUDENTS ---');
  const { data: students, error: studentError } = await supabase
    .from('profiles')
    .select('*')
    .eq('role', 'student');
  
  if (studentError) {
    console.error('Error fetching students:', studentError);
  } else {
    console.log('Students in DB:', JSON.stringify(students, null, 2));
  }

  console.log('--- FETCHING ALL PROFILES ---');
  const { data: all, error: allError } = await supabase
    .from('profiles')
    .select('*');
  
  if (allError) {
    console.error('Error fetching all profiles:', allError);
  } else {
    console.log('Total profiles count:', all?.length || 0);
  }
}

checkStudents();
