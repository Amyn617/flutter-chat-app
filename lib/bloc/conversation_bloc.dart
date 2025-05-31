import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/data/mock_data.dart'; // Vos données mock
import 'package:uuid/uuid.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final Uuid _uuid = Uuid();

  ConversationBloc() : super(ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<ConversationSelected>(_onConversationSelected);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<CreateConversation>(_onCreateConversation);
    on<MarkConversationAsRead>(_onMarkConversationAsRead);
  }

  void _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(seconds: 1));
      // Dans une vraie application, récupérer ceci depuis un repository/API
      emit(
        ConversationLoaded(
          conversations: List.from(
            mockConversations,
          ), // Assurer des copies mutables pour les opérations du bloc
          messagesByConversationId: Map.from(
            mockMessages.map(
              (key, value) => MapEntry(key, List<Message>.from(value)),
            ),
          ), // Copie profonde pour les messages
        ),
      );
    } catch (e) {
      emit(
        ConversationError(
          "Échec du chargement des conversations : ${e.toString()}",
        ),
      );
    }
  }

  void _onConversationSelected(
    ConversationSelected event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      emit(
        currentState.copyWith(
          selectedConversationId: event.selectedConversationId,
        ),
      );
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ConversationState> emit) {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final newMessage = Message(
        id: _uuid.v4(),
        conversationId: event.targetConversationId,
        content: event.messageContent,
        isMe: true,
        timestamp: DateTime.now(),
      );

      // Créer une nouvelle map pour les messages afin d'assurer l'immuabilité
      final updatedMessagesByConversationId = Map<String, List<Message>>.from(
        currentState.messagesByConversationId,
      );
      final currentConversationMessages = List<Message>.from(
        updatedMessagesByConversationId[event.targetConversationId] ?? [],
      );
      currentConversationMessages.add(newMessage);
      updatedMessagesByConversationId[event.targetConversationId] =
          currentConversationMessages;

      // Mettre à jour le dernier message et l'horodatage de la conversation
      final updatedConversations = List<Conversation>.from(
        currentState.conversations,
      );
      final convIndex = updatedConversations.indexWhere(
        (c) => c.id == event.targetConversationId,
      );
      if (convIndex != -1) {
        updatedConversations[convIndex] = updatedConversations[convIndex]
            .copyWith(
              lastMessage: newMessage.content,
              timestamp: newMessage.timestamp,
            );
      }

      // Trier les conversations par message le plus récent
      updatedConversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      emit(
        currentState.copyWith(
          conversations: updatedConversations,
          messagesByConversationId: updatedMessagesByConversationId,
        ),
      );
    }
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final receivedMessage = Message(
        id: _uuid.v4(),
        conversationId: event.targetConversationId,
        content: event.messageContent,
        isMe: false, // Différence clé par rapport à SendMessage
        timestamp: DateTime.now(),
      );

      final updatedMessagesByConversationId = Map<String, List<Message>>.from(
        currentState.messagesByConversationId,
      );
      final currentConversationMessages = List<Message>.from(
        updatedMessagesByConversationId[event.targetConversationId] ?? [],
      );
      currentConversationMessages.add(receivedMessage);
      updatedMessagesByConversationId[event.targetConversationId] =
          currentConversationMessages;

      final updatedConversations = List<Conversation>.from(
        currentState.conversations,
      );
      final convIndex = updatedConversations.indexWhere(
        (c) => c.id == event.targetConversationId,
      );
      if (convIndex != -1) {
        final currentConversation = updatedConversations[convIndex];
        updatedConversations[convIndex] = currentConversation.copyWith(
          lastMessage: receivedMessage.content,
          timestamp: receivedMessage.timestamp,
          unreadCount:
              currentConversation.unreadCount +
              1, // Incrémenter le compteur de non lus
        );
      }

      updatedConversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      emit(
        currentState.copyWith(
          conversations: updatedConversations,
          messagesByConversationId: updatedMessagesByConversationId,
        ),
      );
    }
  }

  void _onCreateConversation(
    CreateConversation event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final newConversation = Conversation(
        id: _uuid.v4(),
        contactName: event.contactName,
        lastMessage: 'Aucun message pour le moment',
        timestamp: DateTime.now(),
        unreadCount: 0,
        avatarUrl: event.avatarUrl,
      );

      final updatedConversations = List<Conversation>.from(
        currentState.conversations,
      );
      updatedConversations.insert(0, newConversation); // Ajouter en haut

      // Initialiser une liste de messages vide pour la nouvelle conversation
      final updatedMessagesByConversationId = Map<String, List<Message>>.from(
        currentState.messagesByConversationId,
      );
      updatedMessagesByConversationId[newConversation.id] = [];

      emit(
        currentState.copyWith(
          conversations: updatedConversations,
          messagesByConversationId: updatedMessagesByConversationId,
        ),
      );
    }
  }

  void _onMarkConversationAsRead(
    MarkConversationAsRead event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final updatedConversations = List<Conversation>.from(
        currentState.conversations,
      );

      final convIndex = updatedConversations.indexWhere(
        (c) => c.id == event.conversationId,
      );

      if (convIndex != -1) {
        updatedConversations[convIndex] = updatedConversations[convIndex]
            .copyWith(unreadCount: 0);

        emit(currentState.copyWith(conversations: updatedConversations));
      }
    }
  }
}
