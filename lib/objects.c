#include <windows.h>

#include "objects.h"
#include "events.h"

HWND newWindow(int width, int height, const char *name) {
    //new class (template)
    WNDCLASS example = {0};
    example.lpfnWndProc = WindowProc;
    example.hInstance = GetModuleHandle(NULL);
    example.lpszClassName = "my_Window_Class";
    RegisterClass(&example);

    //new window handle
    HWND window_handle = CreateWindowEx(
        0,              //extended style

        "my_Window_Class",  //class name
        name, //window name

        WS_OVERLAPPEDWINDOW, //style
        CW_USEDEFAULT, CW_USEDEFAULT, //X, Y
        width, height, //Width, Height

        NULL, NULL,  //parent, menu
        example.hInstance, NULL //instance, parameter
    );

    ShowWindow(window_handle, SW_SHOW);

    return window_handle;
};

HDC newContext(HWND window) { return GetDC(window); };

HDC newBuffer(HDC context) { return CreateCompatibleDC(context); }

HBITMAP newDIB(HDC hdc, int width, int height, BYTE **pixels) {
    BITMAPINFO bmi = {0};
    
    bmi.bmiHeader .biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader .biWidth = width;
    bmi.bmiHeader .biHeight = -height;
    bmi.bmiHeader .biPlanes = 1;
    bmi.bmiHeader .biBitCount = 32; // 32-bit
    bmi.bmiHeader .biCompression = BI_RGB;

    return CreateDIBSection(hdc, &bmi, DIB_RGB_COLORS, (void **)pixels, NULL, 0);
}