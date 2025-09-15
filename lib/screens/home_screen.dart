import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pmsen_2025/utils/value_listener.dart'; // Asume que esta ruta es correcta

// NUEVOS IMPORTS
import 'package:translucent_navigation_bar/translucent_navigation_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String? userFullName;
  final String? userAvatarPath;

  const HomeScreen({super.key, this.userFullName, this.userAvatarPath});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. CAMBIO DE ESTADO: Usamos un índice entero en lugar de un enum
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 2. LISTA DE PANTALLAS: Reemplaza al método _getScreenForTab
  List<Widget> _buildScreens() {
    return [
      // Pantalla de Inicio
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido, ${widget.userFullName ?? 'Usuario'}!",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text("Menú de opciones", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      // Pantalla de Favoritos
      const Center(child: Text("Favoritos", style: TextStyle(fontSize: 20))),
      // Pantalla de Búsqueda
      const Center(child: Text("Buscar", style: TextStyle(fontSize: 20))),
      // Pantalla de Perfil
      const Center(child: Text("Perfil", style: TextStyle(fontSize: 20))),
    ];
  }

  // 3. NUEVA FUNCIÓN DE TAP: Actualiza el índice y controla el PageController
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.userFullName ?? 'Inicio'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  widget.userAvatarPath != null &&
                      File(widget.userAvatarPath!).existsSync()
                  ? FileImage(File(widget.userAvatarPath!))
                  : null,
              child:
                  widget.userAvatarPath == null ||
                      !File(widget.userAvatarPath!).existsSync()
                  ? const Icon(Icons.person, size: 25, color: Colors.white)
                  : null,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: ValueListener.isDark,
            builder: (context, isDarkMode, child) {
              return IconButton(
                icon: Icon(isDarkMode ? Icons.sunny : Icons.nightlight),
                onPressed: () {
                  ValueListener.isDark.value = !isDarkMode;
                },
              );
            },
          ),
        ],
      ),
      endDrawer: const Drawer(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildScreens(),
      ),

      // SOLUCIÓN CORRECTA AQUÍ
      bottomNavigationBar: Container(
        height: 110.0, // <-- AQUÍ ESTÁ LA CORRECCIÓN
        child: TranslucentNavigationBar(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            TranslucentNavigationBarItem(iconData: PhosphorIcons.houseBold),
            TranslucentNavigationBarItem(iconData: PhosphorIcons.heartBold),
            TranslucentNavigationBarItem(
              iconData: PhosphorIcons.magnifyingGlassBold,
            ),
            TranslucentNavigationBarItem(iconData: PhosphorIcons.userBold),
          ],
        ),
      ),
    );
  }
}
