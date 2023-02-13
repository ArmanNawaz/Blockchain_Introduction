import 'package:blockchain_introduction/contract_linking/contract_linking.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/crypto.dart';

class Block {
  String transactionHash;
  String blockHash;
  String blockNumber;
  DateTime timeStamp;
  String gasUsed;
  String prevBlockHash;
  Color? color = Colors.white;

  Block(
      {required this.transactionHash,
      required this.blockHash,
      required this.blockNumber,
      required this.timeStamp,
      required this.gasUsed,
      required this.prevBlockHash});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<Block> blocks = [];
  ContractLinking contractLinking = ContractLinking();
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final Duration delayDuration = const Duration(seconds: 1);

  @override
  void initState() {
    blocks.add(Block(
        transactionHash: "",
        blockHash: "",
        blockNumber: "",
        timeStamp: DateTime.now(),
        gasUsed: "",
        prevBlockHash: ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Introduction to Blockchain",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w100,
            letterSpacing: 1,
          ),
        ),
        elevation: 10,
        backgroundColor: const Color(0xFF085892),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
                color: const Color(0xFFFFFFFF),
                height: size.height,
                child: Column(
                  children: [
                    Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/blockchain.jpeg")),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: 350,
                        child: TextField(
                          controller: controller,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF085892)),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            labelText: "Text",
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: 'Enter your text',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          String data = controller.text;
                          if (data.isEmpty) {
                            myDialogBox(
                                context: context,
                                content: const Text("Please input some text"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ]);
                          } else {
                            myDialogBox(
                                context: context,
                                title: const Text("Accessing Blockchain"),
                                content: const LinearProgressIndicator(),
                                actions: []);
                            contractLinking.addData(data).then((hash) {
                              if (hash == "Error") {
                                Navigator.pop(context);
                                myDialogBox(
                                    context: context,
                                    title: const Text("Error"),
                                    content: const Text(
                                        "Some error occurred while accessing Blockchain\nPlease try again later"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"))
                                    ]);
                              } else {
                                contractLinking
                                    .getTimeStamp()
                                    .then((timeStamp) {
                                  contractLinking
                                      .getReceipt(hash)
                                      .then((receipt) {
                                    blocks.insert(
                                        0,
                                        Block(
                                            transactionHash:
                                                "0x${bytesToHex(receipt.transactionHash)}",
                                            blockHash:
                                                "0x${bytesToHex(receipt.blockHash)}",
                                            blockNumber:
                                                receipt.blockNumber.toString(),
                                            timeStamp: timeStamp.toLocal(),
                                            gasUsed: receipt.gasUsed.toString(),
                                            prevBlockHash: blocks.length == 1
                                                ? ""
                                                : blocks.first.blockHash));

                                    _key.currentState!.insertItem(0,
                                        duration: const Duration(seconds: 0));

                                    controller.clear();
                                  });
                                });
                              }
                            });

                            // Animations
                            Future.delayed(delayDuration).then((value) {
                              Navigator.pop(context);
                              myDialogBox(
                                  context: context,
                                  title:
                                      const Text("Executing Smart Contracts"),
                                  content: const LinearProgressIndicator(),
                                  actions: []);

                              Future.delayed(delayDuration).then((value) {
                                Navigator.pop(context);
                                // creating block
                                myDialogBox(
                                    context: context,
                                    title: const Text("Creating Block"),
                                    content: const LinearProgressIndicator(),
                                    actions: []);

                                Future.delayed(delayDuration).then((value) {
                                  Navigator.pop(context);
                                  // adding data to block
                                  myDialogBox(
                                      context: context,
                                      title: const Text("Adding data to Block"),
                                      content: const LinearProgressIndicator(),
                                      actions: []);

                                  Future.delayed(delayDuration).then((value) {
                                    Navigator.pop(context);
                                    // adding block in blockchain
                                    myDialogBox(
                                        context: context,
                                        title: const Text(
                                            "Adding Block to Blockchain"),
                                        content:
                                            const LinearProgressIndicator(),
                                        actions: []);

                                    Future.delayed(delayDuration).then((value) {
                                      Navigator.pop(context);
                                      myDialogBox(
                                          context: context,
                                          title: const Text("Success"),
                                          content: const Text(
                                              "Data added successfully"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("OK"))
                                          ]);
                                    });
                                  });
                                });
                              });
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.black,
                          elevation: 20.0,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.6,
                          ),
                        ),
                        child: const SizedBox(
                          width: 150,
                          child: Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
          Container(color: Colors.black, width: 0.3),
          Expanded(
            flex: 2,
            child: Container(
              height: size.height,
              color: Colors.tealAccent,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Blocks",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: size.height - 120,
                    child: AnimatedList(
                        key: _key,
                        controller: scrollController,
                        initialItemCount: 1,
                        itemBuilder: (_, index, animation) {
                          List<Block> myList = blocks.reversed.toList();
                          WidgetsBinding.instance.addPostFrameCallback((_) => {
                                scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent)
                              });
                          return FadeTransition(
                              opacity: animation,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.purpleAccent.shade400,
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: MouseRegion(
                                        onEnter: (_) => setState(() {
                                          myList[index].color =
                                              Colors.redAccent;
                                        }),
                                        onExit: (_) => setState(() {
                                          myList[index].color = Colors.white;
                                        }),
                                        cursor: index == 0
                                            ? SystemMouseCursors.forbidden
                                            : SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: index == 0
                                              ? null
                                              : () {
                                                  myDialogBox(
                                                      backgroundTap: true,
                                                      context: context,
                                                      title: Center(
                                                        child: Text(
                                                            "Block - ${myList[index].blockNumber}"),
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Block Hash - ${myList[index].blockHash}"),
                                                          Text(
                                                              "Transaction Hash - ${myList[index].transactionHash}"),
                                                          Text(
                                                              "Time - ${myList[index].timeStamp}"),
                                                          Text(
                                                              "Gas Used - ${myList[index].gasUsed}"),
                                                          Text(
                                                              "Previous Block Hash - ${myList[index].prevBlockHash}")
                                                        ],
                                                      ),
                                                      actions: []);
                                                },
                                          child: Container(
                                            height: 48,
                                            width: 98,
                                            decoration: BoxDecoration(
                                                color: index == 0
                                                    ? Colors.green
                                                    : myList[index].color,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              index == 0
                                                  ? "Genesis"
                                                  : index.toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future myDialogBox(
    {required BuildContext context,
    Widget? title,
    bool? backgroundTap = false,
    required Widget content,
    required List<Widget> actions}) {
  return showDialog(
      barrierDismissible: backgroundTap!,
      barrierColor: Colors.black54,
      context: context,
      builder: (_) => AlertDialog(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: title,
          content: content,
          actions: actions));
}
