import "package:desapv3/controllers/navigation_link.dart";
import "package:flutter/material.dart";

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: ElevatedButton(
            child: const Text("Bye"),
            onPressed: () {
              Navigator.pushNamed(context, loginRoute);
            }),
      ),
    );
  }
}
