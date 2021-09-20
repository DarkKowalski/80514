#!/bin/bash -eu

CXX="g++"
CXX_FLAGS="-O3"

VERILATOR="verilator"
VERILATOR_FLAGS="-Wall"
VERILATOR_INCLUDE="-I/usr/share/verilator/include"
VERILATED="/usr/share/verilator/include/verilated.cpp"

MAKE="make -j"

if [[ -z $* ]]; then
    VERIFICATIONS="$(find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n')"
else
    VERIFICATIONS="$*"
fi

printf "[All Verifications]:\n"
for veri in $VERIFICATIONS; do
    printf "  %s\n" "$veri"
done

for veri in $VERIFICATIONS; do
     printf "[Verify Start]: %s\n" "$veri"
     cd "$veri"
     $VERILATOR $VERILATOR_FLAGS -cc "../../src/${veri}.v"
     cd "obj_dir/"
     $MAKE -f "V${veri}.mk"
     cd ..
     $CXX $CXX_FLAGS $VERILATOR_INCLUDE -Iobj_dir/ $VERILATED "${veri}.cpp" "obj_dir/V${veri}__ALL.a" -o "${veri}.out"
     "./${veri}.out"
    printf "[Verify Done]: %s\n" "$veri"
done
