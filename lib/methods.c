#include <windows.h>
#include "methods.h"

void setPixel(BYTE *pixels, int width, int height, int x, int y, BYTE r, BYTE g, BYTE b) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;

    int index = (x + y*width) * 4; //4 valeurs car: rouge, bleue, vert, alpha
    
    pixels[index + 0] = b;
    pixels[index + 1] = g;
    pixels[index + 2] = r;
    pixels[index + 3] = 255; //GDI ignore l'alpha
}

color4 getPixel(BYTE *pixels, int width, int height, int x, int y) {
    color4 pixel = {0, 0, 0, 0};

    if (x < 0 || x >= width || y < 0 || y >= height) return pixel;

    int index = (x + y*width) * 4;

    pixel.b = pixels[index + 0];
    pixel.g = pixels[index + 1];
    pixel.r = pixels[index + 2];
    pixel.a = pixels[index + 3];

    return pixel;
}

void drawLine(BYTE *pixels, int width, int height, int x1, int y1, int x2, int y2, BYTE r, BYTE g, BYTE b) {
    //algorithme de segment de Bresenham

    //differences
    int dx = x2-x1;
    int dy = y2-y1;

    //signes
    int sx = (dx > 0) ? 1 : -1;
    int sy = (dy > 0) ? 1 : -1;

    //valeurs absolue
    dx = (dx > 0) ? dx : -dx;
    dy = (dy > 0) ? dy : -dy;

    int err = dx - dy;

    while (1) {
        if ((x1 >= 0 && x1 < width) && (y1 >= 0 && y1 < height)) {
            int index = (y1 * width + x1) * 4;
            pixels[index + 0] = b;
            pixels[index + 1] = g;
            pixels[index + 2] = r;
            pixels[index + 3] = 255;
        }

        if (x1 == x2 && y1 == y2) break;

        //*2 mais plus rapide (operation de deplacement binaire)
        int e2 = err << 1;

        if (e2 > -dy) { err -= dy; x1 += sx; }
        if (e2 < dx) { err += dx; y1 += sy; }
    }
}

void drawEllipse() {}

void clear(BYTE *pixels, int width, int height) {
    int totalPixels = width * height;

    memset(pixels, 0, totalPixels * 4);

    for (int i = 0; i < totalPixels; i++) {
        pixels[(i<<2) + 3] = 255;
    }
}

double wait(double time) {
    LARGE_INTEGER frequency, start, end;

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&start);
    Sleep(time * 1000);
    QueryPerformanceCounter(&end);

    double elapsedTime = (double)(end.QuadPart - start.QuadPart) / frequency.QuadPart;
    return elapsedTime;
}

double precise_wait(double time) {
    LARGE_INTEGER frequency, start, current;

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&start);

    double target_ticks = time * (double)frequency.QuadPart;

    QueryPerformanceCounter(&current);
    while ((current.QuadPart - start.QuadPart) < target_ticks) {
        QueryPerformanceCounter(&current);
    }

    double elapsedTime = (double)(current.QuadPart - start.QuadPart) / frequency.QuadPart;
    return elapsedTime;
}

void bitmap_to_buffer(HBITMAP bitmap, HDC buffer) { SelectObject(buffer, bitmap); }

void buffer_to_context(HDC buffer, HDC context, int width, int height) { BitBlt(context, 0, 0, width, height, buffer, 0, 0, SRCCOPY); }
