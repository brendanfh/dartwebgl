part of OSIRES;

class TestState extends GameState {
    Sprite testMesh;

    TestState() : super() {
    }

    void init([GameState parent]) {
        testMesh = new Sprite([
            0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
            1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
        ], [
            0, 1, 2, 0, 2, 3
        ]);
        testMesh.shader = Display.getShader("texture");
    }

    void update() {
    }

    void render(GL.RenderingContext gl) {
        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clear(GL.COLOR_BUFFER_BIT);

        testMesh.render(gl);
    }
}