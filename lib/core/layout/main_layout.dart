import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';

class MainLayout extends StatefulWidget {
  /// Pantalla activa inyectada por el ShellRoute de GoRouter.
  final Widget child;

  /// Ruta actual (state.matchedLocation desde el ShellRoute).
  final String location;

  const MainLayout({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const _purple     = Color(0xFF4F46E5);
  static const _purpleSoft = Color(0xFFF0EFFF);
  static const _gray400    = Color(0xFF9CA3AF);
  static const _bgPage     = Color(0xFFF5F7FB);

  // ── Tabs director ─────────────────────────────────────────────────────────
  static const _directorTabs = [
    _NavTab(Icons.home_outlined,           Icons.home,            'Inicio',     '/home'),
    _NavTab(Icons.menu_book_outlined,      Icons.menu_book,       'Materias',   '/materias'),
    _NavTab(Icons.person_outline,          Icons.person,          'Profesores', '/profesores'),
     _NavTab(Icons.school_outlined,         Icons.school,          'Estudiantes','/estudiantes'),
     _NavTab(Icons.family_restroom, Icons.family_restroom,      'Padres', '/padres'),
    _NavTab(Icons.class_outlined,          Icons.class_,          'Cursos',     '/cursos'),
    _NavTab(Icons.calendar_month_outlined, Icons.calendar_month,  'Períodos',   '/periodos'),
    _NavTab(Icons.school_outlined,         Icons.school,          'Colegio',    '/colegio'),
    _NavTab(Icons.campaign_outlined, Icons.campaign, 'Circulares', '/circulares'),
  ];
   static const _profesorTabs = [
    _NavTab(Icons.home_outlined,     Icons.home,     'Inicio',     '/home'),
    _NavTab(Icons.campaign_outlined, Icons.campaign, 'Circulares', '/circulares'),
  ];
  static const _estudianteTabs = [
  _NavTab(Icons.home_outlined, Icons.home, 'Inicio', '/home'),
  _NavTab(Icons.campaign_outlined, Icons.campaign, 'Circulares', '/circulares'),

];

  // ── Tabs super-admin ──────────────────────────────────────────────────────
  static const _adminTabs = [
    _NavTab(Icons.home_outlined,        Icons.home,         'Inicio',   '/home'),
    _NavTab(Icons.school_outlined,      Icons.school,       'Colegios', '/colegios'),
    _NavTab(Icons.add_business_outlined,Icons.add_business, 'Crear',    '/colegios/create'),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthViewModel>();
      if (auth.role == 'director') {
        final vm = context.read<TenantViewModel>();
        if (vm.currentTenant == null && !vm.loading) vm.loadMyTenant();
      }
    });
  }

  /// Devuelve el índice del tab activo según la ruta actual.
  int _selectedIndex(List<_NavTab> tabs) {
    // Iteramos en reversa para que rutas más largas tengan prioridad
    for (int i = tabs.length - 1; i >= 0; i--) {
      if (widget.location.startsWith(tabs[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final auth     = Provider.of<AuthViewModel>(context);
    final tenantVM = Provider.of<TenantViewModel>(context);
    final role     = auth.role;

    final tabs          = role == 'super-admin' ? _adminTabs : role == 'profesor' ?  _profesorTabs :role=='estudiante' ?_estudianteTabs : _directorTabs;
    final selectedIndex = _selectedIndex(tabs);

    return Scaffold(
      backgroundColor: _bgPage,

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
                  _buildLogo(role, tenantVM),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTitle(role, tenantVM)),
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context, auth),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(auth.user?.name ?? '?'),
                        style: const TextStyle(
                          color: _purple, fontSize: 12, fontWeight: FontWeight.w700,
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

      // ── Body: child del ShellRoute ──────────────────────────────────────
      body: widget.child,

      // ── Bottom nav ─────────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(tabs, selectedIndex),
    );
  }

  // ── Logo ─────────────────────────────────────────────────────────────────
  Widget _buildLogo(String? role, TenantViewModel tenantVM) {
    final logoUrl = role == 'director' ? tenantVM.currentTenant?.logoUrl : null;
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(logoUrl, width: 36, height: 36, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _logoFallback()),
      );
    }
    return _logoFallback();
  }

  Widget _logoFallback() => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: const Icon(Icons.school_outlined, color: Colors.white, size: 20),
  );

  // ── Título ────────────────────────────────────────────────────────────────
  Widget _buildTitle(String? role, TenantViewModel tenantVM) {
    final title    = role == 'director'
        ? (tenantVM.currentTenant?.name ?? 'Cargando...')
        : 'Admin Panel';
    final subtitle = role == 'director' ? 'Panel Director' : 'Super Administrador';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        Text(subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11)),
      ],
    );
  }

  // ── Bottom nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav(List<_NavTab> tabs, int selectedIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, -4))],
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
                  // go() para navegación de primer nivel (reemplaza la pila del shell)
                  onTap: () => context.go(tab.route),
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
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? _purple : _gray400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: active ? 4 : 0, height: active ? 4 : 0,
                          decoration: const BoxDecoration(color: _purple, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────
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
              backgroundColor: _purple, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await auth.logout();
      if (mounted) context.go('/login');
    }
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return p[0].isNotEmpty ? p[0][0].toUpperCase() : '?';
  }
}

// ── Modelo tab ────────────────────────────────────────────────────────────────
class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String   label;
  final String   route;  
  const _NavTab(this.icon, this.activeIcon, this.label, this.route);
}