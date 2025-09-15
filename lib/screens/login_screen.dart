import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? registeredEmail;
  final String? registeredPassword;
  final String? registeredFullName;
  final String? registeredAvatarPath;

  const LoginScreen({
    super.key,
    this.registeredEmail,
    this.registeredPassword,
    this.registeredFullName,
    this.registeredAvatarPath,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isValidating = false;
  bool _isPasswordVisible = false;

  String? _currentRegisteredEmail;
  String? _currentRegisteredPassword;
  String? _currentRegisteredFullName;
  String? _currentRegisteredAvatarPath;

  @override
  void initState() {
    super.initState();

    if (widget.registeredEmail != null) {
      _emailController.text = widget.registeredEmail!;
      _currentRegisteredEmail = widget.registeredEmail;
    }
    if (widget.registeredPassword != null) {
      _passwordController.text = widget.registeredPassword!;
      _currentRegisteredPassword = widget.registeredPassword;
    }
    if (widget.registeredFullName != null) {
      _currentRegisteredFullName = widget.registeredFullName;
    }
    if (widget.registeredAvatarPath != null) {
      _currentRegisteredAvatarPath = widget.registeredAvatarPath;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce email y contraseña.'),
        ),
      );
      return;
    }

    setState(() {
      isValidating = true;
    });

    await Future.delayed(const Duration(milliseconds: 2000));

    final String enteredEmail = _emailController.text;
    final String enteredPassword = _passwordController.text;

    bool isAuthenticated = false;

    if (_currentRegisteredEmail == enteredEmail &&
        _currentRegisteredPassword == enteredPassword) {
      isAuthenticated = true;
    } else if (enteredEmail == "admin@example.com" &&
        enteredPassword == "password123") {
      isAuthenticated = true;
      _currentRegisteredFullName = 'Admin User';
      _currentRegisteredAvatarPath = null;
    }

    setState(() {
      isValidating = false;
    });

    if (isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userFullName: _currentRegisteredFullName,
            userAvatarPath: _currentRegisteredAvatarPath,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas o usuario no registrado.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _loginFormKey = GlobalKey<FormState>();

    final txtUser = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce tu email';
        }
        return null;
      },
    );
    final txtPwd = TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce tu contraseña';
        }
        return null;
      },
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/fondo2.jpg"),
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 200,
              child: Text(
                'SOLDADO 117',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: 'Blona',
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      txtUser,
                      const SizedBox(height: 20),
                      txtPwd,
                      const SizedBox(height: 30),
                      IconButton(
                        onPressed: () {
                          if (_loginFormKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        icon: const Icon(Icons.login, size: 35),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );

                          if (result != null &&
                              result is Map<String, dynamic>) {
                            setState(() {
                              _currentRegisteredEmail = result['email'];
                              _currentRegisteredPassword = result['password'];
                              _currentRegisteredFullName = result['fullName'];
                              _currentRegisteredAvatarPath =
                                  result['avatarPath'];
                              _emailController.text = result['email'];
                              _passwordController.text = result['password'];
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cuenta registrada. Intenta iniciar sesión.',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          '¿No tienes cuenta? Regístrate aquí',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset(
                      'assets/loading.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
