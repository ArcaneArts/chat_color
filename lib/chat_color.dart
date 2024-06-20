library chat_color;

import 'package:color/color.dart';

String trueColorTrigger = "&";
String trueColorBackgroundTrigger = "@";

String _bCodes = "0123456789abcdefklmnor";
List<Color> _bColors = [
  _toColor(0x000000), // 0
  _toColor(0x0000AA), // 1
  _toColor(0x00AA00), // 2
  _toColor(0x00AAAA), // 3
  _toColor(0xAA0000), // 4
  _toColor(0xAA00AA), // 5
  _toColor(0xFFAA00), // 6
  _toColor(0xAAAAAA), // 7
  _toColor(0x555555), // 8
  _toColor(0x5555FF), // 9
  _toColor(0x55FF55), // a
  _toColor(0x55FFFF), // b
  _toColor(0xFF5555), // c
  _toColor(0xFF55FF), // d
  _toColor(0xFFFF55), // e
  _toColor(0xFFFFFF), // f
];

List<String> _formatCodes = [
  "\x1B[9m", // obfuscated k (just using strikethrough)
  "\x1B[1m", // bold l
  "\x1B[9m", // strikethrough m
  "\x1B[4m", // underline n
  "\x1B[3m", // italic o
  "\x1B[0m", // reset r
];

String _clear = "\x1B[0m";

Color? _ofColor(String input) {
  if (input.contains(",")) {
    List<String> parts = input.split(",");
    if (parts.length == 3) {
      return Color.rgb(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    }
  } else if (input.startsWith("#")) {
    return _toColor(int.tryParse(input.substring(1), radix: 16) ?? 0xF00);
  } else {
    return _toColor(int.tryParse(input) ?? 0xF00);
  }

  return null;
}

extension XString on String {
  String _convert(String input, bool bg) {
    Color? c = _ofColor(input);
    return c != null ? _rgb(c, bg: bg) : "";
  }

  String spin(int a, int b, {bool unicorn = false, bool bg = false}) =>
      "${_spin(this, _toColor(a), _toColor(b), unicorn: unicorn, bg: bg)}$_clear";

  String _process(String k, bool bg) {
    String o = this;

    if (contains("$k(")) {
      StringBuffer buffer = StringBuffer();
      bool inColorCode = false;
      StringBuffer colorCode = StringBuffer();

      for (int i = 0; i < o.length; i++) {
        String char = o[i];

        if (!inColorCode && char == k && i + 1 < o.length && o[i + 1] == '(') {
          inColorCode = true;
          i++; // Skip the opening parenthesis
        } else if (inColorCode && char == ')') {
          buffer.write(_convert(colorCode.toString(), bg));
          colorCode.clear();
          inColorCode = false;
        } else if (inColorCode) {
          colorCode.write(char);
        } else {
          buffer.write(char);
        }
      }

      if (inColorCode) {
        buffer.write('$k(${colorCode.toString()}');
      }

      o = buffer.toString();
    }

    if (contains(k)) {
      StringBuffer buffer = StringBuffer();

      for (int i = 0; i < o.length; i++) {
        String char = o[i];

        if (char == k) {
          if (i + 1 >= o.length) {
            continue;
          }

          int index = _bCodes.indexOf(o[i + 1]);

          if (index == -1) {
            buffer.write(char);
            continue;
          }

          if (index >= 16 && bg) {
            continue;
          }

          buffer.write(index < 16
              ? _rgb(_bColors[index], bg: bg)
              : _formatCodes[index - 16]);
          i++;
        } else {
          buffer.write(char);
        }
      }

      o = buffer.toString();
    }

    return o;
  }

  String get chatColor {
    return "${_process(trueColorBackgroundTrigger, true)._process(trueColorTrigger, false)}$_clear";
  }
}

String chatColor(int color, {bool bg = false}) => _rgb(_toColor(color), bg: bg);

String _rgb(Color color, {bool bg = false}) {
  RgbColor c = color.toRgbColor();
  return "\x1B[${bg ? "4" : "3"}8;2;${c.r};${c.g};${c.b}m";
}

String _spin(String text, Color a, Color b,
    {bool unicorn = false, bool bg = false}) {
  int len = text.length;

  double d1len = 1 / len;
  StringBuffer buf = StringBuffer();
  HsvColor ha = a.toHsvColor();
  HsvColor hb = b.toHsvColor();

  for (int i = 0; i < len; i++) {
    double t = i * d1len;
    HexColor c = HsvColor(
      unicorn
          ? _lerp(ha.h.toDouble(), hb.h.toDouble(), t) % 360
          : _lerpHue(ha.h.toDouble(), hb.h.toDouble(), t),
      _lerp(ha.s.toDouble(), hb.s.toDouble(), t),
      _lerp(ha.v.toDouble(), hb.v.toDouble(), t),
    ).toHexColor();

    buf.write(
        "${bg ? trueColorBackgroundTrigger : trueColorTrigger}(${c.toCssString()})${text[i]}");
  }

  return buf.toString();
}

double _lerp(double a, double b, double f) => a + f * (b - a);

double _lerpHue(double a, double b, double f) {
  double d = b - a;
  if (d > 180) {
    b -= 360;
  } else if (d < -180) {
    b += 360;
  }
  return _lerp(a, b, f) % 360;
}

Color _toColor(int code, {int background = 0}) {
  int r, g, b;
  r = (code & 0x00FF0000) >> 16;
  g = (code & 0x0000FF00) >> 8;
  b = code & 0x000000FF;

  return Color.rgb(r, g, b);
}
