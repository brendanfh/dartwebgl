part of OSIRES;

/*
Expects Shaders to have:
Attribute: vec3 a_pos -- position

Uniform: mat4 u_objMat -- object transformation
Uniform: mat4 u_viewMat -- camera matrix
Uniform: mat4 u_worldMat -- world transformation
Uniform: vec4 u_color -- color vector
 */
class BaseShader extends Shader {
    int posLoc;

    static GLFunc<BaseShader> withoutGL(String vSource, fSource) {
        return (GL.RenderingContext gl) {
            return new BaseShader(gl, vSource, fSource);
        };
    }

    BaseShader(GL.RenderingContext gl, String vSource, String fSource) : super(gl, vSource, fSource);

    void initialize(GL.RenderingContext gl) {
        posLoc = gl.getAttribLocation(prog.prog, "a_pos");

        _addUniform(gl, "u_objMat", UniformType.M4);
        _addUniform(gl, "u_viewMat", UniformType.M4);
        _addUniform(gl, "u_worldMat", UniformType.M4);
        _addUniform(gl, "u_color", UniformType.V4);
    }
}

/*
Expects Shaders to have:
Attribute: vec3 a_pos -- position
Attribute: vec2 a_coord -- texture coord
Attribute: vec3 a_color -- color at a particular position

Uniform: mat4 u_objMat -- object transformation
Uniform: mat4 u_viewMat -- camera matrix
Uniform: mat4 u_worldMat -- world transformation
Uniform: mat3 u_textureMat -- texture matrix, used for setting w and h
Uniform: sampler2D u_tex -- the texture
Uniform: vec4 u_color -- color vector
 */
class TextureShader extends BaseShader {
    int coordLoc, colorLoc;

    static GLFunc<TextureShader> withoutGL(String vSource, fSource) {
        return (GL.RenderingContext gl) {
            return new TextureShader(gl, vSource, fSource);
        };
    }

    TextureShader(GL.RenderingContext gl, String vSource, String fSource) : super(gl, vSource, fSource);

    void initialize(GL.RenderingContext gl) {
        posLoc = gl.getAttribLocation(prog.prog, "a_pos");
        coordLoc = gl.getAttribLocation(prog.prog, "a_coord");
        colorLoc = gl.getAttribLocation(prog.prog, "a_color");

        _addUniform(gl, "u_objMat", UniformType.M4);
        _addUniform(gl, "u_viewMat", UniformType.M4);
        _addUniform(gl, "u_worldMat", UniformType.M4);
        _addUniform(gl, "u_textureMat", UniformType.M3);
        _addUniform(gl, "u_tex", UniformType.I);
        _addUniform(gl, "u_color", UniformType.V4);
    }
}