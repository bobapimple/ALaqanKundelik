import { supabase } from './app/lib/supabase';

async function debugProfiles() {
  console.log('--- FETCHING ALL PROFILES ---');
  const { data, error } = await supabase.from('profiles').select('*');
  
  if (error) {
    console.error('Error fetching profiles:', error);
    return;
  }
  
  console.log('Total profiles found:', data.length);
  console.log(JSON.stringify(data, null, 2));
}

debugProfiles();
