import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/PeerController.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({Key? key}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Peer id : ${context.watch<PeerController>().id}"),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PeerController>().reloadPeer();
              },
              child: const Text("Reload peer"),
            ),
          ],
        ),
        context.watch<PeerController>().connection != null
            ? Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Connected to peer ${context.watch<PeerController>().connection!.peer}"),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PeerController>().close();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                    Expanded(
                      child: context.watch<PeerController>().history.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(), color: Colors.black),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: context
                                        .watch<PeerController>()
                                        .history
                                        .values
                                        .map(
                                          (e) => e.sender == context.read<PeerController>().id
                                              ? Container(
                                                  padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                                                  alignment: Alignment.centerRight,
                                                  child: Chip(
                                                    label: Text(
                                                      e.message,
                                                      softWrap: true,
                                                      maxLines: 100000,
                                                    ),
                                                    backgroundColor: Colors.blue,
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets.only(right: 20, bottom: 5, top: 5),
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Chip(
                                                        label: Text("${e.sender} > ${e.message}",
                                                            softWrap: true,
                                                            maxLines: 100000,
                                                            style: const TextStyle(color: Colors.white)),
                                                        backgroundColor: Colors.grey,
                                                      ),
                                                      if (e.message.startsWith("RULES:"))
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                                              onPressed: () {
                                                                context
                                                                    .read<PeerController>()
                                                                    .send("OUI TO RULES:${e.id}");
                                                              },
                                                              child: const Text("OUI"),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.red),
                                                              onPressed: () {
                                                                context
                                                                    .read<PeerController>()
                                                                    .send("NON TO RULES:${e.id}");
                                                              },
                                                              child: const Text("NON"),
                                                            ),
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            )
                          : const Text("No message"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: textEditingController,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<PeerController>().send(textEditingController.text);
                            textEditingController.clear();
                          },
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  TextField(
                    controller: context.read<PeerController>().textEditingController,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PeerController>().connect();
                    },
                    child: const Text("Connect to peer"),
                  ),
                  const Text("Not connected to peer"),
                ],
              )
      ],
    );
  }
}
