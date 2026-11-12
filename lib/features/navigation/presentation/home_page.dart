import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/widgets/nautical_widgets.dart';
import 'package:devcoast_mobile/features/auth/presentation/entry_page.dart';
import 'package:devcoast_mobile/features/jobs/presentation/jobs_page.dart';
import 'package:devcoast_mobile/features/applications/presentation/applications_page.dart';
import 'package:devcoast_mobile/features/projects/presentation/projects_page.dart';
import 'package:devcoast_mobile/features/company/presentation/company_jobs_page.dart';
import 'package:devcoast_mobile/features/talents/presentation/talents_page.dart';
import 'package:devcoast_mobile/features/profile/presentation/profile_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;

  bool get isCompany => '${widget.user['tipo']}'.toLowerCase() == 'empresa';

  @override
  Widget build(BuildContext context) {
    final pages = isCompany
        ? <Widget>[
            const CompanyJobs(),
            const TalentsPage(),
            ProfilePage(user: widget.user),
          ]
        : <Widget>[
            const JobsPage(),
            const ApplicationsPage(),
            const ProjectsPage(),
            ProfilePage(user: widget.user),
          ];

    final destinations = isCompany
        ? const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'Ofertas',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'Talentos',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ]
        : const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'Empleos',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment),
              label: 'Solicitudes',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'Proyectos',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: const NauticalBrand(size: 20),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Api.signout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const EntryPage()),
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout_outlined, color: muted),
          ),
        ],
      ),
      body: SafeArea(top: false, child: IndexedStack(index: selected, children: pages)),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: selected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() => selected = i),
        destinations: destinations,
      ),
    );
  }
}
