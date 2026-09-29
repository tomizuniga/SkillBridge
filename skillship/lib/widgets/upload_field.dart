import 'package:flutter/material.dart';

class UploadField extends StatelessWidget {
  final String label;
  final bool isUpload;

  const UploadField({super.key, required this.label, this.isUpload = false});

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
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3D7DC),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              if (isUpload) ...[
                const SizedBox(width: 12.0),
                const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black,
                  size: 28.0,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
