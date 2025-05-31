import 'package:equatable/equatable.dart';

/// Modèle de données représentant une conversation dans l'application de chat
///
/// Cette classe utilise Equatable pour permettre la comparaison d'objets
/// basée sur les valeurs plutôt que sur les références. Ceci est essentiel
/// pour le bon fonctionnement du BLoC qui compare les états pour décider
/// s'il faut reconstruire l'interface utilisateur.
class Conversation extends Equatable {
  /// Identifiant unique de la conversation (UUID)
  final String id;

  /// Nom du contact avec qui on discute
  final String contactName;

  /// Dernier message envoyé dans cette conversation
  /// Affiché dans la liste des conversations comme aperçu
  final String lastMessage;

  /// Horodatage du dernier message
  /// Utilisé pour trier les conversations par ordre chronologique
  final DateTime timestamp;

  /// Nombre de messages non lus dans cette conversation
  /// Affiché sous forme de badge rouge dans la liste
  final int unreadCount;

  /// URL optionnelle de l'avatar du contact
  /// Si null, on affiche les initiales du nom dans un cercle coloré
  final String? avatarUrl;

  /// Constructeur de la classe Conversation
  ///
  /// [id], [contactName], [lastMessage] et [timestamp] sont obligatoires
  /// [unreadCount] par défaut à 0 (aucun message non lu)
  /// [avatarUrl] est optionnel
  const Conversation({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  /// Méthode copyWith pour créer une nouvelle instance avec des valeurs modifiées
  ///
  /// Cette méthode est essentielle dans l'architecture BLoC car elle permet
  /// de créer des copies immutables d'objets avec certaines propriétés modifiées.
  /// L'immutabilité garantit que les états du BLoC sont prévisibles et traçables.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// final updatedConversation = conversation.copyWith(
  ///   unreadCount: 0, // Marquer comme lu
  ///   lastMessage: "Nouveau message"
  /// );
  /// ```
  Conversation copyWith({
    String? id,
    String? contactName,
    String? lastMessage,
    DateTime? timestamp,
    int? unreadCount,
    String? avatarUrl,
  }) {
    return Conversation(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Liste des propriétés utilisées par Equatable pour la comparaison
  ///
  /// Equatable utilise cette liste pour déterminer si deux instances
  /// de Conversation sont égales. Si toutes les propriétés listées
  /// sont identiques, les objets sont considérés comme égaux.
  /// Ceci évite les reconstructions inutiles de l'interface utilisateur.
  @override
  List<Object?> get props => [
    id,
    contactName,
    lastMessage,
    timestamp,
    unreadCount,
    avatarUrl,
  ];
}
