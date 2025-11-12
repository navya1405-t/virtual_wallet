// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:virtual_wallet/screens/upload.dart';

import '../widgets/home/footer.dart';
import '../widgets/home/header.dart';
import '../widgets/home/listOfSections.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  HomeScreen({super.key, required this.username});

  static const Color primary = Color.fromARGB(255, 196, 87, 154); // #C4579A

  final GlobalKey sectionsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 196, 87, 154), Color(0xFF56CCF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              HomeHeader(username: username, primary: primary),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 26.0, top: 18.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 6),
                            Container(
                              height: 6,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ListOfSections(
                              key: sectionsKey,
                              primary: primary,
                              username: username,
                            ),
                            const SizedBox(height: 16),
                            const HomeFooter(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => UploadScreen(username: username)),
          );
          if (result == true) {
            // call the state's refresh method (use dynamic cast)
            (sectionsKey.currentState as dynamic)?.refreshCounts();
          }
        },
        backgroundColor: primary,
        elevation: 8,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
