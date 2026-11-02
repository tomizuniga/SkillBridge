import 'package:flutter/material.dart';
import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/usuario.dart';
import 'package:skillship/Services/supabase_service.dart';
import 'package:skillship/screens/estudiante_detalle_trabajo_screen.dart';
import 'package:skillship/widgets/button.dart';
import 'gestionar_pasantia_estudiante.dart';

class EstudianteMainScreen extends StatefulWidget {
  final Usuario usuario;

  const EstudianteMainScreen({super.key, required this.usuario});

  @override
  State<EstudianteMainScreen> createState() => _EstudianteMainScreenState();
}

class _EstudianteMainScreenState extends State<EstudianteMainScreen> {
  // Índice para controlar qué pantalla se muestra (0: Buscar Trabajos, 1: Gestionar Pasantía)
  int _currentIndex = 0;

  // Cambia en cada pestaña para que las pantallas vuelvan a pedir datos frescos
  int _tick = 0;

  List<Widget> get _screens => [
        BuscarTrabajosScreenContent(
          key: ValueKey('buscar$_currentIndex$_tick'),
          usuario: widget.usuario,
        ),
        GestionarPasantiaScreen(
          key: ValueKey('gestionar$_currentIndex$_tick'),
          usuario: widget.usuario,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A101D),
      body: SafeArea(
        child: Row(
          children: [
            // ================= PANEL LATERAL (SIDEBAR FIJO) =================
            Container(
              width: 100,
              color: const Color(0xFF6A7389),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de Perfil
                  InkWell(
                    onTap: _abrirPerfil,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Botón Cerrar Sesión
                  InkWell(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cerrar Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Icon(Icons.logout, color: Colors.black, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTENIDO CAMBIANTE SEGÚN LA PESTAÑA =================
            Expanded(
              child: _screens[_currentIndex],
            ),
          ],
        ),
      ),
      // ================= BARRA DE NAVEGACIÓN INFERIOR =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tick++;
          });
        },
        backgroundColor: const Color(0xFF161F33),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar Trabajos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Gestionar Pasantía',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PERFIL: muestra los datos del estudiante y los documentos que subió,
  // tal como quedaron guardados en la base de datos.
  // ---------------------------------------------------------------------------
  void _abrirPerfil() {
    final servicio = SupabaseService.instance;
    final futuro = Future.wait<Object>([
      servicio.obtenerPerfilEstudiante(usuarioId: widget.usuario.id),
      servicio.obtenerDocumentos(usuarioId: widget.usuario.id),
    ]);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<List<Object>>(
              future: futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 160,
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF6A7389)),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perfil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        SupabaseService.mensajeError(snapshot.error!),
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      _botonCerrar(context),
                    ],
                  );
                }

                final datos = snapshot.data ?? const [];
                final perfil = datos.isNotEmpty
                    ? (datos[0] as Map<String, String>)
                    : <String, String>{};
                final documentos = datos.length > 1
                    ? (datos[1] as List<Map<String, String>>)
                    : <Map<String, String>>[];

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perfil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        perfil['nombre'] ?? widget.usuario.nombre ?? 'Estudiante',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.usuario.email,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      _dato('Institucion', perfil['institucion'] ?? '—'),
                      _dato('Carrera', perfil['carrera'] ?? '—'),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 8),
                      const Text(
                        'Documentos subidos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (documentos.isEmpty)
                        const Text(
                          'Todavía no se cargaron documentos.',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        )
                      else
                        ...documentos.map(
                          (d) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF6A7389),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    d['tipo'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(width: double.infinity, child: _botonCerrar(context)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: valor,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonCerrar(BuildContext contexto) {
    return Button(
      text: 'Cerrar',
      backgroundColor: const Color(0xFF2D2D2D),
      textColor: Colors.white,
      borderRadius: 8.0,
      onPressed: () => Navigator.pop(contexto),
    );
  }
}

// Versión adaptada de la vista de búsqueda de trabajos (sin Scaffold propio
// para evitar conflictos con la BottomNavigationBar).
class BuscarTrabajosScreenContent extends StatefulWidget {
  final Usuario usuario;

  const BuscarTrabajosScreenContent({super.key, required this.usuario});

  @override
  State<BuscarTrabajosScreenContent> createState() =>
      _BuscarTrabajosScreenContentState();
}

class _BuscarTrabajosScreenContentState
    extends State<BuscarTrabajosScreenContent> {
  final TextEditingController _buscadorController = TextEditingController();

  List<Pasantia> _todas = [];
  List<Pasantia> _visibles = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final datos = await SupabaseService.instance.obtenerPasantias(
        usuarioId: widget.usuario.id,
      );
      if (!mounted) return;
      setState(() {
        _todas = datos;
        _visibles = _aplicarFiltro();
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = SupabaseService.mensajeError(e);
        _cargando = false;
      });
    }
  }

  List<Pasantia> _aplicarFiltro() {
    final consulta = _buscadorController.text.trim().toLowerCase();
    if (consulta.isEmpty) return _todas;

    return _todas.where((p) {
      return p.titulo.toLowerCase().contains(consulta) ||
          p.empresa.toLowerCase().contains(consulta) ||
          p.ubicacion.toLowerCase().contains(consulta) ||
          p.modalidad.toLowerCase().contains(consulta) ||
          p.carreraRequerida.toLowerCase().contains(consulta) ||
          p.descripcion.toLowerCase().contains(consulta);
    }).toList();
  }

  void _buscar(String valor) {
    setState(() => _visibles = _aplicarFiltro());
  }

  Future<void> _abrirDetalle(Pasantia pasantia) async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EstudianteDetalleTrabajoScreen(
          pasantia: pasantia,
          usuario: widget.usuario,
        ),
      ),
    );

    // Si se envió una postulación, recargamos para marcar la tarjeta.
    if (actualizado == true) _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _buscadorController,
                    onChanged: _buscar,
                    decoration: const InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_cargando)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            )
          else if (_visibles.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No se encontraron pasantías',
                  style: TextStyle(color: Colors.white54, fontSize: 15),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _visibles.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final pasantia = _visibles[index];
                  return InkWell(
                    onTap: () => _abrirDetalle(pasantia),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAFA2A2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pasantia.titulo,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pasantia.empresa} · ${pasantia.ubicacion}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pasantia.descripcion,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          if (pasantia.yaPostulo) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Postulación: ${_etiquetaEstado(pasantia.estadoPostulacion)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  static String _etiquetaEstado(String? estado) {
    switch (estado) {
      case 'en_proceso':
        return 'En proceso';
      case 'pendiente':
        return 'Pendiente';
      case 'finalizada':
        return 'Finalizada';
      case 'rechazada':
        return 'Rechazada';
      default:
        return 'Enviada';
    }
  }
}
