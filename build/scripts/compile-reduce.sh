cd ../../src || exit
cp ../build/scripts/amalg.lua ./         # copy bc amalg.lua and main.lua + dependencies must be in same dir for line 4

lua -lamalg main.lua                     # generate require map cache for amalg.lua
./amalg.lua -o merged.lua -s main.lua -c # merge all files into one
rm -rf amalg.cache
rm -rf amalg.lua                                                    # remove copy

../build/scripts/luasrcdiet.lua --maximum -o reduced.lua merged.lua # reduce file
rm -rf merged.lua                                                   # remove non-reduced file
mv reduced.lua ../build/yoshi-nes-ga.lua                            # move and rename
exit
