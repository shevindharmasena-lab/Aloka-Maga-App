import React, {useState} from 'react';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, doc, setDoc } from 'firebase/firestore';
import Papa from 'papaparse';
import { firebaseConfig } from './firebaseConfig';

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export default function App(){
  const [file,setFile] = useState(null);
  const [status,setStatus] = useState('');
  const handleFile = (e)=> setFile(e.target.files[0]);
  const uploadCSV = ()=> {
    if(!file) return;
    Papa.parse(file,{ header:true, complete: async (results)=>{
      setStatus('Uploading...');
      for(const row of results.data){
        if(row.type === 'special_day'){
          await setDoc(doc(db,'app_theme','special_days','days',row.slug), {
            slug: row.slug, month: parseInt(row.month), day: parseInt(row.day),
            enabled: row.enabled === 'true', presetOverride: row.presetOverride,
            overrideFields: row.overrideFields ? JSON.parse(row.overrideFields) : null,
            message_si: row.message_si
          }, { merge: true });
        } else {
          await addDoc(collection(db,'verses'), {
            id: row.id || null, date: row.date, verse_text_si: row.verse_text_si,
            reference: row.reference, category: row.category || ''
          });
        }
      }
      setStatus('Done');
    }});
  };
  const setBackground = async (presetId) => {
    await setDoc(doc(db,'app_theme','daily_background'), { presetId, lastUpdated: new Date().toISOString() }, { merge: true });
    alert('Background set to ' + presetId);
  };
  return (<div style={{padding:20}}>
    <h1>Aloka Maga Admin</h1>
    <input type="file" accept=".csv" onChange={handleFile} />
    <button onClick={uploadCSV}>Upload CSV</button>
    <p>{status}</p>
    <hr />
    <h3>Quick Background</h3>
    <button onClick={()=>setBackground('bg_light_rays')}>Light Rays</button>
    <button onClick={()=>setBackground('bg_soft_clouds')}>Soft Clouds</button>
    <button onClick={()=>setBackground('bg_sparkling_particles')}>Sparkles</button>
  </div>);
}
