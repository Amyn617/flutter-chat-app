import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/bloc/conversation_bloc.dart';

/// Écran de création d'une nouvelle conversation
///
/// Cet écran StatefulWidget permet à l'utilisateur de créer une nouvelle
/// conversation en saisissant le nom du contact. Il utilise un formulaire
/// avec validation pour s'assurer que les données saisies sont correctes.
///
/// Fonctionnalités :
/// - Formulaire de saisie avec validation
/// - Bouton de création dans l'AppBar et dans le corps
/// - Retour automatique à l'écran précédent après création
/// - Affichage d'un message de confirmation (SnackBar)
/// - Gestion des erreurs de saisie
class NewConversationScreen extends StatefulWidget {
  const NewConversationScreen({super.key});

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen>
    with TickerProviderStateMixin {
  /// Contrôleur pour le champ de saisie du nom du contact
  /// Permet de récupérer et manipuler le texte saisi par l'utilisateur
  final TextEditingController _nameController = TextEditingController();

  /// Clé globale pour le formulaire, utilisée pour la validation
  /// Permet d'accéder aux méthodes validate() et save() du formulaire
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();
  late AnimationController _slideController;
  late AnimationController _fabController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fabAnimation;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _nameController.addListener(() {
      final isValid = _nameController.text.trim().length >= 2;
      if (isValid != _isFormValid) {
        setState(() => _isFormValid = isValid);
        if (isValid) {
          _fabController.forward();
        } else {
          _fabController.reverse();
        }
      }
    });

    // Démarrer l'animation d'entrée
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    _slideController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  /// Méthode appelée lors de la création d'une nouvelle conversation
  ///
  /// Processus :
  /// 1. Valide le formulaire (vérifie que le nom n'est pas vide)
  /// 2. Envoie l'événement CreateConversation au BLoC
  /// 3. Ferme l'écran actuel (retour à la liste des conversations)
  /// 4. Affiche un message de confirmation à l'utilisateur
  void _createConversation() async {
    if (_formKey.currentState!.validate()) {
      // Animation de sortie
      _slideController.reverse();

      // Envoi de l'événement au BLoC avec le nom saisi (sans espaces superflus)
      context.read<ConversationBloc>().add(
        CreateConversation(contactName: _nameController.text.trim()),
      );

      // Attendre la fin de l'animation avant de fermer
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        // Retour à l'écran précédent
        Navigator.pop(context);

        // Affichage d'un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Conversation avec ${_nameController.text.trim()} créée !',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nouvelle Conversation',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _createConversation : null,
            child: Text(
              'Créer',
              style: TextStyle(
                color: _isFormValid ? colorScheme.primary : colorScheme.outline,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _slideController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Icône et titre
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primaryContainer,
                                colorScheme.primaryContainer.withValues(
                                  alpha: 0.7,
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_add,
                            size: 40,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Créer une conversation',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entrez le nom de la personne avec qui\nvous souhaitez discuter',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.outline,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Champ de saisie
                  Text(
                    'Nom du Contact',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Entrez le nom du contact',
                      hintStyle: TextStyle(color: colorScheme.outline),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.error,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un nom de contact';
                      }
                      if (value.trim().length < 2) {
                        return 'Le nom doit comporter au moins 2 caractères';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _createConversation(),
                  ),

                  const SizedBox(height: 32),

                  // Bouton de création
                  ScaleTransition(
                    scale: _fabAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _isFormValid ? _createConversation : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          disabledBackgroundColor:
                              colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: colorScheme.outline,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: _isFormValid ? 2 : 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color:
                                  _isFormValid
                                      ? colorScheme.onPrimary
                                      : colorScheme.outline,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Créer la Conversation',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    _isFormValid
                                        ? colorScheme.onPrimary
                                        : colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
