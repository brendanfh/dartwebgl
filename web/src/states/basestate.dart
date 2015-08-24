part of OSIRES;

abstract class GameState {
    GameState();
    void init([GameState parent]);
    void update();
    void render(GL.RenderingContext gl);
}