#!/bin/bash

script="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

mkdir -p test
cd test

if [ -f /opt/intel/oneapi/setvars.sh ]; then
    . /opt/intel/oneapi/setvars.sh
fi

sed '0,/^__DATA__$/d' "$script" | while IFS=$'\n' read -r line; do
    IFS=' ' read -r name url <<<"$line"
    echo "$name"
    if [ -z "$name" ] || [ -z "$url" ]; then
        echo "Error occurred when testing $name $url" >&2
        continue
    fi

    git clone --depth 1 "$url" "$name"
    cd "$name"

    cp ../../SpMM_base.cc ./src/
    cp ../../SpMM_test.cc ./tests/
    cp ../../timer.hh ./utils/

    if [ "$name" = "baseline" ]; then
        cp src/SpMM_base.cc src/SpMM_opt.cc
        sed -i s/base/opt/ src/SpMM_opt.cc
    fi

    if [ "$name" = "lzr" ]; then
        bash build.sh
    else
        cmake -B build
    fi

    (cd build && make)

    for i in /tmp/dataset/*_3.bin; do
        echo "$i"
        ./build/tests/SpMM_test "$i"
    done | tee ../"$name".result

    cd ..
done

exit

__DATA__
baseline https://github.com/heptagonhust/recruitment-2023-spring
gc https://github.com/gongchen618/recruitment-2023-spring
lzr https://github.com/leedagee/recruitment-2023-spring
wyc https://github.com/Yucong-Wang/recruitment-2023-spring
ykl https://github.com/rarocat/recruitment-2023-spring
yyx https://github.com/tkob-vh/recruitment-2023-spring
