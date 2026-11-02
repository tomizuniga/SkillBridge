import 'package:flutter/material.dart';

/// Campo de formulario con botón de carga de archivo.
///
/// Conserva el diseño original (caja gris + ícono de subida) y solo agrega
/// dos cosas funcionales: [onTap] para abrir el selector de archivos y
/// [fileName] para mostrar dentro de la caja qué archivo se eligió.
class UploadField extends StatelessWidget {
  final String label;
  final bool isUpload;

  /// Abre el selector de archivos al tocar la caja o el ícono.
  final VoidCallback? onTap;

  /// Nombre del archivo elegido. `null` = aún no se seleccionó nada.
  final String? fileName;

  const UploadField({
    super.key,
    required this.label,
    this.isUpload = false,
    this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D7DC),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      fileName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
              if (isUpload) ...[
                const SizedBox(width: 12.0),
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(4.0),
                  child: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.black,
                    size: 28.0,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
