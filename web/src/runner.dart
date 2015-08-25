part of OSIRES;

class Runner {
    static final int UPDATE_RATE = 60;

    CanvasElement canvas;

    int _lt;
    int _now;
    double _delta;

    GameState state;

    Runner(this.canvas, GL.RenderingContext gl) {
        _lt = new DateTime.now().millisecondsSinceEpoch;
        _now = _lt;
        _delta = 0.0;

        Display.init(gl);
        Display.addShader("texture", TextureShader.withoutGL("""
            precision highp float;

            attribute vec3 a_pos;
            attribute vec2 a_coord;
            attribute vec3 a_color;

            varying vec2 v_coord;
            varying vec3 v_color;

            uniform mat4 u_objMat;
            uniform mat4 u_viewMat;
            uniform mat4 u_worldMat;

            void main() {
                v_coord = a_coord;
                v_color = a_color;
                gl_Position = u_viewMat * (u_worldMat * (u_objMat * vec4(a_pos, 1.0)));
            }
        """, """
            precision highp float;

            varying vec2 v_coord;
            varying vec3 v_color;

            uniform sampler2D u_tex;
            uniform mat3 u_textureMat;
            uniform vec4 u_color;

            void main() {
                vec4 col = vec4(v_color, 1.0) * u_color * texture2D(u_tex, (vec3(v_coord, 1.0) * u_textureMat).xy);
                if(col.a > 0.0) {
                    gl_FragColor = col;
                } else {
                    discard;
                }
            }
        """));
        Display.getShader("texture")..send(Display.gl, "u_viewMat", makeOrthographicMatrix(0, 854, 480, 0, 0.1, 100.0))
                                    ..send(Display.gl, "u_worldMat", new Matrix4.translationValues(0.0, 0.0, -1.0))
                                    ..send(Display.gl, "u_objMat", new Matrix4.identity().scale(16.0, 16.0, 1.0))
                                    ..send(Display.gl, "u_textureMat", new Matrix3.identity()..setEntry(0, 0, 1/16.0)..setEntry(1, 1, 1/16.0))
                                    ..send(Display.gl, "u_color", new Vector4(1.0, 1.0, 1.0, 1.0));
    }

    void setState(GameState gs) {
        gs.init(state);
        state = gs;
    }

    void start() {
        window.requestAnimationFrame(_loop);
    }

    void _loop(int time) {
        _now = new DateTime.now().millisecondsSinceEpoch;
        _delta += (_now - _lt) * UPDATE_RATE / 1000.0;
        _lt = _now;

        _delta = min(10.0, _delta);
        while(_delta >= 1) {
            update();
            _delta -= 1;
        }

        render();

        window.requestAnimationFrame(_loop);
    }

    void update() {
        if(state != null) state.update();
    }

    void render() {
        if(state != null) state.render(Display.gl);
    }
}