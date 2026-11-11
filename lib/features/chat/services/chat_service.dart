/// Chat message entity for real-time driver-passenger messaging.
class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

/// Chat service contract prepared for future WebSockets or Firebase real-time integration.
abstract class ChatService {
  Future<void> sendMessage({required String rideId, required String text});
  Stream<List<ChatMessage>> getMessages(String rideId);
}

/// Placeholder implementation of [ChatService].
class PlaceholderChatService implements ChatService {
  @override
  Future<void> sendMessage({
    required String rideId,
    required String text,
  }) async {
    // Ready for future socket / Firestore integration
  }

  @override
  Stream<List<ChatMessage>> getMessages(String rideId) {
    return Stream.value([
      ChatMessage(
        id: 'msg_1',
        senderId: 'driver',
        text: 'Hi! I am waiting near the metro entrance gate 2.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'passenger',
        text: 'Great, arriving in 2 minutes!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ]);
  }
}
