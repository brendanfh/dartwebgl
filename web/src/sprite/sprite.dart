part of OSIRES;

class Sprite extends Mesh {
    TextureShader shader;

    Sprite(List<double> vList, List<int> iList) : super(vList, iList);

    void render(GL.RenderingContext gl) {
        shader.use(gl);

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