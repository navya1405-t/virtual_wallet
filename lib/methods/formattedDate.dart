// helper to format ISO / parseable date into "Oct 25, 2025"
String formatUploadedDate(String raw) {
  if (raw.isEmpty) return raw;
  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw; // fallback to original string
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final month = months[dt.month - 1];
  return '$month ${dt.day}, ${dt.year}';
}
