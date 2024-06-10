
// String formatDuration(int totalSeconds) {
//   final days = (totalSeconds ~/ 86400); // 86400 seconds in a day
//   final hours = ((totalSeconds % 86400) ~/ 3600).toString().padLeft(2, '0');
//   final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
//   final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  
//   if (days > 0) {
//     return '$days days $hours:$minutes:$seconds';
//   } else {
//     return '$hours:$minutes:$seconds';
//   }
// }

  String formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

