import 'dart:html' as html;

class WebUtils {
  static String createBlobUrl(List<int> bytes) {
    final blob = html.Blob([bytes]);
    return html.Url.createObjectUrlFromBlob(blob);
  }
}
