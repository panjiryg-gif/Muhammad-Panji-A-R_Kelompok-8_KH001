import 'package:flutter/material.dart';
import 'config.dart';
import 'models/user.dart';
import 'models/admin.dart';
import 'services/api_service.dart';
import 'services/admin_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum CRUD User & Admin',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CRUD (N = ${AppConfig.n})'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.person), text: 'User'),
            Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
          ]),
        ),
        body: const TabBarView(children: [UserTab(), AdminTab()]),
      ),
    );
  }
}

Future<void> showResult(BuildContext context, String title, String msg) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(msg)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('OK'))
      ],
    ),
  );
}

// ======================= TAB USER =======================
class UserTab extends StatefulWidget {
  const UserTab({super.key});
  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  final _api = ApiService();
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getUsers();
  }

  void _reload() => setState(() => _future = _api.getUsers());

  Future<void> _run(String label, Future<String> Function() action) async {
    String msg;
    try {
      msg = await action();
    } catch (e) {
      msg = 'Error: $e';
    }
    if (!mounted) return;
    showResult(context, label, msg);
  }

  @override
  Widget build(BuildContext context) {
    final id = AppConfig.userId;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 6,
            children: [
              ActionChip(
                label: Text('GET ID $id'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => UserDetailPage(id: id))),
              ),
              ActionChip(
                label: const Text('POST'),
                onPressed: () => _run(
                    'POST User',
                    () => _api.createUser(User(
                        id: id,
                        name: 'Mahasiswa $id',
                        email: 'mhs$id@student.esaunggul.ac.id',
                        city: 'Jakarta'))),
              ),
              ActionChip(
                label: const Text('PUT'),
                onPressed: () => _run(
                    'PUT User',
                    () => _api.updateUser(id, 'Nama Baru $id',
                        'baru$id@student.esaunggul.ac.id', 'Jakarta')),
              ),
              ActionChip(
                label: const Text('PATCH'),
                onPressed: () =>
                    _run('PATCH User', () => _api.patchUserName(id, 'Mahasiswa $id')),
              ),
              ActionChip(
                label: const Text('DELETE'),
                onPressed: () => _run('DELETE User', () => _api.deleteUser(id)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<User>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snap.error}'),
                    TextButton(onPressed: _reload, child: const Text('Coba lagi'))
                  ],
                ));
              }
              final users = snap.data!;
              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, i) {
                    final u = users[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${u.id}')),
                      title: Text(u.name),
                      subtitle: Text('${u.email}\n${u.city}'),
                      isThreeLine: true,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UserDetailPage(id: u.id))),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final int id;
  const UserDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail User #$id')),
      body: FutureBuilder<User>(
        future: ApiService().getUser(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final u = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(leading: const Icon(Icons.tag), title: Text('${u.id}'), subtitle: const Text('ID')),
              ListTile(leading: const Icon(Icons.person), title: Text(u.name), subtitle: const Text('Nama')),
              ListTile(leading: const Icon(Icons.email), title: Text(u.email), subtitle: const Text('Email')),
              ListTile(leading: const Icon(Icons.location_city), title: Text(u.city), subtitle: const Text('Kota')),
            ],
          );
        },
      ),
    );
  }
}

// ======================= TAB ADMIN =======================
class AdminTab extends StatefulWidget {
  const AdminTab({super.key});
  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  final _service = AdminService();
  late Future<List<Admin>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getAdmins();
  }

  void _reload() => setState(() => _future = _service.getAdmins());

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Admin'),
        content: Text('Yakin hapus admin dengan ID $id?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;

    String msg;
    try {
      msg = await _service.deleteAdmin(id);
    } catch (e) {
      msg = 'Error: $e';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final id = AppConfig.adminId;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 6,
            children: [
              ActionChip(
                label: Text('GET ID $id'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminDetailPage(id: id))),
              ),
              ActionChip(
                label: Text('DELETE ID $id'),
                onPressed: () => _delete(id),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<Admin>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snap.error}'),
                    TextButton(onPressed: _reload, child: const Text('Coba lagi'))
                  ],
                ));
              }
              final admins = snap.data!;
              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.builder(
                  itemCount: admins.length,
                  itemBuilder: (_, i) {
                    final a = admins[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${a.id}')),
                      title: Text(a.name),
                      subtitle: Text('${a.email}\n${a.department}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(a.id),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AdminDetailPage(id: a.id))),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AdminDetailPage extends StatelessWidget {
  final int id;
  const AdminDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Admin #$id')),
      body: FutureBuilder<Admin>(
        future: AdminService().getAdmin(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final a = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(leading: const Icon(Icons.tag), title: Text('${a.id}'), subtitle: const Text('ID')),
              ListTile(leading: const Icon(Icons.person), title: Text(a.name), subtitle: const Text('Nama')),
              ListTile(leading: const Icon(Icons.email), title: Text(a.email), subtitle: const Text('Email')),
              ListTile(leading: const Icon(Icons.apartment), title: Text(a.department), subtitle: const Text('Department')),
            ],
          );
        },
      ),
    );
  }
}
