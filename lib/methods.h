#ifndef METHODS_H
#define METHODS_H

#include <windows.h>
typedef struct {
    BYTE b;
    BYTE g;
    BYTE r;
    BYTE a;
} color4;

void setPixel(BYTE *pixels, int width, int height, int x, int y, BYTE r, BYTE g, BYTE b);
color4 getPixel(BYTE *pixels, int width, int height, int x, int y);

void drawLine(BYTE *pixels, int width, int height, int x1, int y1, int x2, int y2, BYTE r, BYTE g, BYTE b);
void drawEllipse();

void clear(BYTE *pixels, int width, int height);

double wait(double time);
double precise_wait(double time);

void bitmap_to_buffer(HBITMAP bitmap, HDC buffer);
void buffer_to_context(HDC buffer, HDC context, int width, int height);

#endif