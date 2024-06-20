# Features

* Use chat colors in strings that rely on ansi truecolor codes.
* A spin function that hsv interpolates between two colors through a span of characters
* Ability to change the trigger characters
* Emulates the minecraft chat color codes along with full RGB support

![Screenshot of chat_color in console](https://raw.githubusercontent.com/ArcaneArts/chat_color/main/sc.png)

# Usage

```dart 
import 'package:chat_color/chat_color.dart';

void main() {
  // You can change the triggers (top level variables) to whatever you want. Must be a single character.
  print("&00&11&22&33&44&55&66&77&88&99&aa&bb&cc&dd&ee&ff".chatColor);
  print(
      "&kObfuscated&r &lBold&r &mStrikethrough&r &nUnderline&r &oItalic&r &rReset"
          .chatColor);
  print("You &lcan &mcombine &nthem &oalso...\n".chatColor);
  print("Hello &(255,0,0)RED (255,0,0)".chatColor);
  print("Hello &(#00ff00)GREEN #00ff0000".chatColor);
  print("Hello &(${0x0000ff})BLUE \${0x000000ff}\n".chatColor);

  print("@8Background Colors exist\n".chatColor);

  print("You can spin text!".spin(0xff0000, 0x00ff00).chatColor);

  print(
      "${"You can also spin text ".spin(0xff0000, 0x00ff00)}${"all the way chaining multiple spins ".spin(0x00ff00, 0x0000ff)}${"and go in any direction ".spin(0x0000ff, 0xff00ff)}${"you could want!".spin(0xff00ff, 0x00ffff)}"
          .chatColor);

  print("So yeah, thats cool"
      .spin(0x550000, 0x0000055, bg: true, unicorn: true)
      .chatColor);
}
```

You can define colors in multiple ways
```dart
"&(#RRGGBB)".chatColor // 6 digit hex
"&(R, G, B)".chatColor // 0-255 values
"&(${0xRRGGBB})".chatColor // or use Color.value in flutter
```

## Color Codes
| Code | Effect  | Code | Effect             |
|------|---------|------|--------------------|
| 0    | #000000 | k    | Strikethrough      |
| 1    | #0000AA | l    | Bold               |
| 2    | #00AA00 | m    | Strikethrough      |
| 3    | #00AAAA | n    | Underline          |
| 4    | #AA0000 | o    | Italic             |
| 5    | #AA00AA | r    | Reset Color/Format |
| 6    | #FFAA00 |      |                    |
| 7    | #AAAAAA |      |                    |
| 8    | #555555 |      |                    |
| 9    | #5555FF |      |                    |
| a    | #55FF55 |      |                    |
| b    | #55FFFF |      |                    |
| c    | #FF5555 |      |                    |
| d    | #FF55FF |      |                    |

# Limitations
Obviously this requires truecolor ansi support, which is not available on all terminals, however typically, logging is generally done in ides so this doesnt matter, as it works in IntelliJ and win/osx terminals. Actual logging frameworks should be able to switch using this on or off depending on the situation.