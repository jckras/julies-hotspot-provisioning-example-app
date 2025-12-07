import 'package:flutter/material.dart';
import 'package:hotspot_example/provision_new_machine.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Julie\'s Example App')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Click below to get started'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProvisionNewMachine(),
                  ),
                );
              },
              child: Text('Provision a new machine'),
            ),
          ],
        ),
      ),
    );
  }
}
