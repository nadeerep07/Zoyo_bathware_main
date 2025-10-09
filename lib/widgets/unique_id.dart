import 'dart:math';

String generateUniqueId() {
  final Random random = Random();
  int min = 10000000;
  int max = 99999999;
  return (min + random.nextInt(max - min)).toString();
}
