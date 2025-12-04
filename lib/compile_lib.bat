gcc *.c -shared -lgdi32 -L ./lua_lib -I ./lua_lib/include -l lua54 -o ./../graphics.dll
pause