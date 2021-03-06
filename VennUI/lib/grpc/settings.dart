import 'package:VennUI/utilies.dart';
import 'package:grpc/grpc.dart';
import 'package:VennUI/grpc/v1/ui.pbgrpc.dart' as grpc;
import 'package:VennUI/grpc/v1/ui.pb.dart' as proto;

import 'utilities.dart';

class Credentials {}

class SettingGrpcAPI {
  // Flag is indicating that client is shutting down
  bool _isShutdown = false;

  // gRPC client channel to send messages to the server
  ClientChannel? _clientSend;

  SettingGrpcAPI() {
    _clientSend = newClient(serverIP, serverPort);
  }

  // Shutdown client
  Future<void> shutdown() async {
    _isShutdown = true;
  }

  // Asynchronous function to Update a setting in the backend
  Future<void> updateSetting(proto.SettingUpdate s) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateSetting(s);
    } catch (e) {
      if (!_isShutdown) {
        Future.delayed(retryDelay, () {
          return updateSetting(s);
        });
      }
    }
  }

  // Asynchronous function to update the uncertainty on a setting target
  Future<void> updateUncertainty(proto.TargetUpdate u) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateUncertainty(u);
    } catch (e) {
      if (!_isShutdown) {
        // Invalidate current client
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateUncertainty(u);
        });
      }
    }
  }

  // Asynchronous function to Update the selected choice of a selector
  Future<void> updateSelectedChoice(proto.SelectorUpdate u) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateSelectedChoice(u);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateSelectedChoice(u);
        });
      }
    }
  }

  // Asynchronous function to update a choice settings
  Future<void> updateChoice(proto.ChoiceUpdate u) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateChoice(u);
    } catch (e) {
      if (!_isShutdown) {
        // Invalidate current client
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateChoice(u);
        });
      }
    }
  }

  // Asynchronous function to update a choice settings
  Future<void> updateGraph(proto.GraphUpdate u) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateGraphSettings(u);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateGraph(u);
        });
      }
    }
  }

  // Asynchronous function read UUIDS of recipes in the backend
  Future<proto.UUIDS> readRecipesUUID() async {
    try {
      var empty = grpc.Empty.create();
      return grpc.SettingServiceClient(_clientSend!).readRecipesUUID(empty);
    } catch (e) {
      if (!_isShutdown) {
        // Print the error
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return readRecipesUUID();
        });
      }
    }
    return proto.UUIDS();
  }

  // Asynchronous function read a recipe from the backend
  Future<proto.Recipe> readRecipe(String uuid) async {
    try {
      var request = grpc.StringValue(value: uuid);
      return grpc.SettingServiceClient(_clientSend!).readRecipe(request);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return readRecipe(uuid);
        });
      }
    }
    return proto.Recipe();
  }

  // Asynchronous function read a recipe from the backend
  Future<proto.Recipe> readCurrentRecipe() async {
    try {
      return grpc.SettingServiceClient(_clientSend!)
          .readCurrentRecipe(grpc.Empty());
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return readCurrentRecipe();
        });
      }
    }
    return proto.Recipe();
  }

  // Asynchronous function get a recipe from the backend
  Future<proto.Recipe> createRecipe() async {
    try {
      var request = grpc.Empty.create();
      return grpc.SettingServiceClient(_clientSend!).createRecipe(request);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return createRecipe();
        });
      }
    }
    return proto.Recipe();
  }

  // Asynchronous function to update the current recipe from the backend
  Future<void> updateCurrentRecipe(String uuid) async {
    try {
      var request = grpc.StringValue(value: uuid);
      await grpc.SettingServiceClient(_clientSend!)
          .updateCurrentRecipe(request);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateCurrentRecipe(uuid);
        });
      }
    }
  }

  // Asynchronous function to update a recipe in the backend
  Future<void> updateRecipe(proto.Recipe r) async {
    try {
      await grpc.SettingServiceClient(_clientSend!).updateRecipe(r);
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return updateRecipe(r);
        });
      }
    }
  }

  // Asynchronous function to update a recipe in the backend
  Future<void> deleteRecipe(String uuid) async {
    try {
      await grpc.SettingServiceClient(_clientSend!)
          .deleteRecipe(grpc.StringValue(value: uuid));
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return deleteRecipe(uuid);
        });
      }
    }
  }

  Future<proto.Selectors> readSelectorList() async {
    try {
      var request = grpc.Empty.create();
      var selectors = await grpc.SettingServiceClient(_clientSend!)
          .readSelectorList(request);
      return selectors;
    } catch (e) {
      if (!_isShutdown) {
        print(e.toString());
        // Try again
        Future.delayed(retryDelay, () {
          return readSelectorList();
        });
      }
    }
    return proto.Selectors();
  }
}
