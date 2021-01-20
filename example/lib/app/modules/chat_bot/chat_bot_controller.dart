import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_chatbot.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_video_call.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../app_controller.dart';
import '../../core/constants/constants.dart';

class ChatBotController extends Disposable {
  final AppController appController = Modular.get<AppController>();

  final OmnisaudeVideoCall omnisaudeVideoCall = new OmnisaudeVideoCall();

  static String _username = USERNAME;
  static String _avatarUrl = AVATAR_URL;

  ChatConnection connection;
  OmnisaudeChatbot omnisaudeChatbot;

  StreamController streamController;

  RxNotifier<ConnectionStatus> connectionStatus = new RxNotifier(
    ConnectionStatus.NONE,
  );
  RxNotifier<String> botUsername = new RxNotifier("Bot");
  RxNotifier<bool> botTyping = new RxNotifier(false);
  RxList<WsMessage> messages = new RxList(List());

  Future<void> onInitAndListenStream(String idChat) async {
    connectionStatus.value = ConnectionStatus.WAITING;
    connection = ChatConnection(
      url: "$WSS_BASE_URL/ws/chat/$idChat/",
      username: _username,
      avatarUrl: _avatarUrl,
    );
    omnisaudeChatbot = OmnisaudeChatbot(connection: connection);
    streamController = await connection.onInitSession();
    streamController.stream.listen(
      (message) async {
        messages.insert(0, message);
        _onChangeChatGlobalConfigs(message);
        connectionStatus.value = ConnectionStatus.ACTIVE;
      },
      onError: ((onError) {
        connectionStatus.value = ConnectionStatus.ERROR;
      }),
      onDone: () {
        connectionStatus.value = ConnectionStatus.DONE;
      },
    );
  }

  Future<void> _onChangeChatGlobalConfigs(WsMessage message) async {
    if (message.eventContent?.eventType == EventType.TYPING)
      botTyping.value = true;
    else
      botTyping.value = false;
  }

  @override
  void dispose() {
    streamController?.close();
    connection.dispose();
  }
}
