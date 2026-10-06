import 'dart:io';

void configure(HttpClient client) {
  // ruleid: dart-accept-all-certificates
  client.badCertificateCallback = (cert, host, port) => true;

  // ruleid: dart-accept-all-certificates
  client.badCertificateCallback = (cert, host, port) {
    return true;
  };

  // ok: dart-accept-all-certificates
  client.badCertificateCallback = (cert, host, port) => false;

  // ok: dart-accept-all-certificates
  client.badCertificateCallback = null;
}