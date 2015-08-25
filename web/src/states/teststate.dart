part of OSIRES;

class TestState extends GameState {
    TexturedMesh testMesh;
    double t;

    TestState() : super() {
        t = 0.0;
    }

    void init([GameState parent]) {
        Texture.load(Display.gl, "test", "res/test.png");

        testMesh = new TexturedMesh(Texture.getTexture("test"), [
            0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
            1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0
        ], [
            0, 1, 2, 0, 2, 3
        ]);
        testMesh.shader = Display.getShader("texture");
    }

    void update() {
        t += 0.1;
    }

    void render(GL.RenderingContext gl) {
        gl.clearColor(1.0, 0.0, 0.0, 1.0);
        gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

        Display.getShader("texture").send(Display.gl, "u_worldMat", new Matrix4.translationValues(128.0, 128.0, -1.0));
        var shader = Display.getShader("texture");
        for(int y = 0; y < 16; y++) {
            for(int x = 0; x < 24; x++) {
                shader.send(Display.gl, "u_objMat", new Matrix4.translationValues(x * 16.0 + y * 16.0 * cos(t), y * 16.0 + x * 16.0 * sin(t), 0.0).scale(16.0, 16.0, 1.0));
                testMesh.render(gl);
            }
        }
    }
}