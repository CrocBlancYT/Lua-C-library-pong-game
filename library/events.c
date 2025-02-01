#include <windows.h>
#include "events.h"

const char* parseMSG(UINT msg) {
    switch (msg) {
        case WM_PAINT: return "WM_PAINT";

        case WM_KEYDOWN: return "WM_KEYDOWN";
        case WM_KEYUP: return "WM_KEYUP";
        case WM_SYSKEYUP: return "WM_SYSKEYUP";

        case WM_MOUSEMOVE: return "WM_MOUSEMOVE";

        case WM_CLOSE: return "WM_CLOSE";
        case WM_DESTROY: return "WM_DESTROY";

        case WM_TIMER: return "WM_TIMER";

        case WM_NCMOUSEMOVE: return "WM_NCMOUSEMOVE";
        case WM_SETCURSOR: return "WM_SETCURSOR";

        default: return "Unknown";
    }
}

BYTE getEventAsync(MSG *msg) {
    BYTE hasMessage = 0;
    
    if (PeekMessageA(msg, NULL, 0, 0, PM_REMOVE)) {
        hasMessage = 1;
        TranslateMessage(msg);
        DispatchMessage(msg);
    }

    return hasMessage;
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        /*
        case WM_PAINT:
            //clear screen
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            
            HBRUSH brush = CreateSolidBrush(RGB(0, 0, 0));
            FillRect(hdc, &ps.rcPaint, brush);

            DeleteObject(brush);
            EndPaint(hwnd, &ps);
            return 0;
        */

        /*
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
            */

        /*
        case WM_CLOSE:
            PostQuitMessage(0);
            return 0;
        */
    }

    return DefWindowProc(hwnd, uMsg, wParam, lParam); // default
}