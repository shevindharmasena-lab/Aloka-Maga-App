import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchVerse() async {
  try {
    final doc = await FirebaseFirestore.instance.collection('daily').doc('verse').get();
    if (doc.exists && doc.data()?['sinhala'] != null) return doc.data()!['sinhala'] as String;
  } catch (e) {}
  return "හදවතට සුවය... (fallback)";
}

class HomeScreenC extends StatefulWidget {
  const HomeScreenC({Key? key}) : super(key: key);
  @override
  State<HomeScreenC> createState() => _HomeScreenCState();
}

class _HomeScreenCState extends State<HomeScreenC> {
  late Future<String> verse;
  @override
  void initState() {
    super.initState();
    verse = fetchVerse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Aloka Maga'), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Center(
        child: FutureBuilder<String>(
          future: verse,
          builder: (context, snap) {
            final text = snap.hasData ? snap.data! : 'හදවත...';
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.book, size: 48, color: Colors.amber[700]),
                  SizedBox(height: 12),
                  Text(text, style: TextStyle(fontSize: 18, color: Colors.black87), textAlign: TextAlign.center),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
