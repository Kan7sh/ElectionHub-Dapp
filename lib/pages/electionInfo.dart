// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web3/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const ElectionInfo({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizedVoterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.electionName),
        ),
        body: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FutureBuilder<List>(
                        future: getCandidatesNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      Text('Total Candidates')
                    ],
                  ),
                  Column(
                    children: [
                      FutureBuilder<List>(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            "0",
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      Text('Total Votes')
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addCandidateController,
                      decoration:
                          InputDecoration(hintText: 'Enter Candidate Name'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addCandidate(
                            addCandidateController.text, widget.ethClient);
                      },
                      child: Text('Add Candidate'))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: authorizedVoterController,
                      decoration:
                          InputDecoration(hintText: 'Enter Voter Address'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        authorizeVoter(
                            authorizedVoterController.text, widget.ethClient);
                      },
                      child: Text('Add Voter'))
                ],
              ),
              Divider(),
              FutureBuilder<List>(
                  future: getCandidatesNum(widget.ethClient),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(children: [
                        for (int i = 0; i < snapshot.data![0].toInt(); i++)
                          FutureBuilder<List>(
                              future: candidateInfo(i, widget.ethClient),
                              builder: (context, snapshot2) {
                                print(snapshot2.data);
                                if (snapshot2.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListTile(
                                    title: Text('Kanish'),
                                    trailing: ElevatedButton(
                                      child: Text('Vote'),
                                      onPressed: () {
                                        vote(i, widget.ethClient);
                                      },
                                    ),
                                  );
                                }
                              })
                      ]);
                    }
                  })
            ],
          ),
        ));
  }
}
