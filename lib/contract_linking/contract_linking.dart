import 'dart:convert';

import 'package:blockchain_introduction/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class ContractLinking {
  final String _rpcUrl = "http://127.0.0.1:8545";
  // final String _wsUrl = "ws://127.0.0.1:8545/";
  final String _privateKey = privateKey;

  late Web3Client _client;
  late String _abiCode;
  late int chainId;

  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _add;

  ContractLinking() {
    initialSetup();
  }

  void initialSetup() async {
    _client = Web3Client(_rpcUrl, http.Client());

    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/Introduction.json");

    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _contractAddress = EthereumAddress.fromHex(contractAddress);
    chainId = (await _client.getChainId()).toInt();
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Introduction"), _contractAddress);
    _add = _contract.function("add");
  }

  Future<String> addData(String data) async {
    String transactionHash = "Error";
    try {
      transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract, function: _add, parameters: [data]),
          chainId: chainId);
    } catch (e) {
      print("error - $e");
      return transactionHash;
    }
    return transactionHash;
  }

  Future<TransactionReceipt> getReceipt(String hash) async {
    TransactionReceipt? receipt = await _client.getTransactionReceipt(hash);
    return receipt!;
  }

  Future<DateTime> getTimeStamp() async {
    BlockInformation info = await _client.getBlockInformation();
    return info.timestamp;
  }
}
