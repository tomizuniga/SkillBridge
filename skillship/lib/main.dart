import 'package:flutter/material.dart';
import 'package:skillship/ui/screens/pagina_ingreso.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pzmrqtzxxuapuugknuoc.supabase.co',
    publishableKey: 'sb_publishable_Glf5ke8zooKpUK-nN4mfbg_K3bbX8fb',
  );
  //Esto es para que funcione la conexion con la base de datos
  //Dejar comentado para hacer pruebas de flujo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillShip',
      home: PantallaIngreso(),
    );
  }
}
