import 'package:equatable/equatable.dart';

/// Modèle de données représentant un message individuel dans une conversation
///
/// Cette classe utilise Equatable pour permettre la comparaison efficace
/// des messages, ce qui est crucial pour les performances de l'interface
/// utilisateur lors des mises à jour de la liste des messages.
class Message extends Equatable {
  /// Identifiant unique du message (UUID)
  final String id;

  /// Identifiant de la conversation à laquelle appartient ce message
  /// Utilisé pour regrouper les messages par conversation
  final String conversationId;

  /// Contenu textuel du message
  final String content;

  /// Indique si le message a été envoyé par l'utilisateur actuel
  ///
  /// - true : message envoyé par moi (aligné à droite, bulle bleue/sarcelle)
  /// - false : message reçu d'un contact (aligné à gauche, bulle grise)
  /// Cette propriété détermine l'apparence et la position de la bulle de message
  final bool isMe;

  /// Horodatage de création/envoi du message
  /// Affiché sous chaque message au format HH:mm
  final DateTime timestamp;

  /// Constructeur de la classe Message
  ///
  /// Tous les paramètres sont obligatoires car un message doit avoir
  /// un identifiant, appartenir à une conversation, avoir un contenu,
  /// indiquer son expéditeur et avoir un horodatage.
  const Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isMe,
    required this.timestamp,
  });

  /// Liste des propriétés utilisées par Equatable pour la comparaison
  ///
  /// Permet d'optimiser les reconstructions de l'interface utilisateur
  /// en ne redessinant que les messages qui ont réellement changé.
  @override
  List<Object?> get props => [id, conversationId, content, isMe, timestamp];
}
