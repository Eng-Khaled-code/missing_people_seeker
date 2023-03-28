import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/services/search_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchChange with ChangeNotifier {
  bool isLoading = false;
  List<String> _suggestedOrdersIds = [];

  SearchChange.initialize();

  SearchServices _searchServices = SearchServices();

  Future<void> updateSuggestion(
      {String? orderId, List<String>? ordersIds}) async {
    try {
      isLoading = true;
      notifyListeners();

      // refuse order value 2
      await _searchServices.updateSuggestionsToNo(
          collection: MissedModel.REF, orderId: orderId, ordersIds: ordersIds);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: "سوف نقوم بإرسال إقتراحات جديدة لك عند توفر المعلومات المطلوبة",
          toastLength: Toast.LENGTH_LONG);
    } catch (ex) {
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_LONG);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSuggestedOrdersIds({String? orderId}) async {
    _suggestedOrdersIds =
        await _searchServices.loadSuggestedOrdersId(orderId: orderId);
    notifyListeners();
  }

  List<String> get getSuggestedOrdersIds => _suggestedOrdersIds;
}
