#ifndef EVENTS_H
#define EVENTS_H

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void lua_event_default(const char* name, MSG msg, lua_State *L);
void lua_keyEvent(const char* name, MSG msg, lua_State *L);
void lua_mouseEvent(const char* name, MSG msg, lua_State *L);
void lua_process_event(MSG msg, lua_State *L);

BYTE getEventAsync(MSG *msg);

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);


#endif