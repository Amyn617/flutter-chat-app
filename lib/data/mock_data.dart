import 'package:chat_app/models/models.dart';
import 'package:uuid/uuid.dart';

/// Instance globale du générateur UUID pour créer des identifiants uniques
///
/// Utilisée pour générer des IDs uniques pour les conversations et messages
/// dans les données de test. En production, ces IDs viendraient du serveur.
final uuid = Uuid();

/// Liste des conversations de démonstration
///
/// Ces données simulent ce qui serait normalement récupéré depuis :
/// - Une API REST
/// - Une base de données locale (SQLite)
/// - Un service de cache (SharedPreferences)
///
/// Chaque conversation contient :
/// - Un ID unique
/// - Le nom du contact
/// - Le dernier message échangé
/// - L'horodatage du dernier message
/// - Le nombre de messages non lus
List<Conversation> mockConversations = [
  Conversation(
    id: 'conv1',
    contactName: 'Hakim Ziyech',
    lastMessage: 'On se voit demain à l\'entraînement !',
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    unreadCount: 2,
  ),
  Conversation(
    id: 'conv2',
    contactName: 'Achraf Hakimi',
    lastMessage: 'Prêt pour le match ?',
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
    unreadCount: 1,
  ),
  Conversation(
    id: 'conv3',
    contactName: 'Yassine Bounou',
    lastMessage: 'Toujours rester concentré.',
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    unreadCount: 0,
  ),
  Conversation(
    id: 'conv4',
    contactName: 'Sofyan Amrabat',
    lastMessage: 'Faut tout donner au milieu !',
    timestamp: DateTime.now().subtract(Duration(hours: 3)),
    unreadCount: 3,
  ),
  Conversation(
    id: 'conv5',
    contactName: 'Noussair Mazraoui',
    lastMessage: 'Belle action hier !',
    timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    unreadCount: 0,
  ),
  Conversation(
    id: 'conv6',
    contactName: 'Romain Saïss',
    lastMessage: 'La défense est prête.',
    timestamp: DateTime.now().subtract(Duration(hours: 6)),
    unreadCount: 1,
  ),
  Conversation(
    id: 'conv7',
    contactName: 'Azzedine Ounahi',
    lastMessage: 'J\'ai trouvé une meilleure stratégie.',
    timestamp: DateTime.now().subtract(Duration(hours: 2)),
    unreadCount: 0,
  ),
  Conversation(
    id: 'conv8',
    contactName: 'Coach Walid Regragui',
    lastMessage: 'Soyez prêts mentalement et physiquement.',
    timestamp: DateTime.now().subtract(Duration(minutes: 45)),
    unreadCount: 5,
  ),
];

/// Map des messages groupés par ID de conversation
///
/// Cette structure de données organise tous les messages par conversation
/// pour un accès rapide et efficace. La clé est l'ID de la conversation,
/// la valeur est la liste des messages de cette conversation.
///
/// Structure :
/// {
///   "conv1": [Message1, Message2, Message3, ...],
///   "conv2": [Message4, Message5, ...],
///   "conv3": [Message6, Message7, ...]
///   ...
/// }
///
/// Avantages de cette structure :
/// - Accès O(1) aux messages d'une conversation spécifique
/// - Facilite l'ajout de nouveaux messages
/// - Permet de gérer facilement les conversations vides
/// - Optimise les performances de l'interface utilisateur

Map<String, List<Message>> mockMessages = {
  'conv1': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv1',
      content: 'Salut Hakim, bien joué pour le match !',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv1',
      content: 'Merci frère ! On se voit demain à l\'entraînement !',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
  ],
  'conv2': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv2',
      content: 'Yo Achraf, prêt pour le match ?',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv2',
      content: 'Toujours prêt ! À fond !',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
  ],
  'conv3': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv3',
      content: 'Toujours rester concentré.',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv3',
      content: 'Exactement, la discipline c\'est la clé.',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(days: 1, minutes: -30)),
    ),
  ],
  'conv4': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv4',
      content: 'Faut tout donner au milieu !',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
    ),
  ],
  'conv5': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv5',
      content: 'Belle action hier ! Continue comme ça.',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv5',
      content: 'Merci frère 💪',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 29)),
    ),
  ],
  'conv6': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv6',
      content: 'La défense est prête.',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 6)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv6',
      content: 'On compte sur toi capitaine !',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 5, minutes: 50)),
    ),
  ],
  'conv7': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv7',
      content: 'J\'ai trouvé une meilleure stratégie.',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv7',
      content: 'On en parle après l\'entraînement !',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
    ),
  ],
  'conv8': [
    Message(
      id: uuid.v4(),
      conversationId: 'conv8',
      content: 'Soyez prêts mentalement et physiquement.',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 45)),
    ),
    Message(
      id: uuid.v4(),
      conversationId: 'conv8',
      content: 'Compris coach !',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 43)),
    ),
  ],
};
