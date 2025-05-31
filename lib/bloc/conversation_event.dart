part of 'conversation_bloc.dart';

/// Classe abstraite de base pour tous les événements du ConversationBloc
///
/// Dans l'architecture BLoC, les événements représentent les actions
/// déclenchées par l'interface utilisateur ou par des sources externes.
/// Ils sont envoyés au BLoC via la méthode add() et déclenchent des
/// changements d'état.
abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

/// Événement pour charger la liste des conversations depuis la source de données
///
/// Cet événement est généralement déclenché :
/// - Au démarrage de l'application (dans main.dart)
/// - Lors d'un rafraîchissement manuel de la liste
/// - Après une reconnexion réseau
class LoadConversations extends ConversationEvent {}

/// Événement déclenché quand l'utilisateur sélectionne une conversation
///
/// Cet événement met à jour l'état pour indiquer quelle conversation
/// est actuellement active. Il est utilisé pour :
/// - Marquer la conversation comme lue
/// - Naviguer vers l'écran de chat correspondant
/// - Mettre en surbrillance la conversation sélectionnée
class ConversationSelected extends ConversationEvent {
  /// Identifiant de la conversation sélectionnée
  final String selectedConversationId;

  const ConversationSelected(this.selectedConversationId);

  @override
  List<Object?> get props => [selectedConversationId];
}

/// Événement déclenché quand l'utilisateur envoie un message
///
/// Cet événement est déclenché quand l'utilisateur :
/// - Tape sur le bouton d'envoi dans l'interface de chat
/// - Appuie sur Entrée dans le champ de saisie
///
/// Le BLoC traite cet événement en :
/// 1. Créant un nouvel objet Message avec isMe=true
/// 2. L'ajoutant à la liste des messages de la conversation
/// 3. Mettant à jour le dernier message et l'horodatage de la conversation
/// 4. Réorganisant les conversations par ordre chronologique
class SendMessage extends ConversationEvent {
  /// Identifiant de la conversation cible
  final String targetConversationId;

  /// Contenu textuel du message à envoyer
  final String messageContent;

  const SendMessage({
    required this.targetConversationId,
    required this.messageContent,
  });

  @override
  List<Object?> get props => [targetConversationId, messageContent];
}

/// Événement simulant la réception d'un message externe
///
/// Dans une vraie application, cet événement serait déclenché par :
/// - Une notification push
/// - Une connexion WebSocket
/// - Un polling périodique du serveur
///
/// Ici, il est déclenché manuellement via le bouton dans l'AppBar
/// pour démontrer la fonctionnalité de réception de messages.
///
/// Le BLoC traite cet événement en :
/// 1. Créant un nouvel objet Message avec isMe=false
/// 2. L'ajoutant à la liste des messages de la conversation
/// 3. Incrémentant le compteur de messages non lus
/// 4. Mettant à jour le dernier message et l'horodatage
class ReceiveMessage extends ConversationEvent {
  /// Identifiant de la conversation cible
  final String targetConversationId;

  /// Contenu textuel du message reçu
  final String messageContent;

  const ReceiveMessage({
    required this.targetConversationId,
    required this.messageContent,
  });

  @override
  List<Object?> get props => [targetConversationId, messageContent];
}

/// Événement pour créer une nouvelle conversation
///
/// Cet événement est déclenché quand l'utilisateur :
/// - Tape sur le bouton "+" dans l'AppBar ou le FAB
/// - Remplit le formulaire de création de conversation
/// - Confirme la création
///
/// Le BLoC traite cet événement en :
/// 1. Générant un nouvel ID unique pour la conversation
/// 2. Créant un objet Conversation avec les informations fournies
/// 3. L'ajoutant en tête de la liste des conversations
/// 4. Initialisant une liste vide de messages pour cette conversation
class CreateConversation extends ConversationEvent {
  /// Nom du contact pour la nouvelle conversation
  final String contactName;

  /// URL optionnelle de l'avatar du contact
  final String? avatarUrl;

  const CreateConversation({required this.contactName, this.avatarUrl});

  @override
  List<Object?> get props => [contactName, avatarUrl];
}

/// Événement pour marquer une conversation comme lue
///
/// Cet événement est automatiquement déclenché quand :
/// - L'utilisateur ouvre une conversation (tape sur un élément de la liste)
/// - L'utilisateur navigue vers l'écran de chat
///
/// Le BLoC traite cet événement en :
/// 1. Trouvant la conversation correspondante dans la liste
/// 2. Remettant son compteur unreadCount à 0
/// 3. Mettant à jour l'état pour refléter ce changement
///
/// Ceci fait disparaître le badge rouge de notification dans la liste.
class MarkConversationAsRead extends ConversationEvent {
  /// Identifiant de la conversation à marquer comme lue
  final String conversationId;

  const MarkConversationAsRead(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}
