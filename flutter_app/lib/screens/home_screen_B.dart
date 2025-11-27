import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchVerse() async {
  try {
    final doc = await FirebaseFirestore.instance.collection('daily').doc('verse').get();
    if (doc.exists && doc.data()?['sinhala'] != null) return doc.data()!['sinhala'] as String;
  } catch (e) {}
  return "ඔබේ ආශිර්වාදය ... (fallback)";
}

class HomeScreenB extends StatefulWidget {
  const HomeScreenB({Key? key}) : super(key: key);
  @override
  State<HomeScreenB> createState() => _HomeScreenBState();
}

class _HomeScreenBState extends State<HomeScreenB> {
  late Future<String> verse;
  @override
  void initState() {
    super.initState();
    verse = fetchVerse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        // neon cross image (png/gif) — using bg2.gif as neon cross asset
        Center(child: Image.asset('assets/bg/bg2.gif', height: 360)),
        // doves Lottie overlay
        Positioned.fill(child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(height: 300, child: Lottie.asset('assets/lotties/doves_pack.json', fit: BoxFit.contain)),
        )),
        // verse bottom
        FutureBuilder<String>(
          future: verse,
          builder: (context, snap) {
            final txt = snap.hasData ? snap.data! : 'ඔබේ දින ආලෝකමත් වේ...';
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(txt, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            );
          },
        )
      ]),
    );
  }
}
