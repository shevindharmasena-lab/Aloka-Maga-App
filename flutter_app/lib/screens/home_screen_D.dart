import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchVerse() async {
  try {
    final doc = await FirebaseFirestore.instance.collection('daily').doc('verse').get();
    if (doc.exists && doc.data()?['sinhala'] != null) return doc.data()!['sinhala'] as String;
  } catch (e) {}
  return "ඔබට සැනසුම ලැබේවා... (fallback)";
}

class HomeScreenD extends StatefulWidget {
  const HomeScreenD({Key? key}) : super(key: key);
  @override
  State<HomeScreenD> createState() => _HomeScreenDState();
}

class _HomeScreenDState extends State<HomeScreenD> {
  late Future<String> verse;
  @override
  void initState() {
    super.initState();
    verse = fetchVerse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/bg/bg4.gif', fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.35)),
        Center(child: Image.asset('assets/bg/bg1.gif', height: 320, width: 220, fit: BoxFit.contain)), // big cross or substitute
        // neon ivy border (use lottie neon pack subtly at corners)
        Positioned(top: 20, left: 10, right: 10, child: Lottie.asset('assets/lotties/neon_ui_pack.json', height: 120)),
        FutureBuilder<String>(
          future: verse,
          builder: (context, snap) {
            final t = snap.hasData ? snap.data! : 'प्रार्थना...';
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.6)),
                ),
                child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            );
          },
        ),
      ]),
    );
  }
}
