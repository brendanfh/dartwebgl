part of OSIRES;

class Texture {
    static Map<String, Texture> _textures = new Map<String, Texture>();
    GL.Texture tex;
    ImageElement img;
    bool loaded = false;

    Texture(this.img, this.tex);

    static void load(GL.RenderingContext gl, String name, path) {
        Texture t;
        var img = new ImageElement();
        img.onLoad.listen((Event e) {
            var tex = gl.createTexture();
            gl.bindTexture(GL.TEXTURE_2D, tex);
            gl.texImage2DImage(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img);
            gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
            gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
            gl.bindTexture(GL.TEXTURE_2D, null);

            t.loaded = true;
            t.tex = tex;
        });
        img.src = path;
        t = new Texture(img, null);
        _textures[name] = t;
    }

    static bool hasTexture(String name) => _textures[name] != null;

    static Texture getTexture(String name) => _textures[name];

    void bind(GL.RenderingContext gl) {
        if(loaded) gl.bindTexture(GL.TEXTURE_2D, tex);
    }
}