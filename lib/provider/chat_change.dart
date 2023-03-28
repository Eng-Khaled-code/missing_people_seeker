import 'package:flutter/cupertino.dart';
import 'package:finalmps/services/chat_services.dart';
import 'package:finalmps/models/chat_model.dart';

class ChatChange with ChangeNotifier {
  List<String>? adminsIds;
  String inputStatus = "0";
  ChatServices _chatServices = ChatServices();
  String lastDate = "";
  String connectStatus = "";
  String opensChatPage = "";

  ChatChange.initialize();

  //int _recentMessagesCount = 0;

  Future<void> sendMessage(
      {String? userId, String? chatID, String? message, String? seen}) async {
    await _chatServices.addMessage(
        chatId: chatID, message: message, userId: userId, seen: seen);
    notifyListeners();
  }

  Future<void> loadMyAdminsIds(String? userId) async {
    adminsIds = await _chatServices.loadMyAdmins(userId);
    notifyListeners();
  }

  Future<void> loadInputStatus(String userId, String adminId) async {
    inputStatus = await _chatServices.inputStatus(userId, adminId);
    notifyListeners();
  }

  Future<void> loadAdminOpensMyChatPage(String chatId, String adminId) async {
    opensChatPage =
        await _chatServices.loadAdminOpensMyChatPage(chatId, adminId);
    notifyListeners();
  }

  Future<void> loadConnectStatus(String adminId) async {
    connectStatus = await _chatServices.loadConnectStatus(adminId);
    notifyListeners();
  }

  Future<ChatModel> loadLastMessage({String? docId}) async {
    ChatModel _chatModel = await _chatServices.loadLastMessage(docId: docId);

    notifyListeners();
    return _chatModel;
  }

  Future<int> loadUnSeenMessagesCount({String? docId, String? userId}) async {
    int _count = await _chatServices.loadUnSeenMessagesCount(
        docId: docId, userId: userId);

    notifyListeners();
    return _count;
  }

  Future<void> updateToSeen({String? chatId, String? adminId}) async {
    try {
      await _chatServices.updateToSeen(chatId: chatId, adminId: adminId);
      notifyListeners();
    } catch (ex) {
      notifyListeners();
    }
  }

  // Future updateLastDate({String userId}) async {
  //   try {
  //     // refuse order value 2
  //     await _chatServices.updateLastDate(userId: userId).then((value) {
  //       notifyListeners();
  //     });
  //   } catch (ex) {
  //     notifyListeners();
  //   }
  // }

//open is yes
  Future<bool> openChatPage({String? chatId, String? userId}) async {
    try {
      await _chatServices.updateOpenOrCloseChatPage(
          docId: chatId, userId: userId, open: "yes");
      return true;
    } catch (ex) {
      return false;
    }
  }

//close is no

  Future<bool> closeChatPage({String? chatId, String? userId}) async {
    try {
      await _chatServices.updateOpenOrCloseChatPage(
          docId: chatId, userId: userId, open: "no");

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<void> firstOpenOrClose(
      {String? chatId, String? userId, String? open}) async {
    await _chatServices.firstOpenOrClose(
        docId: chatId, userId: userId, open: open);
  }

  // Future<void> updateRecentMesagesCount({String userId, String date}) async {
  //   await _chatServices.updateRecentMessaagesCount(userId: userId, date: date);
  //   notifyListeners();
  // }

  // Future<void> loadRecentMessagesCount({String userId}) async {
  //   _recentMessagesCount =
  //       await _chatServices.loadRecentMessagesCount(userId: userId);
  //   notifyListeners();
  // }

  // Future<void> loadLastDate({String userId}) async {
  //   _lastDate = await _chatServices.loadLastDate(userId: userId);
  //   notifyListeners();
  // }
}
