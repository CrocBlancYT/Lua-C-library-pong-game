#ifndef OBJECTS_H
#define OBJECTS_H

HWND newWindow(int width, int height, const char *name);
HDC newContext(HWND window);
HDC newBuffer(HDC context);
HBITMAP newDIB(HDC hdc, int width, int height, BYTE **pixels);

#endif