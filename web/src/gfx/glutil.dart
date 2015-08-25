part of OSIRES;

abstract class GShader {
    String source;
    GL.Shader shader;
    int mode;

    GShader(this.source, this.mode);

    void compile(GL.RenderingContext gl) {
        shader = gl.createShader(mode);
        gl.shaderSource(shader, source);
        gl.compileShader(shader);

        if(gl.getShaderParameter(shader, GL.COMPILE_STATUS) == null) {
            print(gl.getShaderInfoLog(shader));
        }
    }
}

class VertexShader extends GShader {
    VertexShader(String source) : super(source, GL.VERTEX_SHADER);
}

class FragmentShader extends GShader {
    FragmentShader(String source) : super(source, GL.FRAGMENT_SHADER);
}

class Program {
    VertexShader vs;
    FragmentShader fs;
    GL.Program prog;

    Program(this.vs, this.fs);

    void link(GL.RenderingContext gl) {
        vs.compile(gl);
        fs.compile(gl);

        prog = gl.createProgram();
        gl.attachShader(prog, vs.shader);
        gl.attachShader(prog, fs.shader);
        gl.linkProgram(prog);

        if(gl.getProgramParameter(prog, GL.LINK_STATUS) == null) {
            print(gl.getProgramInfoLog(prog));
        }
    }
}

enum UniformType {
    V2, V3, V4, M2, M3, M4, I, D
}

class _Uniform {
    UniformType type;
    GL.UniformLocation uniform;
    UFUNC passFunc;

    _Uniform(this.type, this.uniform) {
        passFunc = _uniformFunctions[type];
    }
}

typedef void UFUNC(GL.RenderingContext gl, GL.UniformLocation u, dynamic value);
final Map<UniformType, UFUNC> _uniformFunctions = {
    UniformType.V2 : (gl, u, v) {
       gl.uniform2fv(u, v.storage);
    },
    UniformType.V3 : (gl, u, v) {
        gl.uniform3fv(u, v.storage);
    },
    UniformType.V4 : (gl, u, v) {
        gl.uniform4fv(u, v.storage);
    },
    UniformType.M2 : (gl, u, v) {
        gl.uniformMatrix2fv(u, false, v.storage);
    },
    UniformType.M3 : (gl, u, v) {
        gl.uniformMatrix3fv(u, false, v.storage);
    },
    UniformType.M4 : (gl, u, v) {
        gl.uniformMatrix4fv(u, false, v.storage);
    },
    UniformType.I : (gl, u, v) {
        gl.uniform1i(u, v);
    },
    UniformType.D : (gl, u, v) {
        gl.uniform1f(u, v);
    }
};

abstract class Shader {
    Program prog;
    Map<String, _Uniform> uniforms;

    Shader(GL.RenderingContext gl, String vSource, String fSource) {
        uniforms = new Map<String, _Uniform>();

        prog = new Program(new VertexShader(vSource), new FragmentShader(fSource));
        prog.link(gl);
        initialize(gl);
    }

    void _addUniform(GL.RenderingContext gl, String name, UniformType type) {
        uniforms[name] = new _Uniform(type, gl.getUniformLocation(prog.prog, name));
    }

    void initialize(GL.RenderingContext gl) {}
    void use(GL.RenderingContext gl) {
        Display.currentShader = this;
        gl.useProgram(prog.prog);
    }

    bool send(GL.RenderingContext gl, String uniName, dynamic value) {
        var uniform = uniforms[uniName];
        if(uniform == null) return false;
        uniform.passFunc(gl, uniform.uniform, value);
        return true;
    }
}

class Mesh {
    // FORMAT
    // x y z
    GL.Buffer vertexBuffer;
    GL.Buffer indexBuffer;
    Float32List vertices;
    Int16List indices;

    BaseShader shader;

    Mesh(List<double> vList, List<int> iList) {
        var gl = Display.gl;
        vertexBuffer = gl.createBuffer();
        indexBuffer = gl.createBuffer();

        updateData(vList, iList);
    }

    void updateData(List<double> vList, List<int> iList, [int dataType = GL.STATIC_DRAW]) {
        var gl = Display.gl;

        vertices = new Float32List.fromList(vList);
        gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
        gl.bufferDataTyped(GL.ARRAY_BUFFER, vertices, dataType);

        indices = new Int16List.fromList(iList);
        gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferDataTyped(GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
    }

    void render(GL.RenderingContext gl) {
        shader.use(gl);

        gl.enableVertexAttribArray(shader.posLoc);
        gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
        gl.vertexAttribPointer(shader.posLoc, 3, GL.FLOAT, false, 0, 0);

        gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.drawElements(GL.TRIANGLES, indices.length, GL.UNSIGNED_SHORT, 0);
        gl.disableVertexAttribArray(shader.posLoc);
    }
}

class TexturedMesh extends Mesh {
    //FORMAT
    //x y z u v r g b
    TextureShader shader;
    Texture texture;

    TexturedMesh(this.texture, List<double> vList, List<int> iList) : super(vList, iList);

    void render(GL.RenderingContext gl) {
        shader.use(gl);
        texture.bind(gl);

        gl.enableVertexAttribArray(shader.posLoc);
        gl.enableVertexAttribArray(shader.coordLoc);
        gl.enableVertexAttribArray(shader.colorLoc);

        gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
        gl.vertexAttribPointer(shader.posLoc, 3, GL.FLOAT, false, 32, 0);
        gl.vertexAttribPointer(shader.coordLoc, 3, GL.FLOAT, false, 32, 12);
        gl.vertexAttribPointer(shader.colorLoc, 3, GL.FLOAT, false, 32, 20);

        gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.drawElements(GL.TRIANGLES, indices.length, GL.UNSIGNED_SHORT, 0);

        gl.disableVertexAttribArray(shader.posLoc);
        gl.disableVertexAttribArray(shader.coordLoc);
        gl.disableVertexAttribArray(shader.colorLoc);
    }
}
