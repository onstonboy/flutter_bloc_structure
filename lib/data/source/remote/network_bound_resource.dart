import 'dart:async';

import 'package:flutter/material.dart';
import 'package:structure_flutter/core/common/utils/network_manager.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/di/injection.dart';

class NetworkBoundResource<ResultType, RequestType> {
  StreamController<Result<ResultType>> _result;
  NetworkManager _networkManager;

  NetworkBoundResource() {
    _networkManager = getIt<NetworkManager>();
    _result = StreamController<Result<ResultType>>();
  }

  Stream<Result<ResultType>> asStream({
    @required Future<ResultType> loadFromDb(),
    @required Future<RequestType> createCall(),
    @required Future<dynamic> saveCallResult(RequestType item),
  }) {
    callBackData(
        loadFromDb: () => loadFromDb(),
        createCall: () => createCall(),
        saveCallResult: (result) => saveCallResult(result));
    return _result.stream;
  }

  Future<RequestType> _fetchFromNetwork(
      {Future<RequestType> createCall()}) async {
    return createCall();
  }

  callBackData({
    @required Future<ResultType> loadFromDb(),
    @required Future<RequestType> createCall(),
    @required Future<dynamic> saveCallResult(RequestType item),
  }) {
    loadFromDb().then((dataLocal) async {
      _result.sink.add(InProgress(data: dataLocal));
      _networkManager.isConnectAvailable().then((isAvailable) {
        if (!isAvailable) {
          _networkManager.observeConnectivity().listen((isAvailable) {
            fetchDataRemote(
              createCall: createCall,
              saveCallResult: saveCallResult,
            );
          });
        } else {
          fetchDataRemote(
            createCall: createCall,
            saveCallResult: saveCallResult,
          );
        }
      });
    });
  }

  fetchDataRemote({
    @required Future<RequestType> createCall(),
    @required Future<dynamic> saveCallResult(RequestType item),
  }) async {
    try {
      var result;
      result = await _fetchFromNetwork(createCall: createCall);
      await saveCallResult(result);
      _result.add(Success(data: result));
    } on Exception catch (e) {
      _result.addError(Error(data: null, error: e));
    }
    _result.close();
  }
}
