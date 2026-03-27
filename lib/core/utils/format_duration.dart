import 'package:intl/intl.dart';

String formatDurationMinutes(int minutes) {
  return Intl.plural(minutes, one: '$minutes min', other: '$minutes mins');
}
