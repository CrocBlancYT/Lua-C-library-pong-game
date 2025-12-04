#include <lua.h>
#include <lauxlib.h>

#include <stdio.h>

#include <windows.h>
#include <time.h>

#include "methods.h"
#include "objects.h"
#include "events.h"

HWND window = NULL;
HDC context = NULL;
HDC buffer = NULL;
HBITMAP bitmap = NULL;
BYTE *pixels = NULL;

int width = 0;
int height = 0;
const char *name = "";

BYTE init = 0;
int lua_initScreen(lua_State *L) {
    if (init) { return 0; }
    init = 1;

    name = lua_tostring(L, 1);
    width = lua_tointeger(L, 2);
    height = lua_tointeger(L, 3);

    window = newWindow(width, height, name);
    context = newContext(window);
    buffer = newBuffer(context);
    bitmap = newDIB(context, width, height, &pixels);

    return 0;
}

int lua_refreshScreen(lua_State *L) {
    bitmap_to_buffer(bitmap, buffer);
    buffer_to_context(buffer, context, width, height);
    return 0;
}

int lua_setPixel(lua_State *L) {
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);

    BYTE r = lua_tointeger(L, 3);
    BYTE g = lua_tointeger(L, 4);
    BYTE b = lua_tointeger(L, 5);

    setPixel(pixels, width, height, x, y, r, g, b);
    return 0;
}

int lua_getPixel(lua_State *L) {
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);

    color4 color = getPixel(pixels, width, height, x, y);

    BYTE r = color.r;
    BYTE g = color.g;
    BYTE b = color.b;

    lua_pushinteger(L, r);
    lua_pushinteger(L, g);
    lua_pushinteger(L, b);

    return 3;
}

int lua_drawLine(lua_State *L) {
    int x1 = lua_tointeger(L, 1);
    int y1 = lua_tointeger(L, 2);

    int x2 = lua_tointeger(L, 3);
    int y2 = lua_tointeger(L, 4);

    BYTE r = lua_tointeger(L, 5);
    BYTE g = lua_tointeger(L, 6);
    BYTE b = lua_tointeger(L, 7);

    drawLine(pixels, width, height, x1, y1, x2, y2, r, g, b);

    return 0;
}

int lua_clear(lua_State *L) {
    clear(pixels, width, height);
    return 0;
}

MSG msg = {0};
int lua_getEventAsync(lua_State *L) {
    BYTE hasMessage = getEventAsync(&msg);

    if (hasMessage) {
        lua_process_event(msg, L);
    } else {
        lua_pushnil(L);
    }

    return 1;
}

int lua_wait(lua_State *L) {
    double wantedTime = lua_tonumber(L, 1);

    double actualTime = wait(wantedTime);

    lua_pushnumber(L, actualTime);
    return 1;
}

int lua_precise_wait(lua_State *L) {
    double wantedTime = lua_tonumber(L, 1);

    double actualTime = precise_wait(wantedTime);

    lua_pushnumber(L, actualTime);
    return 1;
}

static const luaL_Reg module[] = {
    {"initScreen", lua_initScreen},
    {"refreshScreen", lua_refreshScreen},

    {"clearScreen", lua_clear},

    {"setPixel", lua_setPixel},
    {"getPixel", lua_getPixel},
    {"drawLine", lua_drawLine},

    {"wait", lua_wait},
    {"pWait", lua_precise_wait},

    {"getEventAsync", lua_getEventAsync},

    {NULL, NULL} // sentinel (end of array)
};

__declspec(dllexport) int luaopen_graphics(lua_State *L) {
    luaL_newlib(L, module);
    return 1;
}