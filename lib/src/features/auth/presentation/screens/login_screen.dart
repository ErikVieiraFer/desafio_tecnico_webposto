import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/screens/registration_screen.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

final loginStore = LoginStore(authStore);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final ReactionDisposer _errorDisposer;

  @override
  void initState() {
    super.initState();
    _errorDisposer = reaction(
      (_) => loginStore.error,
      (String? error) {
        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _errorDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 48.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: loginStore.setEmail,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16.0),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: loginStore.setPassword,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 32.0),
              Observer(
                builder: (_) {
                  return ElevatedButton(
                    onPressed: loginStore.isLoading ? null : loginStore.login,
                    child: loginStore.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Entrar'),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OU',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () => loginStore.loginWithGoogle(),
                icon: const Icon(Icons.g_mobiledata), 
                label: const Text('Entrar com Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                  );
                },
                child: Text(
                  'Não tem uma conta? Cadastre-se',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withAlpha(204),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
