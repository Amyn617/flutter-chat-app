part of 'conversation_bloc.dart';

/// Classe abstraite de base pour tous les états du ConversationBloc
///
/// Dans l'architecture BLoC, les états représentent les différentes
/// phases de l'interface utilisateur. Ils sont immuables et utilisent
/// Equatable pour optimiser les comparaisons et éviter les reconstructions
/// inutiles de l'interface utilisateur.
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

/// État initial du BLoC avant tout chargement de données
///
/// Cet état est émis :
/// - À l'initialisation du BLoC
/// - Avant que l'événement LoadConversations ne soit traité
///
/// L'interface utilisateur affiche généralement un indicateur
/// de chargement ou un écran de démarrage dans cet état.
class ConversationInitial extends ConversationState {}

/// État indiquant que les données sont en cours de chargement
///
/// Cet état est émis quand :
/// - L'événement LoadConversations est en cours de traitement
/// - Une opération asynchrone (simulation réseau) est en cours
///
/// L'interface utilisateur affiche un CircularProgressIndicator
/// ou un autre indicateur de chargement pendant cet état.
class ConversationLoading extends ConversationState {}

/// État principal contenant toutes les données chargées de l'application
///
/// Cet état est émis quand :
/// - Les conversations ont été chargées avec succès
/// - Un message a été envoyé ou reçu
/// - Une conversation a été créée ou modifiée
/// - Une conversation a été marquée comme lue
///
/// C'est l'état le plus important car il contient toutes les données
/// nécessaires pour afficher l'interface utilisateur complète.
class ConversationLoaded extends ConversationState {
  /// Liste de toutes les conversations, triée par ordre chronologique
  /// (la plus récente en premier)
  final List<Conversation> conversations;

  /// Map associant chaque ID de conversation à sa liste de messages
  ///
  /// Structure : {
  ///   "conv1": [Message1, Message2, ...],
  ///   "conv2": [Message3, Message4, ...],
  ///   ...
  /// }
  ///
  /// Cette structure permet un accès rapide aux messages d'une conversation
  /// spécifique sans avoir à parcourir toute la liste.
  final Map<String, List<Message>> messagesByConversationId;

  /// ID de la conversation actuellement sélectionnée (peut être null)
  ///
  /// Utilisé pour :
  /// - Mettre en surbrillance la conversation active dans la liste
  /// - Récupérer les messages à afficher dans l'écran de chat
  /// - Maintenir l'état de navigation entre les écrans
  final String? selectedConversationId;

  /// Constructeur avec valeurs par défaut pour un état vide
  const ConversationLoaded({
    this.conversations = const [],
    this.messagesByConversationId = const {},
    this.selectedConversationId,
  });

  List<Message> get messagesForSelectedConversation {
    if (selectedConversationId == null) return [];
    return messagesByConversationId[selectedConversationId!] ?? [];
  }

  Conversation? get selectedConversation {
    if (selectedConversationId == null) return null;
    try {
      return conversations.firstWhere((c) => c.id == selectedConversationId);
    } catch (e) {
      return null; // Ne devrait pas arriver si les IDs sont cohérents
    }
  }

  ConversationLoaded copyWith({
    List<Conversation>? conversations,
    Map<String, List<Message>>? messagesByConversationId,
    String?
    selectedConversationId, // Utiliser ValueGetter pour autoriser null explicite
    bool forceNullSelectedConversationId = false,
  }) {
    return ConversationLoaded(
      conversations: conversations ?? this.conversations,
      messagesByConversationId:
          messagesByConversationId ?? this.messagesByConversationId,
      selectedConversationId:
          forceNullSelectedConversationId
              ? null
              : (selectedConversationId ?? this.selectedConversationId),
    );
  }

  @override
  List<Object?> get props => [
    conversations,
    messagesByConversationId,
    selectedConversationId,
  ];
}

class ConversationError extends ConversationState {
  final String errorMessage;

  const ConversationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
