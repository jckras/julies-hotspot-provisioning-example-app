import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hotspot_example/consts.dart';
import 'package:viam_flutter_hotspot_provisioning_widget/viam_flutter_hotspot_provisioning_widget.dart';

class ProvisionNewMachine extends StatefulWidget {
  const ProvisionNewMachine({super.key});

  @override
  State<ProvisionNewMachine> createState() => _ProvisionNewMachineState();
}

class _ProvisionNewMachineState extends State<ProvisionNewMachine> {
  static const _animalNames = [
    'ant',
    'bear',
    'cat',
    'dog',
    'eagle',
    'fox',
    'giraffe',
    'hippo',
    'iguana',
    'jaguar',
    'koala',
    'lion',
    'monkey',
    'narwhal',
    'owl',
    'panda',
    'quail',
    'rabbit',
    'shark',
    'tiger',
    'urchin',
    'vulture',
    'whale',
    'yak',
    'zebra',
  ];

  late Viam viam;
  String? _statusMessage;
  Robot? _createdRobot;
  String? _createdRobotName;
  String? _createdLocationName;

  @override
  void initState() {
    super.initState();
    initViam();
  }

  void initViam() async {
    viam = await Viam.withApiKey(Consts.apiKeyId, Consts.apiKey);
  }

  Future<
    ({Location location, Robot robot, String locationName, String robotName})
  >
  createNewMachine() async {
    final randomAnimal = _animalNames[Random().nextInt(_animalNames.length)];
    final locationName = 'test-location-$randomAnimal';
    final robotName = 'tester-$randomAnimal';
    final location = await viam.appClient.createLocation(
      Consts.organizationId,
      locationName,
    );
    final robotId = await viam.appClient.newMachine(robotName, location.id);
    final robot = await viam.appClient.getRobot(robotId);
    return (
      location: location,
      robot: robot,
      locationName: locationName,
      robotName: robotName,
    );
  }

  Future<HotspotProvisioningResult?> provisionNewMachine(Robot robot) async {
    final mainPart = (await viam.appClient.listRobotParts(
      robot.id,
    )).firstWhere((element) => element.mainPart);
    return await HotspotProvisioningFlow.show(
      context,
      robot: robot,
      viam: viam,
      mainPart: mainPart,
      hotspotPrefix: Consts.hotspotPrefix,
      hotspotPassword: Consts.hotspotPassword,
      fragmentId: null,
      promptForCredentials: false,
      overrideFragment: true,
      replaceHardware: false,
      robotConfig: null,
    );
  }

  Future<void> _handleCreateRobotPressed() async {
    final res = await createNewMachine();
    if (!mounted) return;
    setState(() {
      _createdRobot = res.robot;
      _createdRobotName = res.robotName;
      _createdLocationName = res.locationName;
      // Reset any previous provisioning status
      _statusMessage = null;
    });
  }

  Future<void> _handleProvisionRobotPressed() async {
    final robot = _createdRobot;
    if (robot == null) return;

    final flowResult = await provisionNewMachine(robot);

    if (flowResult != null) {
      // HotspotProvisioningFlow completed; update status text
      if (!mounted) return;
      setState(() {
        if (flowResult.status == MachineStatus.online) {
          _statusMessage = 'Robot online';
        } else {
          _statusMessage = 'Robot offline or provisioning timed out';
        }
      });
    } else {
      if (!mounted) return;
      setState(() {
        _statusMessage =
            'No result from HotspotProvisioningFlow. The flow may have been cancelled.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provision a new machine')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _handleCreateRobotPressed();
              },
              child: Text('Step 1: Create a new machine'),
            ),
            if (_createdRobot != null) ...[
              SizedBox(height: 24),
              Text('Created robot: ${_createdRobotName ?? ''}'),
              Text('Location: ${_createdLocationName ?? ''}'),
              SizedBox(height: 24),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _handleProvisionRobotPressed();
                },
                child: Text('Step 2: Provision this robot onto Wi‑Fi'),
              ),
            ],
            if (_statusMessage != null) ...[
              SizedBox(height: 16),
              Text(_statusMessage!),
            ],
          ],
        ),
      ),
    );
  }
}
