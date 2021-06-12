import 'package:VennUI/components/Notification.dart';
import 'package:VennUI/components/SettingPages.dart';
import 'package:VennUI/grpc/metric.dart';
import 'package:VennUI/grpc/settings.dart';
import 'package:VennUI/providers/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:VennUI/grpc/v1/ui.pb.dart' as proto;
import 'package:VennUI/utilies.dart';
import 'package:provider/provider.dart';

class SettingsProvider with ChangeNotifier {
  // current page
  String currentPage = "list";

  // setting
  final int sliderPerPage = 4;

  bool isLoading = true;
  int numPagesSliders = 3;
  int activeIndexSlider = 0;
  int modifiedSlider = 0;

  List<proto.Setting> settings = [];
  List<double> oldSettings = [];

  List<proto.GraphSettings> graphSettings = [];

  // Selectors
  final int selectorPerPage = 4;

  int numPagesSelectors = 0;
  int activeIndexSelectors = 0;
  List<proto.Selector> selectors = [];
  List<List<String>> selectorChoicesName = [];

  // Recipes
  int hoverRecipe = -1;
  int selectedRecipe = 0;
  List<RecipeInfo> recipesInfo = [];

  SettingGrpcAPI? _settingAPI;
  MetricGrpcAPI? _metricAPI;

  SettingsProvider(SettingGrpcAPI r, MetricGrpcAPI s) {
    _settingAPI = r;
    _metricAPI = s;
    initiate();
  }

  void initiate() async {
    // Retrieve the initial settings
    // var currentRecipe = await _settingAPI.readRecipe('default');
    var currentRecipe = await _settingAPI!.readCurrentRecipe();

    settings = List.of(currentRecipe.settings);
    oldSettings =
        List.generate(settings.length, (index) => settings[index].value);
    numPagesSliders = (settings.length / sliderPerPage).ceil();

    graphSettings = currentRecipe.graphs;

    // Send the initial settings to the backend
    for (var s in settings) {
      _settingAPI!.updateSetting(proto.SettingUpdate(
          name: s.name, value: s.value, isStatic: s.isStatic));
    }

    // Retrieve the set of selector
    var s = await _settingAPI!.readSelectorList();
    selectors = List.of(s.selectors);
    numPagesSelectors = (selectors.length / selectorPerPage).ceil();
    for (var selector in selectors) {
      List<String> choicesName = [];
      for (var choice in selector.possibleChoices) {
        choicesName.add(choice);
      }
      selectorChoicesName.add(choicesName);
    }

    // Retrieve Initial Set of recipe
    var uuids = await _settingAPI!.readRecipesUUID();
    List<String> listUuids = List.of(uuids.uuids);
    for (int i = 0; i < listUuids.length; i++) {
      var r = await _settingAPI!.readRecipe(listUuids[i]);
      recipesInfo.add(RecipeInfo(r.uuid, r.title, r.info));
      if (currentRecipe.uuid == r.uuid) {
        selectedRecipe = i;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void setSetting(int i, int value) {
    settings[i].value = value.toDouble();
    modifiedSlider = i;
    notifyListeners();
  }

  void setPageSliders(int i) {
    if (i < 0 || i >= numPagesSliders) {
      throw ('Invalid page index');
    }
    activeIndexSlider = i;
    notifyListeners();
  }

  void setPageSelectors(int i) {
    if (i < 0 || i >= numPagesSelectors) {
      throw ('Invalid page index');
    }
    activeIndexSelectors = i;
    notifyListeners();
  }

  void showInfoModal(BuildContext context) {
    var text = "";
    settings.forEach((element) {
      text += "${element.name}: ${element.info}\n\n";
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      showModal(context, 'Settings Information', text);
    });
  }

  Future<void> loadRecipe(BuildContext context) async {
    var same = await getCurrentSettings(context);
    if (same) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Info,
          "Nothing to load, all the settings are the same."));
    } else {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Success,
          "The previous settings were successfully loaded."));
    }
    notifyListeners();
  }

  Future<bool> getCurrentSettings(BuildContext context) async {
    var recipe = await _settingAPI!.readCurrentRecipe();
    // Compare if the new recipe is different
    var same = settings == recipe.settings;
    settings = recipe.settings;
    oldSettings =
        List.generate(settings.length, (index) => settings[index].value);
    return same;
  }

  Future<void> saveRecipe(BuildContext context) async {
    // Send update settings
    var modified = false;
    for (int i = 0; i < settings.length; i++) {
      if (settings[i].value != oldSettings[i]) {
        if (settings[i].hasTarget()) {
          updateTarget(settings[i]);
        }
        _settingAPI!.updateSetting(proto.SettingUpdate(
            name: settings[i].name,
            value: settings[i].value,
            isStatic: settings[i].isStatic));
        oldSettings[i] = settings[i].value;
        modified = true;
      }
    }
    // Send update graph
    for (proto.GraphSettings s in graphSettings) {
      _settingAPI!.updateGraph(proto.GraphUpdate(
          isStatic: false, name: s.name, newPoints: s.points));
    }
    if (modified) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Success, "Sucessfully saved the new settings."));
    } else {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Info,
          "Nothing to save, all the settings are the same."));
    }
    notifyListeners();
  }

  Future<void> updateTarget(proto.Setting setting) async {
    proto.MetricConfigs M = await _metricAPI!.readConfig();
    for (int i = 0; i < M.configs.length; i++) {
      if (M.configs[i].name == setting.target.name) {
        M.configs[i].target = setting.value;
        _metricAPI!.updateConfig(M);
        return;
      }
    }
  }

  void updateSelectorChoice(int index, String newChoiceName) {
    var newChoice;
    for (var choice in selectors[index].possibleChoices) {
      if (choice == newChoiceName) {
        newChoice = choice;
      }
    }
    selectors[index].choice = newChoice;
  }

  void updateRecipeHover(int i) {
    if (i == hoverRecipe) {
      hoverRecipe = -1;
    } else {
      hoverRecipe = i;
    }
    notifyListeners();
  }

  Future<void> createRecipe(BuildContext context) async {
    if (recipesInfo.length >= 99) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error, "Cannot add more than 99 recipes."));
      return;
    }
    proto.Recipe newRecipe = await _settingAPI!.createRecipe();
    recipesInfo
        .add(RecipeInfo(newRecipe.uuid, newRecipe.title, newRecipe.info));
    notifyListeners();
  }

  Future<void> editRecipe(BuildContext context, RecipeInfo i) async {
    if (i.title.length > 25) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error,
          i.title + "The new title is too long. (Max 25 char)"));
      return;
    }
    if (i.info.length > 80) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error,
          "The new information text is too long. (Max 80 char)"));
      return;
    }
    // Get the old recipe and updates its information text and title
    proto.Recipe r = await _settingAPI!.readRecipe(i.uuid);
    r.info = i.info;
    r.title = i.info;
    _settingAPI!.updateRecipe(r);
    recipesInfo[hoverRecipe] = i;
    context.read<NotificationProvider>().displayNotification(NotificationData(
        NotificationType.Success,
        "Succesfully updated the recipe's information."));
    notifyListeners();
  }

  Future<void> deleteRecipe(BuildContext context) async {
    // Cannot delete a recipe if none is selected
    if (hoverRecipe == -1) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error, "Please press any recipe to delete it."));
      return;
    }
    // Cannot remove the first/default recipe
    if (recipesInfo.elementAt(hoverRecipe).uuid == "default") {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error, "Cannot remove the default recipe."));
      return;
    }
    _settingAPI!.deleteRecipe(recipesInfo.elementAt(hoverRecipe).uuid);
    recipesInfo.removeAt(hoverRecipe);
    hoverRecipe = -1;
    notifyListeners();
  }

  Future<void> selectRecipe(BuildContext context) async {
    // Cannot select a recipe if none is selected
    if (hoverRecipe == -1) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Error, "Please press any recipe to select it."));
      return;
    }
    // Send the new recipe
    _settingAPI!.updateCurrentRecipe(recipesInfo.elementAt(hoverRecipe).uuid);
    selectedRecipe = hoverRecipe;
    // Load the new recipe settings
    await getCurrentSettings(context);
    context.read<NotificationProvider>().displayNotification(NotificationData(
        NotificationType.Success, "Sucessfully selected the recipe."));
    notifyListeners();
  }

  Widget getSettingsPage(String page) {
    switch (page) {
      case "list":
        return ListSettings();
      case "general":
        return GeneralSettings();
      case "pressure":
        return PressureSettings();
      case "heating":
        return HeatingSettings();
      default:
    }
    return Container();
  }

  void updateSettingsPage(String newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  // Graph related methods
  void editGraph(int ig, int ip, double v, Coord c) {
    if (c == Coord.X) {
      graphSettings[ig].points[ip].x = v;
    } else {
      graphSettings[ig].points[ip].y = v;
    }
    notifyListeners();
  }

  void removeLastGraphPoint(int i) {
    if (graphSettings[i].points.length > 0) {
      graphSettings[i].points.removeLast();
    }
    notifyListeners();
  }

  void appdOnePointGraph(int i) {
    if (graphSettings[i].points.length == 0) {
      graphSettings[i].points.add(proto.Point(x: 0, y: 0));
    } else {
      proto.Point p =
          graphSettings[i].points[graphSettings[i].points.length - 1];
      graphSettings[i].points.add(proto.Point(x: p.x, y: p.y));
    }
    notifyListeners();
  }
}

class RecipeInfo {
  String uuid;
  String title;
  String info;

  RecipeInfo(this.uuid, this.title, this.info);
}
