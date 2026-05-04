import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';
import '../../screen/tenant_screen.dart';
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/login/login_screen.dart';
import '../../screen/director/profesor_list_screen.dart';
import '../../screen/curso/curso_list_screen.dart';
import '../../screen/paralelo/paralelo_list_screen.dart';
import '../../screen/tenant/tenant_list_screen.dart';
import '../../screen/tenant/my_tenant_screen.dart';
import '../layout/home_dashboard.dart';

class MainLayout extends StatefulWidget {
<<<<<<< Updated upstream
  const MainLayout({super.key});
=======
  final Widget child;
  final String location;

  const MainLayout({
    super.key,
    required this.child,
    required this.location,
  });
>>>>>>> Stashed changes

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
<<<<<<< Updated upstream
  int selectedIndex = 0;

  static const _purple     = Color(0xFF4F46E5);
  static const _purpleSoft = Color(0xFFF0EFFF);
  static const _gray400    = Color(0xFF9CA3AF);
  static const _bgPage     = Color(0xFFF5F7FB);

  @override
  void initState() {
    super.initState();
    // Carga el tenant al entrar para tener nombre y logo en el AppBar
=======
  static const Color primary = Color(0xFF4F46E5);
  static const Color bg = Color(0xFFF5F7FB);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

>>>>>>> Stashed changes
    Future.microtask(() {
      final auth = context.read<AuthViewModel>();

      if (auth.role == 'director') {
        final vm = context.read<TenantViewModel>();
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
        if (vm.currentTenant == null && !vm.loading) {
          vm.loadMyTenant();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final tenant = context.watch<TenantViewModel>();
    final role = auth.role ?? '';

<<<<<<< Updated upstream
    List<Widget>  screens = [];
    List<_NavTab> tabs    = [];

    // ── SUPER ADMIN ──────────────────────────────────────────────────────
    if (role == 'super-admin') {
      screens = [
        HomeDashboard(onNavigate: (i) => setState(() => selectedIndex = i)),
        const TenantListScreen(),
        const TenantScreen(),
      ];
      tabs = const [
        _NavTab(Icons.home_outlined,        Icons.home,         'Inicio'),
        _NavTab(Icons.school_outlined,       Icons.school,       'Colegios'),
        _NavTab(Icons.add_business_outlined, Icons.add_business, 'Crear'),
      ];
    }

    // ── DIRECTOR ─────────────────────────────────────────────────────────
    else if (role == 'director') {
      screens = [
        HomeDashboard(onNavigate: (i) => setState(() => selectedIndex = i)),
        const SubjectListScreen(),
        const ProfesorListScreen(),
        const CursoListScreen(),
        const ParaleloListScreen(),
        const MyTenantScreen(),
      ];
      tabs = const [
        _NavTab(Icons.home_outlined,          Icons.home,         'Inicio'),
        _NavTab(Icons.menu_book_outlined,     Icons.menu_book,    'Materias'),
        _NavTab(Icons.person_outline,         Icons.person,       'Profesores'),
        _NavTab(Icons.class_outlined,         Icons.class_,       'Cursos'),
        _NavTab(Icons.account_tree_outlined,  Icons.account_tree, 'Paralelos'),
        _NavTab(Icons.school_outlined,        Icons.school,       'Colegio'),
      ];
    }
=======
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
>>>>>>> Stashed changes

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: bg,

<<<<<<< Updated upstream
      // ── AppBar ─────────────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: Container(
          color: _purple,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Logo: imagen del tenant o fallback con iniciales
                  _buildLogo(role, tenantVM),
                  const SizedBox(width: 10),

                  // Nombre dinámico del colegio
                  Expanded(child: _buildTitle(role, tenantVM)),

                  // Avatar → logout
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context, auth),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(auth.user?.name ?? '?'),
                        style: const TextStyle(
                          color: _purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
=======
          drawer: isDesktop ? null : _buildDrawer(context, role),

          appBar: _buildTopBar(context, auth, tenant, isDesktop),

          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context, role),
              Expanded(child: widget.child),
            ],
>>>>>>> Stashed changes
          ),

<<<<<<< Updated upstream
      // ── Body ───────────────────────────────────────────────────────────
      body: screens.isNotEmpty ? screens[selectedIndex] : const SizedBox(),

      // ── Bottom nav ─────────────────────────────────────────────────────
      bottomNavigationBar: tabs.isEmpty ? null : _buildBottomNav(tabs),
    );
  }

  // ── AppBar: logo ─────────────────────────────────────────────────────────
  Widget _buildLogo(String? role, TenantViewModel tenantVM) {
    final logoUrl = role == 'director' ? tenantVM.currentTenant?.logoUrl : null;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          logoUrl,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _logoFallback(),
        ),
      );
    }
    return _logoFallback();
  }

  Widget _logoFallback() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.school_outlined, color: Colors.white, size: 20),
    );
  }

  // ── AppBar: título ───────────────────────────────────────────────────────
  Widget _buildTitle(String? role, TenantViewModel tenantVM) {
    final String title;
    final String subtitle;

    if (role == 'director') {
      title    = tenantVM.currentTenant?.name ?? 'Cargando...';
      subtitle = 'Panel Director';
    } else {
      title    = 'Admin Panel';
      subtitle = 'Super Administrador';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11,
          ),
        ),
=======
          bottomNavigationBar:
              isDesktop ? null : _buildBottomNav(context, role),
        );
      },
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================
  PreferredSizeWidget _buildTopBar(
    BuildContext context,
    AuthViewModel auth,
    TenantViewModel tenant,
    bool isDesktop,
  ) {
    final role = auth.role ?? '';

    final title = role == 'director'
        ? (tenant.currentTenant?.name ?? 'Mi Colegio')
        : role == 'super-admin'
            ? 'Panel Admin'
            : 'Mi Panel';

    final subtitle = role == 'director'
        ? 'Panel Director'
        : role == 'super-admin'
            ? 'Super Administrador'
            : role.toUpperCase();

    return AppBar(
      backgroundColor: primary,
      elevation: 0,
      automaticallyImplyLeading: !isDesktop,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showLogoutDialog(context),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _initials(auth.user?.name ?? '?'),
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
>>>>>>> Stashed changes
      ],
    );
  }

<<<<<<< Updated upstream
  // ── Bottom nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav(List<_NavTab> tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: List.generate(tabs.length, (i) {
              final tab    = tabs[i];
              final active = selectedIndex == i;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? _purpleSoft : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            active ? tab.activeIcon : tab.icon,
                            key: ValueKey(active),
                            size: 22,
                            color: active ? _purple : _gray400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? _purple : _gray400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width:  active ? 4 : 0,
                          height: active ? 4 : 0,
                          decoration: const BoxDecoration(
                            color: _purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
=======
  // ==========================================================
  // SIDEBAR DESKTOP
  // ==========================================================
  Widget _buildSidebar(BuildContext context, String role) {
    final items = _menuItems(role);

    return Container(
      width: 270,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 18),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.dashboard_outlined, color: primary),
                SizedBox(width: 10),
                Text(
                  'Menú Principal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((e) {
                final active = widget.location.startsWith(e.route);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Material(
                    color: active
                        ? primary.withOpacity(.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: Icon(
                        e.icon,
                        color: active ? primary : Colors.grey[700],
                      ),
                      title: Text(
                        e.label,
                        style: TextStyle(
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? primary : Colors.black87,
                        ),
                      ),
                      onTap: () => context.go(e.route),
>>>>>>> Stashed changes
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DRAWER MOBILE
  // ==========================================================
  Widget _buildDrawer(BuildContext context, String role) {
    final items = _menuItems(role);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Menú',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            Expanded(
              child: ListView(
                children: items.map((e) {
                  return ListTile(
                    leading: Icon(e.icon),
                    title: Text(e.label),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(e.route);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< Updated upstream
  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> _showLogoutDialog(BuildContext ctx, AuthViewModel auth) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
=======
  // ==========================================================
  // BOTTOM NAV MOBILE POR ROL
  // ==========================================================
  Widget _buildBottomNav(BuildContext context, String role) {
    List<_MenuItem> tabs;

    if (role == 'super-admin') {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Colegios', Icons.school_outlined, '/colegios'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    } else if (role == 'profesor' || role == 'estudiante') {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Avisos', Icons.campaign_outlined, '/circulares'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    } else {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Colegio', Icons.school_outlined, '/colegio'),
        _MenuItem('Avisos', Icons.campaign_outlined, '/circulares'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    }

    int selectedIndex = 0;

    for (int i = 0; i < tabs.length; i++) {
      if (widget.location.startsWith(tabs[i].route) &&
          tabs[i].route != '/more') {
        selectedIndex = i;
      }
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 72,
      backgroundColor: Colors.white,
      indicatorColor: primary.withOpacity(.12),
      onDestinationSelected: (value) {
        final route = tabs[value].route;

        if (route == '/more') {
          _scaffoldKey.currentState?.openDrawer();
        } else {
          context.go(route);
        }
      },
      destinations: tabs.map((e) {
        return NavigationDestination(
          icon: Icon(e.icon),
          label: e.label,
        );
      }).toList(),
    );
  }

  // ==========================================================
  // MENU POR ROL
  // ==========================================================
  List<_MenuItem> _menuItems(String role) {
    switch (role) {
      case 'super-admin':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Colegios', Icons.school_outlined, '/colegios'),
          _MenuItem(
              'Crear Colegio', Icons.add_business_outlined, '/colegios/create'),
        ];

      case 'profesor':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
        ];

      case 'estudiante':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
        ];

      case 'director':
      default:
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Materias', Icons.menu_book_outlined, '/materias'),
          _MenuItem('Profesores', Icons.person_outline, '/profesores'),
          _MenuItem('Estudiantes', Icons.school_outlined, '/estudiantes'),
          _MenuItem('Padres', Icons.family_restroom, '/padres'),
          _MenuItem('Cursos', Icons.class_outlined, '/cursos'),
          _MenuItem('Períodos', Icons.calendar_month_outlined, '/periodos'),
          _MenuItem('Colegio', Icons.school_outlined, '/colegio'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
        ];
    }
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================
  Future<void> _showLogoutDialog(BuildContext context) async {
    final auth = context.read<AuthViewModel>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas salir de la aplicación?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
>>>>>>> Stashed changes
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

<<<<<<< Updated upstream
    if (confirm == true && mounted) {
      auth.logout();
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
=======
    if (result == true) {
      await auth.logout();

      if (mounted) {
        context.go('/login');
      }
>>>>>>> Stashed changes
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  String _initials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }

    return '?';
  }
}

<<<<<<< Updated upstream
// ── Modelo de tab ─────────────────────────────────────────────────────────────
class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavTab(this.icon, this.activeIcon, this.label);
=======
// ==========================================================
// MODEL
// ==========================================================
class _MenuItem {
  final String label;
  final IconData icon;
  final String route;

  _MenuItem(this.label, this.icon, this.route);
>>>>>>> Stashed changes
}