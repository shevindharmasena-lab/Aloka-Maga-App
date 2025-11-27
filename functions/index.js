const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {TextToSpeechClient} = require('@google-cloud/text-to-speech');
const {Storage} = require('@google-cloud/storage');
const fs = require('fs');
const util = require('util');
const child_process = require('child_process');
const exec = util.promisify(child_process.exec);
admin.initializeApp();
const db = admin.firestore();
const storage = new Storage();
const ttsClient = new TextToSpeechClient();

exports.onVerseCreate = functions.firestore.document('verses/{verseId}').onCreate(async (snap, context) => {
  const verse = snap.data();
  const verseId = context.params.verseId;
  const text = verse.verse_text_si || verse.text || '';
  if (!text) return null;
  const tmpRaw = `/tmp/${verseId}_raw.wav`;
  const tmpReverb = `/tmp/${verseId}_reverb.mp3`;
  const storagePath = `bible_audio/${verseId}_reverb.mp3`;
  const bucketName = admin.storage().bucket().name;
  const request = { input: { text }, voice: { languageCode: 'si-LK', name: 'si-LK-Standard-A' }, audioConfig: { audioEncoding: 'LINEAR16', speakingRate: 0.95 } };

  try {
    const [response] = await ttsClient.synthesizeSpeech(request);
    fs.writeFileSync(tmpRaw, response.audioContent, 'binary');
    const ffmpegCmd = `ffmpeg -y -i ${tmpRaw} -af "aecho=0.8:0.9:1000:0.35" -codec:a libmp3lame -q:a 2 ${tmpReverb}`;
    await exec(ffmpegCmd);
    await storage.bucket(bucketName).upload(tmpReverb, { destination: storagePath, metadata: { contentType: 'audio/mpeg' } });
    const file = storage.bucket(bucketName).file(storagePath);
    const [url] = await file.getSignedUrl({ action: 'read', expires: '03-01-2030' });
    await snap.ref.update({ audio_url: url, audio_generated: true });
    try { fs.unlinkSync(tmpRaw); } catch(e) {}
    try { fs.unlinkSync(tmpReverb); } catch(e) {}
    return null;
  } catch (err) {
    console.error('TTS or ffmpeg error', err);
    await snap.ref.update({ audio_generated: false, audio_error: String(err) });
    return null;
  }
});

exports.dailySpecialDayCheck = functions.pubsub.schedule('0 0 * * *').timeZone('Asia/Colombo').onRun(async (context) => {
  const now = new Date();
  const m = now.getMonth() + 1;
  const d = now.getDate();
  const snaps = await db.collection('app_theme').doc('special_days').collection('days').where('enabled','==',true).where('month','==',m).where('day','==',d).get();
  if (snaps.empty) return null;
  for (const doc of snaps.docs) {
    const data = doc.data();
    await db.collection('app_theme').doc('daily_background').set({
      presetId: data['presetOverride'] || data['preset'],
      overrides: data['overrideFields'] || null,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
    // optionally also send a notification (if you maintain token list or topic)
  }
  return null;
});
