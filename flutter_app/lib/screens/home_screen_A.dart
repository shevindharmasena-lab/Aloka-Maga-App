import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchVerse() async {
  try {
    final doc = await FirebaseFirestore.instance.collection('daily').doc('verse').get();
    if (doc.exists && doc.data()?['sinhala'] != null) return doc.data()!['sinhala'] as String;
  } catch (e) { /* ignore, fallback */ }
  // fallback
  return "පස්වක‍ රහස: ඔබට ආදරේ... (fallback Sinhala verse)";
}

class HomeScreenA extends StatefulWidget {
  const HomeScreenA({Key? key}) : super(key: key);
  @override
  State<HomeScreenA> createState() => _HomeScreenAState();
}

class _HomeScreenAState extends State<HomeScreenA> {
  late Future<String> verse;
  @override
  void initState() {
    super.initState();
    verse = fetchVerse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // full-screen gif background (bg1.gif)
          Image.asset('assets/bg/bg1.gif', fit: BoxFit.cover),
          // soft overlay
          Container(color: Colors.black.withOpacity(0.25)),
          // lottie heavenly overlay
          Center(child: Lottie.asset('assets/lotties/heavenly_background.json', repeat: true)),
          // verse card
          FutureBuilder<String>(
            future: verse,
            builder: (context, snap) {
              final text = snap.hasData ? snap.data! : 'සියලු දේකම ඔහුගේ ප්‍රේමය...';
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.black.withOpacity(0.55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(text,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
