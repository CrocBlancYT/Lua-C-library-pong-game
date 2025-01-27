#include <lua.h>
#include <lauxlib.h>

#include <stdio.h>
#include <stdbool.h> 

#include <windows.h>
#include <time.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_PAINT:
            //clear screen
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            
            HBRUSH brush = CreateSolidBrush(RGB(255, 255, 255));
            FillRect(hdc, &ps.rcPaint, brush);

            DeleteObject(brush);
            EndPaint(hwnd, &ps);
            return 0;

        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;

        /*case WM_CLOSE:
            PostQuitMessage(0);
            return 0;*/
    }

    return DefWindowProc(hwnd, uMsg, wParam, lParam); // default
}

const char* parseMSG(UINT msg) {
    switch (msg) {
        case WM_PAINT: return "WM_PAINT";
        case WM_KEYDOWN: return "WM_KEYDOWN";
        case WM_MOUSEMOVE: return "WM_MOUSEMOVE";
        case WM_CLOSE: return "WM_CLOSE";
        default: return "Unknown Message";
    }
}

int runEventAsync(lua_State *L) {
    MSG msg = {0};
    bool hasMessage = false;
    
    if (PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE)) {
        hasMessage = true;
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    if (hasMessage) {
        lua_newtable(L);

        lua_pushstring(L, "window_handle");
        lua_pushlightuserdata(L, msg.hwnd);
        lua_settable(L, -3);

        lua_pushstring(L, "msgClass");
        lua_pushstring(L, parseMSG(msg.message));
        lua_settable(L, -3);

        lua_pushstring(L, "msgId");
        lua_pushinteger(L, msg.message);
        lua_settable(L, -3);

        lua_pushstring(L, "param_1");
        lua_pushinteger(L, msg.wParam);
        lua_settable(L, -3);

        lua_pushstring(L, "param_2");
        lua_pushinteger(L, msg.lParam);
        lua_settable(L, -3);

        lua_pushstring(L, "ms_time");
        lua_pushinteger(L, msg.time);
        lua_settable(L, -3);

        lua_pushstring(L, "position");
        lua_newtable(L);
        lua_pushstring(L, "x");
        lua_pushinteger(L, msg.pt.x);
        lua_settable(L, -3);
        lua_pushstring(L, "y");
        lua_pushinteger(L, msg.pt.y);
        lua_settable(L, -3);
        lua_settable(L, -3);
    } else {
        lua_pushnil(L);
    }

    return 1;
}

int clearScreen(lua_State *L) {
    lua_getfield(L, 1, "_HWND"); 
    HWND window = * (HWND *)lua_touserdata(L, -1); 
    lua_pop(L, 1);
    
    //full clear
    InvalidateRect(window, NULL, TRUE); //invalidates the screen
    UpdateWindow(window); //pushes a repaint of the screen

    return 0;
}

//Window
int window_gc(lua_State *L) {
    HWND *window = (HWND *)lua_touserdata(L, 1);
    if (window && *window) {
        DestroyWindow(*window);
    }
    return 0;
}

void create_window_metatable(lua_State *L) {
    luaL_newmetatable(L, "WindowMetaTable");
    lua_pushcfunction(L, window_gc);
    lua_setfield(L, -2, "__gc");
    lua_pop(L, 1);
}

//Context
int context_gc(lua_State *L) {
    HDC *ctx = (HDC *)lua_touserdata(L, 1);
    HWND *window = (HWND *)lua_touserdata(L, lua_upvalueindex(1));
    if (ctx && *ctx && window && *window) {
        ReleaseDC(*window, *ctx);
    }
    return 0;
}

void create_context_metatable(lua_State *L, HWND hwnd) {
    luaL_newmetatable(L, "ContextMetaTable");

    lua_pushcfunction(L, context_gc);
    lua_setfield(L, -2, "__gc");
    
    lua_pushlightuserdata(L, hwnd);
    lua_setfield(L, -2, "_hwnd");

    lua_pop(L, 1);
}

int setPixel(lua_State *L) {
    lua_getfield(L, 1, "_HDC"); 
    HDC context = * (HDC *)lua_touserdata(L, -1); 
    lua_pop(L, 1);

    int x = lua_tointeger(L, 2);
    int y = lua_tointeger(L, 3);

    int r = lua_tointeger(L, 4);
    int g = lua_tointeger(L, 5);
    int b = lua_tointeger(L, 6);

    SetPixel(context, x, y, RGB(r, g, b));
    return 0;
}

int getPixel(lua_State *L) {
    lua_getfield(L, 1, "_HDC"); 
    HDC context = * (HDC *)lua_touserdata(L, -1); 
    lua_pop(L, 1);

    int x = lua_tointeger(L, 2);
    int y = lua_tointeger(L, 3);

    COLORREF color = GetPixel(context, x, y);

    BYTE red = GetRValue(color);
    BYTE green = GetGValue(color);
    BYTE blue = GetBValue(color);

    lua_pushinteger(L, red);
    lua_pushinteger(L, green);
    lua_pushinteger(L, blue);

    return 3;
}

int drawLine(lua_State *L) {
    lua_getfield(L, 1, "_HDC"); 
    HDC context = * (HDC *)lua_touserdata(L, -1); 
    lua_pop(L, 1);

    int x1 = lua_tointeger(L, 2);
    int y1 = lua_tointeger(L, 3);

    int x2 = lua_tointeger(L, 4);
    int y2 = lua_tointeger(L, 5);

    int r = lua_tointeger(L, 6);
    int g = lua_tointeger(L, 7);
    int b = lua_tointeger(L, 8);

    HPEN hPen = CreatePen(PS_SOLID, 2, RGB(r, g, b));
    HPEN h_oldPen = (HPEN)SelectObject(context, hPen); 

    MoveToEx(context, x1, y1, NULL);
    LineTo(context, x2, y2);

    SelectObject(context, h_oldPen);
    DeleteObject(hPen);

    return 0;
}

int new_window(lua_State *L) {
    const char *name = lua_tostring(L, 1);
    int Width = lua_tointeger(L, 2);
    int Height = lua_tointeger(L, 3);

    WNDCLASS example = {0};
    example.lpfnWndProc = WindowProc;
    example.hInstance = GetModuleHandle(NULL);
    example.lpszClassName = "my_Window_Class";

    RegisterClass(&example); //register it in

    HWND window_handle = CreateWindowEx(
        0,              //extended style

        "my_Window_Class",  //class name
        name, //window name

        WS_OVERLAPPEDWINDOW, //style
        CW_USEDEFAULT, CW_USEDEFAULT, //X, Y
        Width, Height, //Width, Height

        NULL, NULL,  //parent, menu
        example.hInstance, NULL //instance, parameter
    );

    ShowWindow(window_handle, SW_SHOW);

    HDC context = GetDC(window_handle);

    create_window_metatable(L);
    create_context_metatable(L, window_handle);

    lua_newtable(L);
    
    HWND *window = (HWND *)lua_newuserdata(L, sizeof(HWND));
    *window = window_handle;
    luaL_getmetatable(L, "WindowMetaTable");
    lua_setmetatable(L, -2);
    lua_setfield(L, -2, "_HWND");

    HDC *ctx = (HDC *)lua_newuserdata(L, sizeof(HDC));
    *ctx = context;
    luaL_getmetatable(L, "ContextMetaTable");
    lua_setmetatable(L, -2);
    lua_setfield(L, -2, "_HDC");

    return 1;
}

int wait(lua_State *L) {
    float time = lua_tonumber(L, 1);
    LARGE_INTEGER frequency, start, end;

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&start);
    Sleep(time * 1000);
    QueryPerformanceCounter(&end);

    double elapsedTime = (double)(end.QuadPart - start.QuadPart) / frequency.QuadPart;

    lua_pushnumber(L, elapsedTime);
    return 1;
}

static const luaL_Reg module[] = {
    {"setupWindow", new_window},
    {"drawLine", drawLine},

    {"setPixel", setPixel},
    {"getPixel", getPixel},
    
    {"runEventAsync", runEventAsync},
    {"clear", clearScreen},

    {"wait", wait},

    {NULL, NULL} // sentinel (end of array)
};

__declspec(dllexport) int luaopen_graphics(lua_State *L) {
    luaL_newlib(L, module);
    return 1;
}

/*
    lua_close
    lua_createtable
    lua_error
    lua_getfield
    lua_getglobal
    luaL_openlibs
    luaL_loadfile
    luaL_newstate
    luaL_dostring
    lua_pcall
    lua_pushstring
    lua_pushnumber
    lua_setglobal
    lua_tostring
    lua_tonumber
*/