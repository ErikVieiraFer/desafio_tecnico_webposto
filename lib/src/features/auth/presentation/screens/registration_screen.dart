import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/stores/registration_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

final registrationStore = RegistrationStore(authStore);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final List<ReactionDisposer> _disposers;

  @override
  void initState() {
    super.initState();

    _disposers = [
      reaction((_) => registrationStore.error, (String? error) {
        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
        }
      }),
      reaction((_) => registrationStore.isRegistrationSuccess, (bool success) {
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crie sua Conta',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 48.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: registrationStore.setName,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
              ),
              const SizedBox(height: 16.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: registrationStore.setEmail,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: registrationStore.setPassword,
                  decoration: const InputDecoration(
                    labelText: 'Senha (mín. 6 caracteres)',
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: registrationStore.setConfirmPassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 32.0),
              Observer(
                builder: (_) {
                  return ElevatedButton(
                    onPressed: registrationStore.isLoading
                        ? null
                        : registrationStore.register,
                    child: registrationStore.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Cadastrar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
