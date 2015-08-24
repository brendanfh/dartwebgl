part of OSIRES;

class TestState extends GameState {
    Sprite testMesh;
    double t;

    TestState() : super() {
        t = 0.0;
    }

    void init([GameState parent]) {
        testMesh = new Sprite([
            0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0,
            1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0,
            1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0
        ], [
            0, 1, 2, 0, 2, 3
        ]);
        testMesh.shader = Display.getShader("texture");
    }

    void update() {
        t += 0.1;
    }

    void render(GL.RenderingContext gl) {
        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clear(GL.COLOR_BUFFER_BIT);

        Display.getShader("texture").send(Display.gl, "u_objMat", new Matrix4.translationValues(cos(t) * 200 + 100, sin(t) * 200 + 100, 0.0).scale(200.0, 200.0, 1.0));

        testMesh.render(gl);
    }
}