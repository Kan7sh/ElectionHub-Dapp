import 'package:flutter/material.dart';
import 'package:flutter_web3/pages/electionInfo.dart';
import 'package:flutter_web3/services/functions.dart';
import 'package:flutter_web3/utils/constants.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Election'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  filled: true, hintText: 'Enter Election name'),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      if (controller.text.length > 0) {
                        await startElection(controller.text, ethClient!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ElectionInfo(
                                    ethClient: ethClient!,
                                    electionName: controller.text)));
                      }
                    },
                    child: const Text('Start Election')))
          ],
        ),
      ),
    );
  }
}
