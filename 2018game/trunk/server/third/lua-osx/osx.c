#include <stdlib.h>
#include <assert.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int osx_getpid(lua_State* l)
{
    lua_pushinteger(l,getpid());
    return 1;
}

luaL_Reg osx_funs[] = {
    { "getpid", osx_getpid },
    { NULL, NULL }
};

int luaopen_osx(lua_State * L)
{
    luaL_checkversion(L);
    
    luaL_newlib(L, osx_funs);
    return 1;
}
