import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../screen/tenant_screen.dart';
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/login/login_screen.dart';
import '../../screen/director/profesor_list_screen.dart';
import '../../screen/tenant/director_tenant_screen.dart';
import '../../screen/home_screen.dart';
import '../../screen/curso/curso_list_screen.dart';
import '../../screen/paralelo/paralelo_list_screen.dart';
import '../../screen/tenant/tenant_list_screen.dart';

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
        const TenantListScreen(),
        const HomeScreen(),
        const TenantScreen(),
        const SizedBox(), // placeholder
      ];

      items = const [
        NavigationDestination(
          icon: Icon(Icons.school),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Colegios',
        ),
      ];
    }

    // ================= DIRECTOR =================
    else if (role == 'director') {
      screens = [
        const SubjectListScreen(),
        const ProfesorListScreen(),
        const CursoListScreen(),
        const ParaleloListScreen(),
       /*  const DirectorTenantScreen(),  */
         DirectorTenantScreen(
          onSuccess: () => setState(() => selectedIndex = 0),
    ),
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
        NavigationDestination(
          icon: Icon(Icons.class_),
          label: 'Cursos',          
        ),
        NavigationDestination(
          icon: Icon(Icons.account_tree),
          label: 'Paralelos'),
        NavigationDestination(
          icon: Icon(Icons.school),
          label: 'Mi Colegio',
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