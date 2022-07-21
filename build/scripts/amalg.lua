#!/usr/bin/env lua
local C="amalg.lua"local u="amalg.cache"local e=tonumber(_VERSION:match("(%d+%.%d+)"))local s=e<5.4 and""or"\n\t"local function t(...)io.stderr:write("WARNING ",C,": ")local n=select('#',...)for e=1,n do
local t=tostring((select(e,...)))io.stderr:write(t,e==n and'\n'or'\t')end
end
local function q(...)local w,c,y,u,o,x,d,f,v,b,s,r,a,i=false,{},true,{},{},"preload",{}local n={}local function _(e)if e then
if r then
t("Resetting output file `"..r.."'! Using `"..e.."' now!")end
r=e
else
t("Missing argument for -o option!")end
end
local function h(e)if e then
if a then
t("Resetting cache file `"..a.."'! Using `"..e.."' now!")end
a=e
else
t("Missing argument for -C option!")end
end
local function p(e)if e then
if s then
t("Resetting main script `"..s.."'! Using `"..e.."' now!")end
s=e
else
t("Missing argument for -s option!")end
end
local function m(e)if e then
if i then
t("Resetting prefix file `"..i.."'! Using `"..e.."' now!")end
i=e
else
t("Missing argument for -p option!")end
end
local function g(e)if e then
if not pcall(string.match,"",e)then
t("Invalid Lua pattern: `"..e.."'")else
u[#u+1]=e
end
else
t("Missing argument for -i option!")end
end
local function k(e)if e then
local t="amalg."..e..".transform"require(t)if not n[e]then
o[#o+1]={t}n[e]=true
end
else
t("Missing argument for -t option!")end
end
local function M(e)if e then
local t="amalg."..e..".deflate"local l="amalg."..e..".inflate"require(t)require(l)if not n[e]then
o[#o+1]={t,l}n[e]=true
end
else
t("Missing argument for -z option!")end
end
local function C(e)if e then
d[#d+1]=e
else
t("Missing argument for -v option!")end
end
local e,l=1,select('#',...)while e<=l do
local n=select(e,...)if n=="--"then
for e=e+1,l do
c[select(e,...)]=true
end
break
elseif n=="-h"then
e=e+1
w=true
elseif n=="-o"then
e=e+1
_(e<=l and select(e,...))elseif n=="-p"then
e=e+1
m(e<=l and select(e,...))elseif n=="-s"then
e=e+1
p(e<=l and select(e,...))elseif n=="-i"then
e=e+1
g(e<=l and select(e,...))elseif n=="-t"then
e=e+1
k(e<=l and select(e,...))elseif n=="-z"then
e=e+1
M(e<=l and select(e,...))elseif n=="-v"then
e=e+1
C(e<=l and select(e,...))elseif n=="-f"then
x="postload"elseif n=="-c"then
f=true
elseif n=="-C"then
f=true
e=e+1
h(e<=l and select(e,...))elseif n=="-x"then
v=true
elseif n=="-d"then
b=true
elseif n=="-a"then
y=false
else
local e=n:sub(1,2)if e=="-o"then
_(n:sub(3))elseif e=="-p"then
m(n:sub(3))elseif e=="-s"then
p(n:sub(3))elseif e=="-i"then
g(n:sub(3))elseif e=="-t"then
k(n:sub(3))elseif e=="-z"then
M(n:sub(3))elseif e=="-v"then
C(n:sub(3))elseif e=="-C"then
h(n:sub(3))elseif n:sub(1,1)=="-"then
t("Unknown command line flag: "..n)else
c[n]=true
end
end
e=e+1
end
return w,r,s,b,y,f,x,u,o,v,c,a,i,d
end
local function a(e)local e,n=io.open(e,"rb"),false
if e then
n=e:read(1)=="\27"e:close()end
return n
end
local function p(e,n)local e=assert(io.open(e,n and"rb"or"r"))local n=assert(e:read("*a"))e:close()return n
end
local function k(t,o,l)local n,e
if l and t=="-"then
e=assert(io.read("*a"))n=e:sub(1,1)=="\27"t="<stdin>"else
n=a(t)e=p(t,n)end
local l
if not n then
e=e:gsub("^﻿","")l=e:match("^(#[^\n]*)")e=e:gsub("^#[^\n]*","")end
for o,l in ipairs(o)do
local l,t=require(l[1])(e,not n,t)e,n=l,(n or not t)end
return e,n,l
end
local function M(n,t)local e=p(n,true)for l,t in ipairs(t)do
if t[2]then
e=require(t[1])(e,false,n)end
end
return e
end
local function n(e)local e=("%q"):format(e)return(e:gsub("(%c)(%d?)",function(n,e)if n~="\n"then
return(e~=""and"\\%03d"or"\\%d"):format(n:byte())..e
end
end))end
local function y(e)local e=loadfile(e or u,"t",{})if e then
if setfenv then
setfenv(e,{})end
local e=e()if type(e)=="table"then
return e
end
end
end
local function x(t)local e=assert(io.open(u,"w"))e:write("return {\n")for l,t in pairs(t)do
if type(l)=="string"and type(t)=="string"then
e:write("  [ ",n(l)," ] = ",n(t),",\n")end
end
e:write("}\n")e:close()end
local i=package.searchpath
if not i then
local t=package.config:match("^(.-)\n"):gsub("%%","%%%%")function i(e,n)local t=e:gsub("%.",t):gsub("%%","%%%%")local e={}for n in n:gmatch("[^;]+")do
local n=n:gsub("%?",t)local t=io.open(n,"r")if t then
t:close()return n
end
e[#e+1]="\n\tno file '"..n.."'"end
return nil,table.concat(e)end
end
local function d(t)local e=""for l,t in ipairs(t)do
if t[2]then
e=e.." require( "..n(t[2]).." )("end
end
return e
end
local function f(n)local e=0
for t,n in ipairs(n)do
if n[2]then
e=e+1
end
end
return(" )"):rep(e)end
local function w(l,o,a,e,i,s,r)local t,c=k(a,e)if c or s then
l:write("package.",i,"[ ",n(o)," ] = assert( (loadstring or load)(",d(e)," ",n(t),f(e),", '@'..",n(a)," ) )\n\n")else
l:write("do\nlocal _ENV = _ENV\n","package.",i,"[ ",n(o)," ] = function( ... ) ",r and"local arg = _G.arg;\n"or"_ENV = _ENV;\n",t:gsub("%s*$",""),"\nend\nend\n\n")end
end
local function N(...)local v,r,a,_,x,e,h,l,t,m,o,q,b,g=q(...)local c={}if v then
print(([[%s <options> [--] <modules...>

  available options:
    -a: disable `arg` fix
    -c: take module names from `%s` cache file
    -C <file>: take module names from <file>
    -d: preserve file names and line numbers
    -f: use embedded modules as fallback only
    -h: print help/usage
    -i <pattern>: ignore matching modules from cache
      (can be specified multiple times)
    -o <file>: write output to <file>
    -p <file>: add the file contents as prefix (very early)
      in the amalgamation
    -s <file>: embed <file> as main script
    -t <plugin>: use transformation plugin
      (can be specified multiple times)
    -v <file>: store <file> in amalgamation
      (can be specified multiple times)
    -x: also embed C modules
    -z <plugin>: use (de-)compression plugin
      (can be specified multiple times)
]]):format(C,u))return
end
if e then
local e=y(q)for e,a in pairs(e or{})do
local n=true
for l,t in ipairs(l)do
if e:match(t)then
n=false
break
end
end
if n then
o[e]=a
end
end
end
local e=io.stdout
if r and r~="-"then
e=assert(io.open(r,"w"))end
local u,v,l
if a then
u,v,l=k(a,t,true)if l then
e:write(l,"\n\n")end
end
if b then
local n=p(b)e:write(n,"\n")end
if h=="postload"then
e:write([[
do
local assert = assert
local type = assert( type )
local searchers = package.searchers or package.loaders
local postload = {}
package.postload = postload
searchers[ #searchers+1 ] = function( mod )
  assert( type( mod ) == "string", "module name must be a string" )
  local loader = postload[ mod ]
  if loader == nil then
    return "\n\tno field package.postload['"..mod.."']"
  else
    return loader
  end
end
end

]])end
local l={}for t,n in ipairs(t)do
if n[2]then
local t,o=i(n[2],package.path)if not t then
error("module `"..n[2].."' not found:"..s..o)end
w(e,n[2],t,l,"preload")end
l[#l+1]=n
end
local l={}for e in pairs(o)do
l[#l+1]=e
end
table.sort(l)for l,n in ipairs(l)do
local a=o[n]if a~="C"then
local l,i=i(n,package.path)if not l and(a=="L"or not m)then
error("module `"..n.."' not found:"..s..i)elseif not l then
o[n],c[n]="C",s..i
else
w(e,n,l,t,h,_,x)end
end
end
if m then
local u={}local r=[[
do
local assert = assert
local os_remove = assert( os.remove )
local package_loadlib = assert( package.loadlib )
local dlls = {}
local function temporarydll( code )
  local tmpname = assert( os.tmpname() )
  if package.config:match( "^([^\n]+)" ) == "\\" then
    if not tmpname:match( "[\\/][^\\/]+[\\/]" ) then
      local tmpdir = assert( os.getenv( "TMP" ) or os.getenv( "TEMP" ),
                             "could not detect temp directory" )
      local first = tmpname:sub( 1, 1 )
      local hassep = first == "\\" or first == "/"
      tmpname = tmpdir..((hassep) and "" or "\\")..tmpname
    end
  end
  local f = assert( io.open( tmpname, "wb" ) )
  assert( f:write( code ) )
  f:close()
  local sentinel = newproxy and newproxy( true )
                            or setmetatable( {}, { __gc = true } )
  getmetatable( sentinel ).__gc = function() os_remove( tmpname ) end
  return { tmpname, sentinel }
end
]]for a,l in ipairs(l)do
local o=o[l]if o=="C"then
local o,a=i(l,package.cpath)if not o then
c[l]=(c[l]or"")..s..a
o,a=i(l:gsub("%..*$",""),package.cpath)if not o then
error("module `"..l.."' not found:"..c[l]..s..a)end
end
local s=n(o)local i=l:gsub("%.","_")local a,c=i:match("^([^%-]*)%-(.*)$")if not u[o]then
local l=M(o,t)u[o]=true
local n=n(l)e:write(r,"\ndlls[ ",s," ] = temporarydll(",d(t)," ",n,f(t)," )\n")r=""end
local t=n(l)e:write("\npackage.",h,"[ ",t," ] = function()\n","  local dll = dlls[ ",s," ][ 1 ]\n")if a then
e:write("  local loader = package_loadlib( dll, ",n("luaopen_"..a)," )\n","  if not loader then\n","    loader = assert( package_loadlib( dll, ",n("luaopen_"..c)," ) )\n  end\n")else
e:write("  local loader = assert( package_loadlib( dll, ",n("luaopen_"..i)," ) )\n")end
e:write("  return loader( ",t,", dll )\nend\n")end
end
if r==""then
e:write("end\n\n")end
end
if#g>0 then
e:write([[
do
local vfile = {}
local vfile_mt = { __index = vfile }
local assert = assert
local select = assert( select )
local setmetatable = assert( setmetatable )
local tonumber = assert( tonumber )
local type = assert( type )
local table_unpack = assert( unpack or table.unpack )
local io_open = assert( io.open )
local io_lines = assert( io.lines )
local _loadfile = assert( loadfile )
local _dofile = assert( dofile )
local virtual = {}
function io.open( path, mode )
  if (mode == "r" or mode == "rb") and virtual[ path ] then
    return setmetatable( { offset=0, data=virtual[ path ] }, vfile_mt )
  else
    return io_open( path, mode )
  end
end
function io.lines( path, ... )
  if virtual[ path ] then
    return setmetatable( { offset=0, data=virtual[ path ] }, vfile_mt ):lines( ... )
  else
    return io_lines( path, ... )
  end
end
function loadfile( path, ... )
  if virtual[ path ] then
    local s = virtual[ path ]:gsub( "^%s*#[^\n]*\n", "" )
    return (loadstring or load)( s, "@"..path, ... )
  else
    return _loadfile( path, ... )
  end
end
function dofile( path )
  if virtual[ path ] then
    local s = virtual[ path ]:gsub( "^%s*#[^\n]*\n", "" )
    return assert( (loadstring or load)( s, "@"..path ) )()
  else
    return _dofile( path )
  end
end
function vfile:close() return true end
vfile.flush = vfile.close
vfile.setvbuf = vfile.close
function vfile:write() return self end
local function lines_iterator( state )
  return state.file:read( table_unpack( state, 1, state.n ) )
end
function vfile:lines( ... )
  return lines_iterator, { file=self, n=select( '#', ... ), ... }
end
local function _read( self, n, fmt, ... )
  if n > 0 then
    local o = self.offset
    if o >= #self.data then return nil end
    if type( fmt ) == "number" then
      self.offset = o + fmt
      return self.data:sub( o+1, self.offset ), _read( self, n-1, ... )
    elseif fmt == "n" or fmt == "*n" then
      local p, e, x = self.data:match( "^%s*()%S+()", o+1 )
      if p then
        o = p - 1
        for i = p+1, e-1 do
          local newx = tonumber( self.data:sub( p, i ) )
          if newx then
            x, o = newx, i
          elseif i > o+3 then
            break
          end
        end
      else
        o = #self.data
      end
      self.offset = o
      return x, _read( self, n-1, ... )
    elseif fmt == "l" or fmt == "*l" then
      local s, p = self.data:match( "^([^\r\n]*)\r?\n?()", o+1 )
      self.offset = p-1
      return s, _read( self, n-1, ... )
    elseif fmt == "L" or fmt == "*L" then
      local s, p = self.data:match( "^([^\r\n]*\r?\n?)()", o+1 )
      self.offset = p-1
      return s, _read( self, n-1, ... )
    elseif fmt == "a" or fmt == "*a" then
      self.offset = #self.data
      return self.data:sub( o+1, self.offset )
    end
  end
end
function vfile:read( ... )
  local n = select( '#', ... )
  if n > 0 then
    return _read( self, n, ... )
  else
    return _read( self, 1, "l" )
  end
end
function vfile:seek( whence, offset )
  whence, offset = whence or "cur", offset or 0
  if whence == "set" then
    self.offset = offset
  elseif whence == "cur" then
    self.offset = self.offset + offset
  elseif whence == "end" then
    self.offset = #self.data + offset
  end
  return self.offset
end
]])for o,l in ipairs(g)do
local o=n(M(l,t))e:write("\nvirtual[ ",n(l)," ] =",d(t)," ",o,f(t),"\n")end
e:write("end\n\n")end
if a then
if v or _ then
if a=="-"then
a="<stdin>"end
e:write("assert( (loadstring or load)(",d(t)," ",n(u),f(t),", '@'..",n(a)," ) )( ... )\n\n")else
e:write(u)end
end
if r and r~="-"then
e:close()end
end
local function r()local n=package.searchers or package.loaders
local e=0
if package.loaded["luarocks.loader"]then
e=1
end
assert(#n==4+e,"package.searchers has been modified")local l=y()or{}local t=newproxy and newproxy(true)or setmetatable({},{__gc=true})getmetatable(t).__gc=function()x(l)end
local s=n[2+e]local i=n[3+e]local a=n[4+e]local function o(e,t,...)if type((...))=="function"then
l[t]=e
end
return...end
n[2+e]=function(...)local e=t
return o("L",...,s(...))end
n[3+e]=function(...)local e=t
return o("C",...,i(...))end
n[4+e]=function(...)local e=t
return o("C",...,a(...))end
if type(os)=="table"and type(os.exit)=="function"then
local e=os.exit
function os.exit(...)x(l)return e(...)end
end
end
local function t()local e=3
local n=debug.getinfo(e,"f")while n do
if n.func==require then
return false
end
e=e+1
n=debug.getinfo(e,"f")end
return true
end
if t()then
N(...)else
r()end