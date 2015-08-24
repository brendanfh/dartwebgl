library OSIRES;

import "dart:html";
import "dart:js";
import "dart:web_gl" as GL;
import "dart:math";
import "dart:typed_data";
import "package:vector_math/vector_math.dart";

part "src/runner.dart";

part "src/gfx/glutil.dart";
part "src/gfx/shaders.dart";
part "src/gfx/display.dart";

part "src/states/basestate.dart";
part "src/states/teststate.dart";

part "src/sprite/sprite.dart";

part "src/util/canvas_sizing.dart";

void main() {
    CanvasElement canvas = querySelector("#game");
    sizeCanvas(canvas);
    GL.RenderingContext gl = canvas.getContext("webgl");
    if (gl == null) {
        noWebGL(canvas);
    } else {
        start(canvas, gl);
    }
}

void start(CanvasElement canvas, GL.RenderingContext gl) {
    new Runner(canvas, gl)..setState(new TestState())..start();
}

void noWebGL(CanvasElement canvas) {
    querySelector("#glerror").setAttribute("style", "display: block");
    canvas.setAttribute("style", "display: none");
}
