import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/bloc/conversation_bloc.dart';
import 'package:chat_app/ui/screens/conversation_list_screen.dart';

/// Point d'entrée principal de l'application Flutter
/// Cette fonction initialise et lance l'application de chat
void main() {
  runApp(const MyApp());
}

/// Widget racine de l'application de chat
///
/// Cette classe configure l'architecture BLoC au niveau global et définit
/// le thème de l'application. Elle utilise BlocProvider pour fournir
/// l'instance ConversationBloc à tous les widgets enfants de l'arbre.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Création et configuration du BLoC principal pour la gestion des conversations
      // Le BLoC est créé une seule fois et partagé dans toute l'application
      create: (context) => ConversationBloc()..add(LoadConversations()),
      child: MaterialApp(
        // Configuration de l'interface utilisateur
        debugShowCheckedModeBanner:
            false, // Masque la bannière "DEBUG" en mode développement
        title: 'Simple Chat App', // Titre de l'application
        // Définition du thème global de l'application
        theme: ThemeData(
          primarySwatch: Colors.teal, // Couleur principale (sarcelle)
          visualDensity:
              VisualDensity
                  .adaptivePlatformDensity, // Densité adaptative selon la plateforme
        ),

        // Écran d'accueil : liste des conversations
        home: const ConversationListScreen(),
      ),
    );
  }
}
