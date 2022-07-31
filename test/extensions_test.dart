import 'package:flutter_firebase_template/extensions/version_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test version_utils', () {
    // Normal version tests
    expect("1.0.0".hasHigherVersionThan("0.9.0"), true);
    expect("1.0.0".hasHigherVersionThan("0.0.9"), true);
    expect("1.0.0".hasHigherVersionThan("0.0.0"), true);
    expect("1.0.0".hasHigherVersionThan("1.0.1"), false);
    expect("1.0.0".hasHigherVersionThan("2.0.0"), false);
    expect("1.0.0".hasHigherVersionThan("2.0.2"), false);
    expect("1.0.1".hasHigherVersionThan("1.0.0"), true);
    expect("1.0.1".hasHigherVersionThan("2.0.0"), false);
    expect("1.0.1".hasHigherVersionThan("2.0.2"), false);
    expect("1.1.1".hasHigherVersionThan("1.1.0"), true);
    expect("1.1.1".hasHigherVersionThan("2.0.1"), false);
    expect("1.1.1".hasHigherVersionThan("2.0.2"), false);
    expect("0.9.0".hasHigherVersionThan("0.9.0"), false);
    expect("1.0.0".hasHigherVersionThan("1.0.0"), false);
    expect("1.0.1".hasHigherVersionThan("1.0.1"), false);
    expect("1.1.1".hasHigherVersionThan("1.1.1"), false);

    // Test version when there are digits missing (assume missing ones are 0)
    expect("1.1".hasHigherVersionThan("1.1.1"), false);
    expect("1.1.1".hasHigherVersionThan("1.1"), true);
    expect("1.0".hasHigherVersionThan("2.0.0"), false);
    expect("1.0.5".hasHigherVersionThan("2.0"), false);
    expect("2.0".hasHigherVersionThan("1.0.0"), true);
    expect("3".hasHigherVersionThan("2.10.4"), true);

    // Test version when there is a invalid string (always false)
    expect("ABC".hasHigherVersionThan("0.9.0"), false);
    expect("1.0.0".hasHigherVersionThan("ABC"), true);
    expect("ABC".hasHigherVersionThan("ABC"), false);
    expect("ABC".hasHigherVersionThan("PQR"), false);
    expect("1.ABC".hasHigherVersionThan("0.9.0"), true);
    expect("0.ABC".hasHigherVersionThan("1.9.0"), false);
    expect("1.1ABC".hasHigherVersionThan("1.1.1"), false);
    expect("1.1.1ABC".hasHigherVersionThan("1.1.1"), false);
    expect("1.0ABC".hasHigherVersionThan("2.0.0"), false);
  });
}
