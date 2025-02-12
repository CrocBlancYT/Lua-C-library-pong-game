#include <windows.h>
#include <windowsx.h>

#include "events.h"

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void lua_event_default(const char* name, MSG msg, lua_State *L) {
    lua_newtable(L);

    lua_pushstring(L, "name");
    lua_pushstring(L, name);
    lua_settable(L, -3);

    lua_pushstring(L, "ms_time");
    lua_pushinteger(L, msg.time);
    lua_settable(L, -3);

    lua_pushstring(L, "_eventId");
    lua_pushinteger(L, msg.message);
    lua_settable(L, -3);
}

void lua_keyEvent(const char* name, MSG msg, lua_State *L) {
    lua_event_default(name, msg, L);
    
    int keycode = (int) msg.wParam;
    lua_pushstring(L, "keycode");
    lua_pushinteger(L, keycode);
    lua_settable(L, -3);

    BYTE is_special = (msg.lParam & (1 << 24)) != 0;
    lua_pushstring(L, "is_special");
    lua_pushboolean(L, is_special);
    lua_settable(L, -3);

    BYTE isHeld = (msg.lParam & (1 << 30)) != 0; 
    lua_pushstring(L, "is_held");
    lua_pushboolean(L, isHeld);
    lua_settable(L, -3);
}

void lua_mouseEvent(const char* name, MSG msg, lua_State *L) {
    lua_event_default(name, msg, L);

    lua_pushstring(L, "x");
    lua_pushinteger(L, GET_X_LPARAM(msg.lParam));
    lua_settable(L, -3);

    lua_pushstring(L, "y");
    lua_pushinteger(L, GET_Y_LPARAM(msg.lParam));
    lua_settable(L, -3);

    if (name == "Mouse_Scroll") {
        lua_pushstring(L, "dx");
        lua_pushinteger(L, GET_WHEEL_DELTA_WPARAM(msg.wParam));
        lua_settable(L, -3);

        lua_pushstring(L, "dy");
        lua_pushinteger(L, GET_WHEEL_DELTA_WPARAM(msg.wParam));
        lua_settable(L, -3);
    };
    
    if (name == "Mouse_X_Down") {
        lua_pushstring(L, "button");
        lua_pushinteger(L, HIWORD(msg.wParam));
        lua_settable(L, -3);
    };
}

void lua_process_event(MSG msg, lua_State *L) {
    switch (msg.message) {
        case WM_KEYDOWN: return lua_keyEvent("Key_Down", msg, L);
        case WM_KEYUP: return lua_keyEvent("Key_Up", msg, L);
        case WM_SYSKEYUP: return lua_keyEvent("Sys_Key_Up", msg, L);
        case WM_SYSKEYDOWN: return lua_keyEvent("Sys_Key_Down", msg, L);

        case WM_SIZE: return lua_mouseEvent("Screen_Resize", msg, L);
        case WM_MOVE: return lua_mouseEvent("Screen_Move", msg, L);

        case WM_XBUTTONUP: return lua_mouseEvent("Mouse_X_Up", msg, L);
        case WM_MBUTTONUP: return lua_mouseEvent("Mouse_3_Up", msg, L);
        case WM_RBUTTONUP: return lua_mouseEvent("Mouse_2_Up", msg, L);
        case WM_LBUTTONUP: return lua_mouseEvent("Mouse_1_Up", msg, L);
        
        case WM_XBUTTONDOWN: return lua_mouseEvent("Mouse_X_Down", msg, L);
        case WM_MBUTTONDOWN: return lua_mouseEvent("Mouse_3_Down", msg, L);
        case WM_RBUTTONDOWN: return lua_mouseEvent("Mouse_2_Down", msg, L);
        case WM_LBUTTONDOWN: return lua_mouseEvent("Mouse_1_Down", msg, L);

        case WM_MOUSEWHEEL: return lua_mouseEvent("Mouse_Scroll", msg, L);
        case WM_MOUSEMOVE: return lua_mouseEvent("Mouse_Move", msg, L);

        default: return lua_event_default("Unknown", msg, L);
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