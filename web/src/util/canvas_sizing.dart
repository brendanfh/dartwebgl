part of OSIRES;

void sizeCanvas(CanvasElement canvas) {
    bool mobile = context.callMethod("isMobile");

    if(mobile) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        canvas.setAttribute("style", """
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;

            overflow: hidden;
        """);
    } else {
        canvas.width = 854;
        canvas.height = 480;
        canvas.setAttribute("style", """
            margin-top: 32px;
        """);
    }
}