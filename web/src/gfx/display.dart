part of OSIRES;

typedef T GLFunc<T>(GL.RenderingContext gl);

class Display {
    static GL.RenderingContext gl;
    static Shader currentShader;
    static Map<String, Shader> _shaders;

    static void init(GL.RenderingContext _gl) {
        gl = _gl;
        gl.enable(GL.DEPTH_TEST);

        _shaders = new Map<String, Shader>();
    }

    static void addShader(String name, GLFunc<Shader> shader) {
        Shader s = shader(gl);
        if(currentShader == null) {
            s.use(gl);
        }
        _shaders[name] = s;
    }

    static Shader getShader(String name) => _shaders[name];
}