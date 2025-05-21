import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

// ==========================
// MODELO DE TICKET
// ==========================
class Ticket {
  final String id;
  final String title;
  final String status;

  Ticket({required this.id, required this.title, required this.status});
}

// ==========================
// LOGIN SCREEN
// ==========================
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  String _error = '';

  void _login() {
    String user = _userController.text.trim();
    String pass = _passController.text;

    if (user == 'admin' && pass == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TicketScreen()),
      );
    } else {
      setState(() {
        _error = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Ingresar'),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _error,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// TICKET SCREEN
// ==========================
class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String selectedStatus = 'Todos';
  String searchText = '';
  TextEditingController searchController = TextEditingController();

  List<Ticket> tickets = [
    Ticket(id: '1', title: 'Revisar login', status: 'Pendiente'),
    Ticket(id: '2', title: 'Actualizar diseño', status: 'En proceso'),
    Ticket(id: '3', title: 'Corregir errores', status: 'Resuelto'),
    Ticket(id: '4', title: 'Agregar validación', status: 'Pendiente'),
    Ticket(id: '5', title: 'Optimizar base de datos', status: 'En proceso'),
  ];

  List<String> estados = ['Todos', 'Pendiente', 'En proceso', 'Resuelto'];

  @override
  Widget build(BuildContext context) {
    // Aplica filtro por estado y por texto
    List<Ticket> filteredTickets = tickets.where((ticket) {
      final matchEstado =
          selectedStatus == 'Todos' || ticket.status == selectedStatus;
      final matchTexto =
          ticket.title.toLowerCase().contains(searchText.toLowerCase());
      return matchEstado && matchTexto;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrar Tickets por Estado'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Mostrar alerta de confirmación
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cerrar sesión'),
                  content: Text('¿Estás seguro que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ElevatedButton(
                      child: Text('Sí'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 🔍 Buscador de texto
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar por título',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // ⬇️ Dropdown de estado
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              items: estados.map((estado) {
                return DropdownMenuItem(
                  value: estado,
                  child: Text(estado),
                );
              }).toList(),
            ),
          ),

          // 📋 Lista de tickets
          Expanded(
            child: ListView.builder(
              itemCount: filteredTickets.length,
              itemBuilder: (context, index) {
                final ticket = filteredTickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(ticket.title),
                    subtitle: Text('Estado: ${ticket.status}'),
                    leading: Icon(Icons.assignment),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
