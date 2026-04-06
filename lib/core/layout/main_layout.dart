import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../screen/tenant_screen.dart';
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/login/login_screen.dart';
import '../../screen/profesor/profesor_list_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final role = auth.role;

    List<Widget> screens = [];
    List<NavigationDestination> items = [];

    // ================= SUPER ADMIN =================
    if (role == 'super-admin') {
      screens = [
        const TenantScreen(),
        const SizedBox(), // placeholder
      ];

      items = const [
        NavigationDestination(
          icon: Icon(Icons.school),
          label: 'Colegios',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Opciones',
        ),
      ];
    }

    // ================= DIRECTOR =================
    else if (role == 'director') {
      screens = [
        const SubjectListScreen(),
        const ProfesorListScreen(),
         // placeholder
      ];

      items = const [
        NavigationDestination(
          icon: Icon(Icons.menu_book),
          label: 'Materias',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profesores',
  ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role == 'super-admin'
              ? 'Panel Administrador'
              : 'Panel Director',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),

      body: screens[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: items,
      ),
    );
  }
}