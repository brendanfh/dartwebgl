part of OSIRES;

class Texture {
    static Map<String, Texture> _textures = new Map<String, Texture>();
    GL.Texture tex;
    ImageElement img;
    bool loaded = false;

    static void load(GL.RenderingContext gl, String name, path) {
        var img = new ImageElement();
        img.onLoad.listen((Event e) {
            var tex = gl.createTexture();
            gl.bindTexture(GL.TEXTURE_2D, tex);
            gl.texImage2DImage(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img);
            gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
            gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
            gl.bindTexture(GL.TEXTURE_2D, null);
        });
        img.src = path;
    }

    static Texture getTexture(String name) {
        return _textures[name];
    }

    void bind(GL.RenderingContext gl) {
        gl.bindTexture(GL.TEXTURE_2D, tex);
    }
}