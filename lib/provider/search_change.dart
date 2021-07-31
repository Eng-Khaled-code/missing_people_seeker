import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/services/search_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalmps/PL/home/orders/order_suggestions.dart';

class SearchChange with ChangeNotifier {
  bool isLoading = false;
  List<String> _suggestedOrdersIds = [];

  SearchChange.initialize() {}

  SearchServices _searchServices = SearchServices();

  Future<bool> updateSuggestion(
      {String? orderId, List<String>? ordersIds}) async {
    try {
      isLoading = true;
      notifyListeners();

      // refuse order value 2
      await _searchServices
          .updateSuggestionsToNo(
              collection: MissedModel.REF,
              orderId: orderId,
              ordersIds: ordersIds)
          .then((value) {
        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      OrderSuggestions.error = ex.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadSuggestedOrdersIds({String? orderId}) async {
    _suggestedOrdersIds =
        await _searchServices.loadSuggestedOrdersId(orderId: orderId);
    notifyListeners();
  }

  List<String> get getSuggestedOrdersIds => _suggestedOrdersIds;
}
