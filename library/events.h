#ifndef EVENTS_H
#define EVENTS_H

const char* parseMSG(UINT msg);

BYTE getEventAsync(MSG *msg);

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);


#endif