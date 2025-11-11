import 'package:flutter/material.dart';

class GroupActionButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onImport;
  final VoidCallback onExport;

  const GroupActionButtons({
    super.key,
    required this.onAdd,
    required this.onImport,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        // === NÚT THÊM ===
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'Thêm',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 6,
                shadowColor: Colors.green.withOpacity(0.4),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.green[700];
                  return null;
                }),
              ),
        ),

        // === NÚT IMPORT ===
        ElevatedButton.icon(
          onPressed: onImport,
          icon: const Icon(Icons.upload_rounded, size: 20),
          label: const Text(
            'Import',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 6,
                shadowColor: Colors.orange.withOpacity(0.4),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.orange[800];
                  return null;
                }),
              ),
        ),

        // === NÚT EXPORT ===
        ElevatedButton.icon(
          onPressed: onExport,
          icon: const Icon(Icons.download_rounded, size: 20),
          label: const Text(
            'Export',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 6,
                shadowColor: Colors.blue.withOpacity(0.4),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue[800];
                  return null;
                }),
              ),
        ),
      ],
    );
  }
}
