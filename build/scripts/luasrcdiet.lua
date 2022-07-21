#!/usr/bin/env lua
do
local _ENV=_ENV
package.preload["luasrcdiet.equiv"]=function(...)local e=_G.arg;local c=string.byte
local p=string.dump
local m=loadstring or load
local b=string.sub
local s={}local a={TK_KEYWORD=true,TK_NAME=true,TK_NUMBER=true,TK_STRING=true,TK_LSTRING=true,TK_OP=true,TK_EOS=true,}local t,e,i
function s.init(o,n,l)t=o
e=n
i=l
end
local function o(n)local o,t=e.lex(n)local n,e={},{}for l=1,#o do
local o=o[l]if a[o]then
n[#n+1]=o
e[#e+1]=t[l]end
end
return n,e
end
function s.source(n,a)local function r(e)local e=m("return "..e,"z")if e then
return p(e)end
end
local function l(e)if t.DETAILS then print("SRCEQUIV: "..e)end
i.SRC_EQUIV=true
end
local e,c=o(n)local o,d=o(a)local n=n:match("^(#[^\r\n]*)")local a=a:match("^(#[^\r\n]*)")if n or a then
if not n or not a or n~=a then
l("shbang lines different")end
end
if#e~=#o then
l("count "..#e.." "..#o)return
end
for n=1,#e do
local e,i=e[n],o[n]local o,a=c[n],d[n]if e~=i then
l("type ["..n.."] "..e.." "..i)break
end
if e=="TK_KEYWORD"or e=="TK_NAME"or e=="TK_OP"then
if e=="TK_NAME"and t["opt-locals"]then
elseif o~=a then
l("seminfo ["..n.."] "..e.." "..o.." "..a)break
end
elseif e=="TK_EOS"then
else
local i,t=r(o),r(a)if not i or not t or i~=t then
l("seminfo ["..n.."] "..e.." "..o.." "..a)break
end
end
end
end
function s.binary(I,S)local e=0
local A=1
local x=3
local v=4
local g
local r
local f
local h
local s
local o
local u
local function e(e)if t.DETAILS then print("BINEQUIV: "..e)end
i.BIN_EQUIV=true
end
local function a(e,n)if e.i+n-1>e.len then return end
return true
end
local function _(n,e)if not e then e=1 end
n.i=n.i+e
end
local function t(n)local e=n.i
if e>n.len then return end
local l=b(n.dat,e,e)n.i=e+1
return c(l)end
local function K(l)local e,n=0,1
if not a(l,r)then return end
for o=1,r do
e=e+n*t(l)n=n*256
end
return e
end
local function L(n)local e=0
if not a(n,r)then return end
for l=1,r do
e=e*256+t(n)end
return e
end
local function k(l)local n,e=0,1
if not a(l,f)then return end
for o=1,f do
n=n+e*t(l)e=e*256
end
return n
end
local function N(n)local e=0
if not a(n,f)then return end
for l=1,f do
e=e*256+t(n)end
return e
end
local function c(e,o)local n=e.i
local l=n+o-1
if l>e.len then return end
local l=b(e.dat,n,l)e.i=n+o
return l
end
local function i(n)local e=u(n)if not e then return end
if e==0 then return""end
return c(n,e)end
local function O(n,e)local e,n=t(n),t(e)if not e or not n or e~=n then
return
end
return e
end
local function d(e,n)local e=O(e,n)if not e then return true end
end
local function T(e,n)local e,n=o(e),o(n)if not e or not n or e~=n then
return
end
return e
end
local function E(n,l)if not i(n)or not i(l)then
e("bad source name");return
end
if not o(n)or not o(l)then
e("bad linedefined");return
end
if not o(n)or not o(l)then
e("bad lastlinedefined");return
end
if not(a(n,4)and a(l,4))then
e("prototype header broken")end
if d(n,l)then
e("bad nups");return
end
if d(n,l)then
e("bad numparams");return
end
if d(n,l)then
e("bad is_vararg");return
end
if d(n,l)then
e("bad maxstacksize");return
end
local t=T(n,l)if not t then
e("bad ncode");return
end
local a=c(n,t*h)local t=c(l,t*h)if not a or not t or a~=t then
e("bad code block");return
end
local t=T(n,l)if not t then
e("bad nconst");return
end
for o=1,t do
local o=O(n,l)if not o then
e("bad const type");return
end
if o==A then
if d(n,l)then
e("bad boolean value");return
end
elseif o==x then
local o=c(n,s)local n=c(l,s)if not o or not n or o~=n then
e("bad number value");return
end
elseif o==v then
local n=i(n)local l=i(l)if not n or not l or n~=l then
e("bad string value");return
end
end
end
local t=T(n,l)if not t then
e("bad nproto");return
end
for o=1,t do
if not E(n,l)then
e("bad function prototype");return
end
end
local a=o(n)if not a then
e("bad sizelineinfo1");return
end
local t=o(l)if not t then
e("bad sizelineinfo2");return
end
if not c(n,a*r)then
e("bad lineinfo1");return
end
if not c(l,t*r)then
e("bad lineinfo2");return
end
local t=o(n)if not t then
e("bad sizelocvars1");return
end
local a=o(l)if not a then
e("bad sizelocvars2");return
end
for l=1,t do
if not i(n)or not o(n)or not o(n)then
e("bad locvars1");return
end
end
for n=1,a do
if not i(l)or not o(l)or not o(l)then
e("bad locvars2");return
end
end
local t=o(n)if not t then
e("bad sizeupvalues1");return
end
local o=o(l)if not o then
e("bad sizeupvalues2");return
end
for l=1,t do
if not i(n)then e("bad upvalues1");return end
end
for n=1,o do
if not i(l)then e("bad upvalues2");return end
end
return true
end
local function l(e)local n=e:match("^(#[^\r\n]*\r?\n?)")if n then
e=b(e,#n+1)end
return e
end
local n=m(l(I),"z")if not n then
e("failed to compile original sources for binary chunk comparison")return
end
local l=m(l(S),"z")if not l then
e("failed to compile compressed result for binary chunk comparison")end
local n={i=1,dat=p(n)}n.len=#n.dat
local l={i=1,dat=p(l)}l.len=#l.dat
if not(a(n,12)and a(l,12))then
e("header broken")end
_(n,6)g=t(n)r=t(n)f=t(n)h=t(n)s=t(n)_(n)_(l,12)if g==1 then
o=K
u=k
else
o=L
u=N
end
E(n,l)if n.i~=n.len+1 then
e("inconsistent binary chunk1");return
elseif l.i~=l.len+1 then
e("inconsistent binary chunk2");return
end
end
return s
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.fs"]=function(...)local e=_G.arg;local o=string.format
local r=io.open
local t='﻿'local function l(n,e)if e:sub(1,#n+2)==n..': 'then
e=e:sub(#n+3)end
return e
end
local i={}function i.read_file(n,e)local a,e=r(n,e or'r')if not a then
return nil,o('Could not open %s for reading: %s',n,l(n,e))end
local e,i=a:read('*a')if not e then
return nil,o('Could not read %s: %s',n,l(n,i))end
a:close()if e:sub(1,#t)==t then
e=e:sub(#t+1)end
return e
end
function i.write_file(e,t,n)local n,a=r(e,n or'w')if not n then
return nil,o('Could not open %s for writing: %s',e,l(e,a))end
local a,t=n:write(t)if t then
return nil,o('Could not write %s: %s',e,l(e,t))end
n:flush()n:close()return true
end
return i
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.init"]=function(...)local e=_G.arg;local c=require'luasrcdiet.equiv'local r=require'luasrcdiet.llex'local s=require'luasrcdiet.lparser'local t=require'luasrcdiet.optlex'local i=require'luasrcdiet.optparser'local e=require'luasrcdiet.utils'local u=table.concat
local o=e.merge
local h
local function d()return
end
local function a(n)local e={}for l,n in pairs(n)do
e['opt-'..l]=n
end
return e
end
local e={}e._NAME='luasrcdiet'e._VERSION='1.0.0'e._HOMEPAGE='https://github.com/jirutka/luasrcdiet'e.NONE_OPTS={binequiv=false,comments=false,emptylines=false,entropy=false,eols=false,experimental=false,locals=false,numbers=false,srcequiv=false,strings=false,whitespace=false,}e.BASIC_OPTS=o(e.NONE_OPTS,{comments=true,emptylines=true,srcequiv=true,whitespace=true,})e.DEFAULT_OPTS=o(e.BASIC_OPTS,{locals=true,numbers=true,})e.MAXIMUM_OPTS=o(e.DEFAULT_OPTS,{entropy=true,eols=true,strings=true,})function e.optimize(n,l)assert(l and type(l)=='string','bad argument #2: expected string, got a '..type(l))n=n and o(e.NONE_OPTS,n)or e.DEFAULT_OPTS
local a=a(n)local o,e,f=r.lex(l)local s=s.parse(o,e,f)i.print=d
i.optimize(a,o,e,s)local i=t.warn
t.print=d
h,e=t.optimize(a,o,e,f)local e=u(e)if n.srcequiv and not n.experimental then
c.init(a,r,i)c.source(l,e)if i.SRC_EQUIV then
error('Source equivalence test failed!')end
end
return e
end
return e
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.llex"]=function(...)local e=_G.arg;local t=string.find
local h=string.format
local r=string.match
local a=string.sub
local E=tonumber
local p={}local b={}for e in([[
and break do else elseif end false for function goto if in
local nil not or repeat return then true until while]]):gmatch("%S+")do
b[e]=true
end
local e,s,l,i,c,u,T,m
local function o(n,l)local e=#u+1
u[e]=n
T[e]=l
m[e]=c
end
local function f(n,i)local t=a(e,n,n)n=n+1
local e=a(e,n,n)if(e=="\n"or e=="\r")and(e~=t)then
n=n+1
t=t..e
end
if i then o("TK_EOL",t)end
c=c+1
l=n
return n
end
local function n()if s and r(s,"^[=@]")then
return a(s,2)end
return"[string]"end
local function d(e,l)local o=p.error or error
o(h("%s:%d: %s",n(),l or c,e))end
local function h(n)local t=a(e,n,n)n=n+1
local o=#r(e,"=*",n)n=n+o
l=n
return(a(e,n,n)==t)and o or(-o)-1
end
local function _(r,c)local n=l+1
local o=a(e,n,n)if o=="\r"or o=="\n"then
n=f(n)end
while true do
local o,s,t=t(e,"([\r\n%]])",n)if not o then
d(r and"unfinished long string"or"unfinished long comment")end
n=o
if t=="]"then
if h(n)==c then
i=a(e,i,l)l=l+1
return i
end
n=l
else
i=i.."\n"n=f(n)end
end
end
local function g(c)local n=l
while true do
local r,s,o=t(e,"([\n\r\\\"'])",n)if r then
if o=="\n"or o=="\r"then
d("unfinished string")end
n=r
if o=="\\"then
n=n+1
o=a(e,n,n)if o==""then break end
r=t("abfnrtv\n\r",o,1,true)if r then
if r>7 then
n=f(n)else
n=n+1
end
elseif t(o,"%D")then
n=n+1
else
local o,l,e=t(e,"^(%d%d?%d?)",n)n=l+1
if e+1>256 then
d("escape sequence too large")end
end
else
n=n+1
if o==c then
l=n
return a(e,i,n-1)end
end
else
break
end
end
d("unfinished string")end
local function O(n,a)e=n
s=a
l=1
c=1
u={}T={}m={}local t,a,e,n=t(e,"^(#[^\r\n]*)(\r?\n?)")if t then
l=l+#e
o("TK_COMMENT",e)if#n>0 then f(l,true)end
end
end
function p.lex(n,c)O(n,c)while true do
local n=l
while true do
local s,p,c=t(e,"^([_%a][_%w]*)",n)if s then
l=n+#c
if b[c]then
o("TK_KEYWORD",c)else
o("TK_NAME",c)end
break
end
local c,p,s=t(e,"^(%.?)%d",n)if c then
if s=="."then n=n+1 end
local s,f,i=t(e,"^%d*[%.%d]*([eE]?)",n)n=f+1
if#i==1 then
if r(e,"^[%+%-]",n)then
n=n+1
end
end
local t,n=t(e,"^[_%w]*",n)l=n+1
local e=a(e,c,n)if not E(e)then
d("malformed number")end
o("TK_NUMBER",e)break
end
local s,p,b,c=t(e,"^((%s)[ \t\v\f]*)",n)if s then
if c=="\n"or c=="\r"then
f(n,true)else
l=p+1
o("TK_SPACE",b)end
break
end
local f,c=t(e,"^::",n)if c then
l=c+1
o("TK_OP","::")break
end
local c=r(e,"^%p",n)if c then
i=n
local f=t("-[\"'.=<>~",c,1,true)if f then
if f<=2 then
if f==1 then
local c=r(e,"^%-%-(%[?)",n)if c then
n=n+2
local r=-1
if c=="["then
r=h(n)end
if r>=0 then
o("TK_LCOMMENT",_(false,r))else
l=t(e,"[\n\r]",n)or(#e+1)o("TK_COMMENT",a(e,i,l-1))end
break
end
else
local e=h(n)if e>=0 then
o("TK_LSTRING",_(true,e))elseif e==-1 then
o("TK_OP","[")else
d("invalid long string delimiter")end
break
end
elseif f<=5 then
if f<5 then
l=n+1
o("TK_STRING",g(c))break
end
c=r(e,"^%.%.?%.?",n)else
c=r(e,"^%p=?",n)end
end
l=n+#c
o("TK_OP",c)break
end
local e=a(e,n,n)if e~=""then
l=n+1
o("TK_OP",e)break
end
o("TK_EOS","")return u,T,m
end
end
end
return p
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.lparser"]=function(...)local e=_G.arg;local t=string.format
local n=string.gmatch
local O=pairs
local V={}local K,E,v,S,i,p,X,e,h,c,u,T,l,Q,k,P,f,m,x,N
local _,r,b,I,A,g
local M={}for e in n("else elseif end until <eof>","%S+")do
M[e]=true
end
local C={}local W={}for e,l,n in n([[
{+ 6 6}{- 6 6}{* 7 7}{/ 7 7}{% 7 7}
{^ 10 9}{.. 5 4}
{~= 3 3}{== 3 3}
{< 3 3}{<= 3 3}{> 3 3}{>= 3 3}
{and 2 2}{or 1 1}
]],"{(%S+)%s(%d+)%s(%d+)}")do
C[e]=l+0
W[e]=n+0
end
local j={["not"]=true,["-"]=true,["#"]=true,}local H=8
local function o(e,n)local l=V.error or error
l(t("(source):%d: %s",n or c,e))end
local function n()X=v[i]e,h,c,u=K[i],E[i],v[i],S[i]i=i+1
end
local function Y()return K[i]end
local function d(n)if e~="<number>"and e~="<string>"then
if e=="<name>"then e=h end
e="'"..e.."'"end
o(n.." near "..e)end
local function a(e)d("'"..e.."' expected")end
local function t(l)if e==l then n();return true end
end
local function G(n)if e~=n then a(n)end
end
local function o(e)G(e);n()end
local function B(n,e)if not n then d(e)end
end
local function s(e,l,n)if not t(e)then
if n==c then
a(e)else
d("'"..e.."' expected (to close '"..l.."' at line "..n..")")end
end
end
local function a()G("<name>")local e=h
T=u
n()return e
end
local function h(o,t)local e=l.bl
local n
if e then
n=e.locallist
else
n=l.locallist
end
local e=#f+1
f[e]={name=o,xref={T},decl=T,}if t or o=="_ENV"then
f[e].is_special=true
end
local l=#m+1
m[l]=e
x[l]=n
end
local function L(e)local n=#m
while e>0 do
e=e-1
local e=n-e
local l=m[e]local n=f[l]local t=n.name
n.act=u
m[e]=nil
local o=x[e]x[e]=nil
local e=o[t]if e then
n=f[e]n.rem=-l
end
o[t]=l
end
end
local function w()local n=l.bl
local e
if n then
e=n.locallist
else
e=l.locallist
end
for n,e in O(e)do
local e=f[e]e.rem=u
end
end
local function u(e,n)if e:sub(1,1)=="("then
return
end
h(e,n)end
local function R(o,l)local n=o.bl
local e
if n then
e=n.locallist
while e do
if e[l]then return e[l]end
n=n.prev
e=n and n.locallist
end
end
e=o.locallist
return e[l]or-1
end
local function O(n,l,e)if n==nil then
e.k="VGLOBAL"return"VGLOBAL"else
local o=R(n,l)if o>=0 then
e.k="VLOCAL"e.id=o
return"VLOCAL"else
if O(n.prev,l,e)=="VGLOBAL"then
return"VGLOBAL"end
e.k="VUPVAL"return"VUPVAL"end
end
end
local function F(o)local n=a()O(l,n,o)if o.k=="VGLOBAL"then
local e=P[n]if not e then
e=#k+1
k[e]={name=n,xref={T},}P[n]=e
else
local e=k[e].xref
e[#e+1]=T
end
else
local e=f[o.id].xref
e[#e+1]=T
end
end
local function T(n)local e={}e.isbreakable=n
e.prev=l.bl
e.locallist={}l.bl=e
end
local function O()local e=l.bl
w()l.bl=e.prev
end
local function q()local e
if not l then
e=Q
else
e={}end
e.prev=l
e.bl=nil
e.locallist={}l=e
end
local function z()w()l=l.prev
end
local function y(e)n()a()e.k="VINDEXED"end
local function U()n()r({})o("]")end
local function w()if e=="<name>"then
a()else
U()end
o("=")r({})end
local function R(e)r(e.v)end
local function D(l)local a=c
local n={v={k="VVOID"},}l.k="VRELOCABLE"o("{")repeat
if e=="}"then break end
local e=e
if e=="<name>"then
if Y()~="="then
R(n)else
w()end
elseif e=="["then
w()else
R(n)end
until not t(",")and not t(";")s("}","{",a)end
local function Y()local o=0
if e~=")"then
repeat
local e=e
if e=="<name>"then
h(a())o=o+1
elseif e=="..."then
n()l.is_vararg=true
else
d("<name> or '...' expected")end
until l.is_vararg or not t(",")end
L(o)end
local function R(t)local o=c
local l=e
if l=="("then
if o~=X then
d("ambiguous syntax (function call x new statement)")end
n()if e~=")"then
_()end
s(")","(",o)elseif l=="{"then
D({})elseif l=="<string>"then
n()else
d("function arguments expected")return
end
t.k="VCALL"end
local function X(l)local e=e
if e=="("then
local e=c
n()r(l)s(")","(",e)elseif e=="<name>"then
F(l)else
d("unexpected symbol")end
end
local function w(l)X(l)while true do
local e=e
if e=="."then
y(l)elseif e=="["then
U()elseif e==":"then
n()a()R(l)elseif e=="("or e=="<string>"or e=="{"then
R(l)else
return
end
end
end
local function U(o)local e=e
if e=="<number>"then
o.k="VKNUM"elseif e=="<string>"then
o.k="VK"elseif e=="nil"then
o.k="VNIL"elseif e=="true"then
o.k="VTRUE"elseif e=="false"then
o.k="VFALSE"elseif e=="..."then
B(l.is_vararg==true,"cannot use '...' outside a vararg function");o.k="VVARARG"elseif e=="{"then
D(o)return
elseif e=="function"then
n()A(false,c)return
else
w(o)return
end
n()end
local function R(o,t)local l=e
local a=j[l]if a then
n()R(o,H)else
U(o)end
l=e
local e=C[l]while e and e>t do
n()l=R({},W[l])e=C[l]end
return l
end
function r(e)R(e,0)end
local function R(e)local e=e.v.k
B(e=="VLOCAL"or e=="VUPVAL"or e=="VGLOBAL"or e=="VINDEXED","syntax error")if t(",")then
local e={}e.v={}w(e.v)R(e)else
o("=")_()return
end
end
local function C(e)o("do")T(false)L(e)b()O()end
local function U(e)u("(for index)")u("(for limit)")u("(for step)")h(e)o("=")I()o(",")I()if t(",")then
I()else
end
C(1)end
local function D(e)u("(for generator)")u("(for state)")u("(for control)")h(e)local e=1
while t(",")do
h(a())e=e+1
end
o("in")_()C(e)end
local function X(n)local l=false
F(n)while e=="."do
y(n)end
if e==":"then
l=true
y(n)end
return l
end
function I()r({})end
local function I()r({})end
local function y()n()I()o("then")b()end
local function B()h(a())L(1)A(false,c)end
local function C()local e=0
repeat
h(a())e=e+1
until not t(",")if t("=")then
_()else
end
L(e)end
function _()local e={}r(e)while t(",")do
r(e)end
end
function A(e,n)q()o("(")if e then
u("self",true)L(1)end
Y()o(")")g()s("end","function",n)z()end
function b()T(false)g()O()end
local function h()local l=p
T(true)n()local n=a()local e=e
if e=="="then
U(n)elseif e==","or e=="in"then
D(n)else
d("'=' or 'in' expected")end
s("end","for",l)O()end
local function L()local e=p
n()I()T(true)o("do")b()s("end","while",e)O()end
local function U()local e=p
T(true)T(false)n()g()s("until","repeat",e)I()O()O()end
local function I()local l=p
y()while e=="elseif"do
y()end
if e=="else"then
n()b()end
s("end","if",l)end
local function O()n()local e=e
if M[e]or e==";"then
else
_()end
end
local function T()local e=l.bl
n()while e and not e.isbreakable do
e=e.prev
end
if not e then
d("no loop to break")end
end
local function _()n()a()o("::")end
local function u()n()a()end
local function d()local n=i-1
local e={v={}}w(e.v)if e.v.k=="VCALL"then
N[n]="call"else
e.prev=nil
R(e)N[n]="assign"end
end
local function r()local e=p
n()local n=X({})A(n,e)end
local function a()local e=p
n()b()s("end","do",e)end
local function o()n()if t("function")then
B()else
C()end
end
local o={["if"]=I,["while"]=L,["do"]=a,["for"]=h,["repeat"]=U,["function"]=r,["local"]=o,["return"]=O,["break"]=T,["goto"]=u,["::"]=_,}local function a()p=c
local e=e
local n=o[e]if n then
N[i-1]=e
n()if e=="return"then return true end
else
d()end
return false
end
function g()local n=false
while not n and not M[e]do
n=a()t(";")end
end
local function a(e,t,a)i=1
Q={}local n=1
K,E,v,S={},{},{},{}for l=1,#e do
local e=e[l]local o=true
if e=="TK_KEYWORD"or e=="TK_OP"then
e=t[l]elseif e=="TK_NAME"then
e="<name>"E[n]=t[l]elseif e=="TK_NUMBER"then
e="<number>"E[n]=0
elseif e=="TK_STRING"or e=="TK_LSTRING"then
e="<string>"E[n]=""elseif e=="TK_EOS"then
e="<eof>"else
o=false
end
if o then
K[n]=e
v[n]=a[l]S[n]=l
n=n+1
end
end
k,P,f={},{},{}m,x={},{}N={}end
function V.parse(o,e,t)a(o,e,t)q()l.is_vararg=true
n()g()G("<eof>")z()return{globalinfo=k,localinfo=f,statinfo=N,toklist=K,seminfolist=E,toklnlist=v,xreflist=S,}end
return V
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.optlex"]=function(...)local e=_G.arg;local _=string.char
local d=string.find
local t=string.match
local u=string.rep
local e=string.sub
local f=tonumber
local c=tostring
local p
local h={}h.error=error
h.warn={}local a,o,s
local g={TK_KEYWORD=true,TK_NAME=true,TK_NUMBER=true,TK_STRING=true,TK_LSTRING=true,TK_OP=true,TK_EOS=true,}local k={TK_COMMENT=true,TK_LCOMMENT=true,TK_EOL=true,TK_SPACE=true,}local i
local function K(e)local n=a[e-1]if e<=1 or n=="TK_EOL"then
return true
elseif n==""then
return K(e-1)end
return false
end
local function L(n)local e=a[n+1]if n>=#a or e=="TK_EOL"or e=="TK_EOS"then
return true
elseif e==""then
return L(n+1)end
return false
end
local function R(l)local n=#t(l,"^%-%-%[=*%[")local l=e(l,n+1,-(n-1))local e,n=1,0
while true do
local l,a,t,o=d(l,"([\r\n])([\r\n]?)",e)if not l then break end
e=l+1
n=n+1
if#o>0 and t~=o then
e=e+1
end
end
return n
end
local function N(l,i)local n,e=a[l],a[i]if n=="TK_STRING"or n=="TK_LSTRING"or
e=="TK_STRING"or e=="TK_LSTRING"then
return""elseif n=="TK_OP"or e=="TK_OP"then
if(n=="TK_OP"and(e=="TK_KEYWORD"or e=="TK_NAME"))or(e=="TK_OP"and(n=="TK_KEYWORD"or n=="TK_NAME"))then
return""end
if n=="TK_OP"and e=="TK_OP"then
local n,e=o[l],o[i]if(t(n,"^%.%.?$")and t(e,"^%."))or(t(n,"^[~=<>]$")and e=="=")or(n=="["and(e=="["or e=="="))then
return" "end
return""end
local n=o[l]if e=="TK_OP"then n=o[i]end
if t(n,"^%.%.?%.?$")then
return" "end
return""else
return" "end
end
local function m()local r,i,t={},{},{}local e=1
for n=1,#a do
local l=a[n]if l~=""then
r[e],i[e],t[e]=l,o[n],s[n]e=e+1
end
end
a,o,s=r,i,t
end
local function y(r)local n=o[r]local l=n
local a
if t(l,"^0[xX]")then
local e=c(f(l))if#e<=#l then
l=e
else
return
end
end
if t(l,"^%d+$")then
if f(l)>0 then
a=t(l,"^0*([1-9]%d*)$")else
a="0"end
elseif not t(l,"[eE]")then
local l,n=t(l,"^(%d*)%.(%d*)$")if l==""then l=0 end
if n==""then n="0"end
if f(n)==0 and l==0 then
a=".0"else
local o=#t(n,"0*$")if o>0 then
n=e(n,1,#n-o)end
if f(l)>0 then
a=l.."."..n
else
a="."..n
local l=#t(n,"^0*")local l=#n-l
local o=c(#n)if l+2+#o<1+#n then
a=e(n,-l).."e-"..o
end
end
end
else
local n,l=t(l,"^([^eE]+)[eE]([%+%-]?%d+)$")l=f(l)local i,o=t(n,"^(%d*)%.(%d*)$")if i then
l=l-#o
n=i..o
end
if f(n)==0 then
a=".0"else
local o=#t(n,"^0*")n=e(n,o+1)o=#t(n,"0*$")if o>0 then
n=e(n,1,#n-o)l=l+o
end
local t=c(l)if l>=0 and(l<=1+#t)then
a=n..u("0",l).."."elseif l<0 and(l>=-#n)then
o=#n+l
a=e(n,1,o).."."..e(n,o+1)elseif l<0 and(#t>=-l-#n)then
o=-l-#n
a="."..u("0",o)..n
else
a=n.."e"..l
end
end
end
if a and a~=o[r]then
if i then
p("<number> (line "..s[r]..") "..o[r].." -> "..a)i=i+1
end
o[r]=a
end
end
local function w(h)local n=o[h]local r=e(n,1,1)local T=(r=="'")and'"'or"'"local n=e(n,2,-2)local l=1
local u,c=0,0
while l<=#n do
local h=e(n,l,l)if h=="\\"then
local o=l+1
local a=e(n,o,o)local i=d("abfnrtv\\\n\r\"'0123456789",a,1,true)if not i then
n=e(n,1,l-1)..e(n,o)l=l+1
elseif i<=8 then
l=l+2
elseif i<=10 then
local t=e(n,o,o+1)if t=="\r\n"or t=="\n\r"then
n=e(n,1,l).."\n"..e(n,o+2)elseif i==10 then
n=e(n,1,l).."\n"..e(n,o+1)end
l=l+2
elseif i<=12 then
if a==r then
u=u+1
l=l+2
else
c=c+1
n=e(n,1,l-1)..e(n,o)l=l+1
end
else
local a=t(n,"^(%d%d?%d?)",o)o=l+1+#a
local s=f(a)local f=_(s)i=d("\a\b\f\n\r\t\v",f,1,true)if i then
a="\\"..e("abfnrtv",i,i)elseif s<32 then
if t(e(n,o,o),"%d")then
a="\\"..a
else
a="\\"..s
end
elseif f==r then
a="\\"..f
u=u+1
elseif f=="\\"then
a="\\\\"else
a=f
if f==T then
c=c+1
end
end
n=e(n,1,l-1)..a..e(n,o)l=l+#a
end
else
l=l+1
if h==T then
c=c+1
end
end
end
if u>c then
l=1
while l<=#n do
local o,a,t=d(n,"(['\"])",l)if not o then break end
if t==r then
n=e(n,1,o-2)..e(n,o)l=o
else
n=e(n,1,o-1).."\\"..e(n,o)l=o+2
end
end
r=T
end
n=r..n..r
if n~=o[h]then
if i then
p("<string> (line "..s[h]..") "..o[h].." -> "..n)i=i+1
end
o[h]=n
end
end
local function x(r)local n=o[r]local c=t(n,"^%[=*%[")local l=#c
local f=e(n,-l,-1)local i=e(n,l+1,-(l+1))local a=""local n=1
while true do
local l,o,d,c=d(i,"([\r\n])([\r\n]?)",n)local o
if not l then
o=e(i,n)elseif l>=n then
o=e(i,n,l-1)end
if o~=""then
if t(o,"%s+$")then
h.warn.LSTRING="trailing whitespace in long string near line "..s[r]end
a=a..o
end
if not l then
break
end
n=l+1
if l then
if#c>0 and d~=c then
n=n+1
end
if not(n==1 and n==l)then
a=a.."\n"end
end
end
if l>=3 then
local e,n=l-1
while e>=2 do
local l="%]"..u("=",e-2).."%]"if not t(a.."]",l)then n=e end
e=e-1
end
if n then
l=u("=",n-2)c,f="["..l.."[","]"..l.."]"end
end
o[r]=c..a..f
end
local function _(f)local l=o[f]local r=t(l,"^%-%-%[=*%[")local n=#r
local c=e(l,-(n-2),-1)local i=e(l,n+1,-(n-1))local a=""local l=1
while true do
local o,n,c,r=d(i,"([\r\n])([\r\n]?)",l)local n
if not o then
n=e(i,l)elseif o>=l then
n=e(i,l,o-1)end
if n~=""then
local l=t(n,"%s*$")if#l>0 then n=e(n,1,-(l+1))end
a=a..n
end
if not o then
break
end
l=o+1
if o then
if#r>0 and c~=r then
l=l+1
end
a=a.."\n"end
end
n=n-2
if n>=3 then
local e,l=n-1
while e>=2 do
local n="%]"..u("=",e-2).."%]"if not t(a,n)then l=e end
e=e-1
end
if l then
n=u("=",l-2)r,c="--["..n.."[","]"..n.."]"end
end
o[f]=r..a..c
end
local function b(l)local n=o[l]local t=t(n,"%s*$")if#t>0 then
n=e(n,1,-(t+1))end
o[l]=n
end
local function S(l,n)if not l then return false end
local o=t(n,"^%-%-%[=*%[")local o=#o
local e=e(n,o+1,-(o-1))if d(e,l,1,true)then
return true
end
end
function h.optimize(n,l,r,t)local T=n["opt-comments"]local d=n["opt-whitespace"]local f=n["opt-emptylines"]local O=n["opt-eols"]local I=n["opt-strings"]local A=n["opt-numbers"]local E=n["opt-experimental"]local v=n.KEEP
i=n.DETAILS and 0
p=h.print or _G.print
if O then
T=true
d=true
f=true
elseif E then
d=true
end
a,o,s=l,r,t
local n=1
local l,c
local r
local function t(l,t,e)e=e or n
a[e]=l or""o[e]=t or""end
if E then
while true do
l,c=a[n],o[n]if l=="TK_EOS"then
break
elseif l=="TK_OP"and c==";"then
t("TK_SPACE"," ")end
n=n+1
end
m()end
n=1
while true do
l,c=a[n],o[n]local i=K(n)if i then r=nil end
if l=="TK_EOS"then
break
elseif l=="TK_KEYWORD"or
l=="TK_NAME"or
l=="TK_OP"then
r=n
elseif l=="TK_NUMBER"then
if A then
y(n)end
r=n
elseif l=="TK_STRING"or
l=="TK_LSTRING"then
if I then
if l=="TK_STRING"then
w(n)else
x(n)end
end
r=n
elseif l=="TK_COMMENT"then
if T then
if n==1 and e(c,1,1)=="#"then
b(n)else
t()end
elseif d then
b(n)end
elseif l=="TK_LCOMMENT"then
if S(v,c)then
if d then
_(n)end
r=n
elseif T then
local e=R(c)if k[a[n+1]]then
t()l=""else
t("TK_SPACE"," ")end
if not f and e>0 then
t("TK_EOL",u("\n",e))end
if d and l~=""then
n=n-1
end
else
if d then
_(n)end
r=n
end
elseif l=="TK_EOL"then
if i and f then
t()elseif c=="\r\n"or c=="\n\r"then
t("TK_EOL","\n")end
elseif l=="TK_SPACE"then
if d then
if i or L(n)then
t()else
local l=a[r]if l=="TK_LCOMMENT"then
t()else
local e=a[n+1]if k[e]then
if(e=="TK_COMMENT"or e=="TK_LCOMMENT")and
l=="TK_OP"and o[r]=="-"then
else
t()end
else
local e=N(r,n+1)if e==""then
t()else
t("TK_SPACE"," ")end
end
end
end
end
else
error("unidentified token encountered")end
n=n+1
end
m()if O then
n=1
if a[1]=="TK_COMMENT"then
n=3
end
while true do
l=a[n]if l=="TK_EOS"then
break
elseif l=="TK_EOL"then
local l,e=a[n-1],a[n+1]if g[l]and g[e]then
local n=N(n-1,n+1)if n==""or e=="TK_EOS"then
t()end
end
end
n=n+1
end
m()end
if i and i>0 then p()end
return a,o,s
end
return h
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.optparser"]=function(...)local e=_G.arg;local f=string.byte
local I=string.char
local p=table.concat
local n=string.format
local T=pairs
local L=string.rep
local K=table.sort
local d=string.sub
local g={}local t="etaoinshrdlucmfwypvbgkqjxz_ETAOINSHRDLUCMFWYPVBGKQJXZ"local c="etaoinshrdlucmfwypvbgkqjxz_0123456789ETAOINSHRDLUCMFWYPVBGKQJXZ"local N={}for e in([[
and break do else elseif end false for function if in
local nil not or repeat return then true until while
self _ENV]]):gmatch("%S+")do
N[e]=true
end
local i,s,a,m,h,E,l,u,b,k,_,r
local function O(e)local t={}for a=1,#e do
local e=e[a]local o=e.name
if not t[o]then
t[o]={decl=0,token=0,size=0,}end
local n=t[o]n.decl=n.decl+1
local t=e.xref
local l=#t
n.token=n.token+l
n.size=n.size+l*#o
if e.decl then
e.id=a
e.xcount=l
if l>1 then
e.first=t[2]e.last=t[l]end
else
n.id=a
end
end
return t
end
local function v(e)local o={TK_KEYWORD=true,TK_NAME=true,TK_NUMBER=true,TK_STRING=true,TK_LSTRING=true,}if not e["opt-comments"]then
o.TK_COMMENT=true
o.TK_LCOMMENT=true
end
local e={}for n=1,#i do
e[n]=s[n]end
for n=1,#l do
local n=l[n]local l=n.xref
for n=1,n.xcount do
local n=l[n]e[n]=""end
end
local n={}for e=0,255 do n[e]=0 end
for l=1,#i do
local l,e=i[l],e[l]if o[l]then
for l=1,#e do
local e=f(e,l)n[e]=n[e]+1
end
end
end
local function l(l)local e={}for o=1,#l do
local l=f(l,o)e[o]={c=l,freq=n[l],}end
K(e,function(n,e)return n.freq>e.freq
end)local n={}for l=1,#e do
n[l]=I(e[l].c)end
return p(n)end
t=l(t)c=l(c)end
local function w()local n
local a,i=#t,#c
local e=_
if e<a then
e=e+1
n=d(t,e,e)else
local o,l=a,1
repeat
e=e-o
o=o*i
l=l+1
until o>e
local o=e%a
e=(e-o)/a
o=o+1
n=d(t,o,o)while l>1 do
local o=e%i
e=(e-o)/i
o=o+1
n=n..d(c,o,o)l=l-1
end
end
_=_+1
return n,b[n]~=nil
end
local function x(O,b,E,o)local e=g.print or print
local x=o.DETAILS
if o.QUIET then return end
local s,h,m=0,0,0
local _,p,u=0,0,0
local a,f,c=0,0,0
local t,i,d=0,0,0
local function o(e,n)if e==0 then return 0 end
return n/e
end
for n,e in T(O)do
s=s+1
a=a+e.token
t=t+e.size
end
for n,e in T(b)do
h=h+1
p=p+e.decl
f=f+e.token
i=i+e.size
end
for n,e in T(E)do
m=m+1
u=u+e.decl
c=c+e.token
d=d+e.size
end
local S=s+h
local A=_+p
local k=a+f
local N=t+i
local v=s+m
local I=_+u
local b=a+c
local g=t+d
if x then
local s={}for n,e in T(O)do
e.name=n
s[#s+1]=e
end
K(s,function(e,n)return e.size>n.size
end)do
local l,r="%8s%8s%10s  %s","%8d%8d%10.2f  %s"local i=L("-",44)e("*** global variable list (sorted by size) ***\n"..i)e(n(l,"Token","Input","Input","Global"))e(n(l,"Count","Bytes","Average","Name"))e(i)for l=1,#s do
local l=s[l]e(n(r,l.token,l.size,o(l.token,l.size),l.name))end
e(i)e(n(r,a,t,o(a,t),"TOTAL"))e(i.."\n")end
do
local t,h="%8s%8s%8s%10s%8s%10s  %s","%8d%8d%8d%10.2f%8d%10.2f  %s"local s=L("-",70)e("*** local variable list (sorted by allocation order) ***\n"..s)e(n(t,"Decl.","Token","Input","Input","Output","Output","Global"))e(n(t,"Count","Count","Bytes","Average","Bytes","Average","Name"))e(s)for t=1,#r do
local i=r[t]local t=E[i]local r,a=0,0
for n=1,#l do
local e=l[n]if e.name==i then
r=r+e.xcount
a=a+e.xcount*#e.oldname
end
end
e(n(h,t.decl,t.token,a,o(r,a),t.size,o(t.token,t.size),i))end
e(s)e(n(h,u,c,i,o(f,i),d,o(c,d),"TOTAL"))e(s.."\n")end
end
do
local T,r="%-16s%8s%8s%8s%8s%10s","%-16s%8d%8d%8d%8d%10.2f"local l=L("-",58)e("*** local variable optimization summary ***\n"..l)e(n(T,"Variable","Unique","Decl.","Token","Size","Average"))e(n(T,"Types","Names","Count","Count","Bytes","Bytes"))e(l)e(n(r,"Global",s,_,a,t,o(a,t)))e(l)e(n(r,"Local (in)",h,p,f,i,o(f,i)))e(n(r,"TOTAL (in)",S,A,k,N,o(k,N)))e(l)e(n(r,"Local (out)",m,u,c,d,o(c,d)))e(n(r,"TOTAL (out)",v,I,b,g,o(b,g)))e(l.."\n")end
end
local function f()local function o(e)local l=a[e+1]or""local n=a[e+2]or""local e=a[e+3]or""if l=="("and n=="<string>"and e==")"then
return true
end
end
local l={}local e=1
while e<=#a do
local n=u[e]if n=="call"and o(e)then
l[e+1]=true
l[e+3]=true
e=e+3
end
e=e+1
end
local t={}do
local e,n,o=1,1,#a
while n<=o do
if l[e]then
t[h[e]]=true
e=e+1
end
if e>n then
if e<=o then
a[n]=a[e]m[n]=m[e]h[n]=h[e]-(e-n)u[n]=u[e]else
a[n]=nil
m[n]=nil
h[n]=nil
u[n]=nil
end
end
e=e+1
n=n+1
end
end
do
local e,n,l=1,1,#i
while n<=l do
if t[e]then
e=e+1
end
if e>n then
if e<=l then
i[n]=i[e]s[n]=s[e]else
i[n]=nil
s[n]=nil
end
end
e=e+1
n=n+1
end
end
end
local function p(d)_=0
r={}b=O(E)k=O(l)if d["opt-entropy"]then
v(d)end
local e={}for n=1,#l do
e[n]=l[n]end
K(e,function(e,n)return e.xcount>n.xcount
end)local o,n,c={},1,{}for l=1,#e do
local e=e[l]if not e.is_special then
o[n]=e
n=n+1
else
c[#c+1]=e.name
end
end
e=o
local a=#e
while a>0 do
local i,o
repeat
i,o=w()until not N[i]r[#r+1]=i
local n=a
if o then
local t=E[b[i].id].xref
local i=#t
for o=1,a do
local o=e[o]local a,e=o.act,o.rem
while e<0 do
e=l[-e].rem
end
local l
for n=1,i do
local n=t[n]if n>=a and n<=e then l=true end
end
if l then
o.skip=true
n=n-1
end
end
end
while n>0 do
local o=1
while e[o].skip do
o=o+1
end
n=n-1
local t=e[o]o=o+1
t.newname=i
t.skip=true
t.done=true
local i,r=t.first,t.last
local c=t.xref
if i and n>0 then
local a=n
while a>0 do
while e[o].skip do
o=o+1
end
a=a-1
local e=e[o]o=o+1
local a,o=e.act,e.rem
while o<0 do
o=l[-o].rem
end
if not(r<a or i>o)then
if a>=t.act then
for l=1,t.xcount do
local l=c[l]if l>=a and l<=o then
n=n-1
e.skip=true
break
end
end
else
if e.last and e.last>=t.act then
n=n-1
e.skip=true
end
end
end
if n==0 then break end
end
end
end
local l,n={},1
for o=1,a do
local e=e[o]if not e.done then
e.skip=false
l[n]=e
n=n+1
end
end
e=l
a=#e
end
for e=1,#l do
local e=l[e]local n=e.xref
if e.newname then
for l=1,e.xcount do
local n=n[l]s[n]=e.newname
end
e.name,e.oldname=e.newname,e.name
else
e.oldname=e.name
end
end
for n,e in ipairs(c)do
r[#r+1]=e
end
local e=O(l)x(b,k,e,d)end
function g.optimize(n,o,t,e)i,s=o,t
a,m,h=e.toklist,e.seminfolist,e.xreflist
E,l,u=e.globalinfo,e.localinfo,e.statinfo
if n["opt-locals"]then
p(n)end
if n["opt-experimental"]then
f()end
end
return g
end
end
do
local _ENV=_ENV
package.preload["luasrcdiet.utils"]=function(...)local e=_G.arg;local n=ipairs
local l=pairs
local e={}function e.merge(...)local e={}for o,n in n{...}do
for l,n in l(n)do
e[l]=n
end
end
return e
end
return e
end
end
local E=require"luasrcdiet.equiv"local h=require"luasrcdiet.fs"local u=require"luasrcdiet.llex"local x=require"luasrcdiet.lparser"local e=require"luasrcdiet.init"local N=require"luasrcdiet.optlex"local I=require"luasrcdiet.optparser"local f=string.byte
local w=table.concat
local k=string.find
local r=string.format
local c=string.gmatch
local v=string.match
local l=print
local _=string.rep
local s=string.sub
local o
local n=v(_VERSION," (5%.[123])$")or"5.1"local T=n=="5.1"and not package.loaded.jit
local b=r([[
LuaSrcDiet: Puts your Lua 5.1+ source code on a diet
Version %s <%s>
]],e._VERSION,e._HOMEPAGE)local O=[[
usage: luasrcdiet [options] [filenames]

example:
  >luasrcdiet myscript.lua -o myscript_.lua

options:
  -v, --version       prints version information
  -h, --help          prints usage information
  -o <file>           specify file name to write output
  -s <suffix>         suffix for output files (default '_')
  --keep <msg>        keep block comment with <msg> inside
  --plugin <module>   run <module> in plugin/ directory
  -                   stop handling arguments

  (optimization levels)
  --none              all optimizations off (normalizes EOLs only)
  --basic             lexer-based optimizations only
  --maximum           maximize reduction of source

  (informational)
  --quiet             process files quietly
  --read-only         read file and print token stats only
  --dump-lexer        dump raw tokens from lexer to stdout
  --dump-parser       dump variable tracking tables from parser
  --details           extra info (strings, numbers, locals)

features (to disable, insert 'no' prefix like --noopt-comments):
%s
default settings:
%s]]local m=[[
--opt-comments,'remove comments and block comments'
--opt-whitespace,'remove whitespace excluding EOLs'
--opt-emptylines,'remove empty lines'
--opt-eols,'all above, plus remove unnecessary EOLs'
--opt-strings,'optimize strings and long strings'
--opt-numbers,'optimize numbers'
--opt-locals,'optimize local variable names'
--opt-entropy,'tries to reduce symbol entropy of locals'
--opt-srcequiv,'insist on source (lexer stream) equivalence'
--opt-binequiv,'insist on binary chunk equivalence (only for PUC Lua 5.1)'
--opt-experimental,'apply experimental optimizations'
]]local A=[[
  --opt-comments --opt-whitespace --opt-emptylines
  --opt-numbers --opt-locals
  --opt-srcequiv --noopt-binequiv
]]local C=[[
  --opt-comments --opt-whitespace --opt-emptylines
  --noopt-eols --noopt-strings --noopt-numbers
  --noopt-locals --noopt-entropy
  --opt-srcequiv --noopt-binequiv
]]local R=[[
  --opt-comments --opt-whitespace --opt-emptylines
  --opt-eols --opt-strings --opt-numbers
  --opt-locals --opt-entropy
  --opt-srcequiv
]]..(T and' --opt-binequiv'or' --noopt-binequiv')local G=[[
  --noopt-comments --noopt-whitespace --noopt-emptylines
  --noopt-eols --noopt-strings --noopt-numbers
  --noopt-locals --noopt-entropy
  --opt-srcequiv --noopt-binequiv
]]local i="_"local q="luasrcdiet.plugin."local function t(e)l("LuaSrcDiet (error): "..e);os.exit(1)end
local a=""do
local t=24
local n={}for l,o in c(m,"%s*([^,]+),'([^']+)'")do
local e="  "..l
e=e.._(" ",t-#e)..o.."\n"a=a..e
n[l]=true
n["--no"..s(l,3)]=true
end
m=n
end
O=r(O,a,A)local S=i
local e={}local a,i
local function p(n)for n in c(n,"(%-%-%S+)")do
if s(n,3,4)=="no"and
m["--"..s(n,5)]then
e[s(n,5)]=false
else
e[s(n,3)]=true
end
end
end
local c={"TK_KEYWORD","TK_NAME","TK_NUMBER","TK_STRING","TK_LSTRING","TK_OP","TK_EOS","TK_COMMENT","TK_LCOMMENT","TK_EOL","TK_SPACE",}local y=7
local P={["\n"]="LF",["\r"]="CR",["\n\r"]="LFCR",["\r\n"]="CRLF",}local function d(e)local e,n=h.read_file(e,"rb")if not e then t(n)end
return e
end
local function U(e,n)local e,n=h.write_file(e,n,"wb")if not e then t(n)end
end
local function L()a,i={},{}for e=1,#c do
local e=c[e]a[e],i[e]=0,0
end
end
local function K(e,n)a[e]=a[e]+1
i[e]=i[e]+#n
end
local function g()local function t(e,n)if e==0 then return 0 end
return n/e
end
local o={}local n,e=0,0
for l=1,y do
local l=c[l]n=n+a[l];e=e+i[l]end
a.TOTAL_TOK,i.TOTAL_TOK=n,e
o.TOTAL_TOK=t(n,e)n,e=0,0
for l=1,#c do
local l=c[l]n=n+a[l];e=e+i[l]o[l]=t(a[l],i[l])end
a.TOTAL_ALL,i.TOTAL_ALL=n,e
o.TOTAL_ALL=t(n,e)return o
end
local function y(e)local e=d(e)local e,o=u.lex(e)for n=1,#e do
local n,e=e[n],o[n]if n=="TK_OP"and f(e)<32 then
e="("..f(e)..")"elseif n=="TK_EOL"then
e=P[e]else
e="'"..e.."'"end
l(n.." "..e)end
end
local function V(e)local e=d(e)local o,n,e=u.lex(e)local e=x.parse(o,n,e)local t,n=e.globalinfo,e.localinfo
local o=_("-",72)l("*** Local/Global Variable Tracker Tables ***")l(o.."\n GLOBALS\n"..o)for e=1,#t do
local n=t[e]local e="("..e..") '"..n.name.."' -> "local n=n.xref
for o=1,#n do e=e..n[o].." "end
l(e)end
l(o.."\n LOCALS (decl=declared act=activated rem=removed)\n"..o)for e=1,#n do
local n=n[e]local e="("..e..") '"..n.name.."' decl:"..n.decl.." act:"..n.act.." rem:"..n.rem
if n.is_special then
e=e.." is_special"end
e=e.." -> "local n=n.xref
for o=1,#n do e=e..n[o].." "end
l(e)end
l(o.."\n")end
local function M(e)local n=d(e)local n,o=u.lex(n)l(b)l("Statistics for: "..e.."\n")L()for e=1,#n do
local n,e=n[e],o[e]K(n,e)end
local n=g()local function o(e)return a[e],i[e],n[e]end
local n,t="%-16s%8s%8s%10s","%-16s%8d%8d%10.2f"local e=_("-",42)l(r(n,"Lexical","Input","Input","Input"))l(r(n,"Elements","Count","Bytes","Average"))l(e)for n=1,#c do
local n=c[n]l(r(t,n,o(n)))if n=="TK_EOS"then l(e)end
end
l(e)l(r(t,"Total Elements",o("TOTAL_ALL")))l(e)l(r(t,"Total Tokens",o("TOTAL_TOK")))l(e.."\n")end
local function P(m,p)local function n(...)if e.QUIET then return end
_G.print(...)end
if o and o.init then
e.EXIT=false
o.init(e,m,p)if e.EXIT then return end
end
n(b)local s=d(m)if o and o.post_load then
s=o.post_load(s)or s
if e.EXIT then return end
end
local l,d,h=u.lex(s)if o and o.post_lex then
o.post_lex(l,d,h)if e.EXIT then return end
end
L()for e=1,#l do
local e,n=l[e],d[e]K(e,n)end
local b=g()local v,O=a,i
I.print=n
local f=x.parse(l,d,h)if o and o.post_parse then
o.post_parse(f.globalinfo,f.localinfo)if e.EXIT then return end
end
I.optimize(e,l,d,f)if o and o.post_optparse then
o.post_optparse()if e.EXIT then return end
end
local f=N.warn
N.print=n
l,d,h=N.optimize(e,l,d,h)if o and o.post_optlex then
o.post_optlex(l,d,h)if e.EXIT then return end
end
local o=w(d)if k(o,"\r\n",1,1)or
k(o,"\n\r",1,1)then
f.MIXEDEOL=true
end
E.init(e,u,f)E.source(s,o)if T then
E.binary(s,o)end
local u="before and after lexer streams are NOT equivalent!"local s="before and after binary chunks are NOT equivalent!"if f.SRC_EQUIV then
if e["opt-srcequiv"]then t(u)end
else
n("*** SRCEQUIV: token streams are sort of equivalent")if e["opt-locals"]then
n("(but no identifier comparisons since --opt-locals enabled)")end
n()end
if f.BIN_EQUIV then
if e["opt-binequiv"]then t(s)end
elseif T then
n("*** BINEQUIV: binary chunks are sort of equivalent")n()end
U(p,o)L()for e=1,#l do
local n,e=l[e],d[e]K(n,e)end
local l=g()n("Statistics for: "..m.." -> "..p.."\n")local function t(e)return v[e],O[e],b[e],a[e],i[e],l[e]end
local l,o="%-16s%8s%8s%10s%8s%8s%10s","%-16s%8d%8d%10.2f%8d%8d%10.2f"local e=_("-",68)n("*** lexer-based optimizations summary ***\n"..e)n(r(l,"Lexical","Input","Input","Input","Output","Output","Output"))n(r(l,"Elements","Count","Bytes","Average","Count","Bytes","Average"))n(e)for l=1,#c do
local l=c[l]n(r(o,l,t(l)))if l=="TK_EOS"then n(e)end
end
n(e)n(r(o,"Total Elements",t("TOTAL_ALL")))n(e)n(r(o,"Total Tokens",t("TOTAL_TOK")))n(e)if f.LSTRING then
n("* WARNING: "..f.LSTRING)elseif f.MIXEDEOL then
n("* WARNING: ".."output still contains some CRLF or LFCR line endings")elseif f.SRC_EQUIV then
n("* WARNING: "..u)elseif f.BIN_EQUIV then
n("* WARNING: "..s)end
n()end
local r={...}p(A)local function d(a)for n=1,#a do
local n=a[n]local o
local l,c=k(n,"%.[^%.%\\%/]*$")local i,r=n,""if l and l>1 then
i=s(n,1,l-1)r=s(n,l,c)end
o=i..S..r
if#a==1 and e.OUTPUT_FILE then
o=e.OUTPUT_FILE
end
if n==o then
t("output filename identical to input filename")end
if e.DUMP_LEXER then
y(n)elseif e.DUMP_PARSER then
V(n)elseif e.READ_ONLY then
M(n)else
P(n,o)end
end
end
local function c()local i={}local n,a=#r,1
if n==0 then
e.HELP=true
end
while a<=n do
local n,l=r[a],r[a+1]local r=v(n,"^%-%-?")if r=="-"then
if n=="-h"then
e.HELP=true;break
elseif n=="-v"then
e.VERSION=true;break
elseif n=="-s"then
if not l then t("-s option needs suffix specification")end
S=l
a=a+1
elseif n=="-o"then
if not l then t("-o option needs a file name")end
e.OUTPUT_FILE=l
a=a+1
elseif n=="-"then
break
else
t("unrecognized option "..n)end
elseif r=="--"then
if n=="--help"then
e.HELP=true;break
elseif n=="--version"then
e.VERSION=true;break
elseif n=="--keep"then
if not l then t("--keep option needs a string to match for")end
e.KEEP=l
a=a+1
elseif n=="--plugin"then
if not l then t("--plugin option needs a module name")end
if e.PLUGIN then t("only one plugin can be specified")end
e.PLUGIN=l
o=require(q..l)a=a+1
elseif n=="--quiet"then
e.QUIET=true
elseif n=="--read-only"then
e.READ_ONLY=true
elseif n=="--basic"then
p(C)elseif n=="--maximum"then
p(R)elseif n=="--none"then
p(G)elseif n=="--dump-lexer"then
e.DUMP_LEXER=true
elseif n=="--dump-parser"then
e.DUMP_PARSER=true
elseif n=="--details"then
e.DETAILS=true
elseif m[n]then
p(n)else
t("unrecognized option "..n)end
else
i[#i+1]=n
end
a=a+1
end
if e.HELP then
l(b..O);return true
elseif e.VERSION then
l(b);return true
end
if e["opt-binequiv"]and not T then
t("--opt-binequiv is available only for PUC Lua 5.1!")end
if#i>0 then
if#i>1 and e.OUTPUT_FILE then
t("with -o, only one source file can be specified")end
d(i)return true
else
t("nothing to do!")end
end
if not c()then
t("Please run with option -h or --help for usage information")end