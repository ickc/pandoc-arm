#!/usr/bin/env bash

set -e

version='0.1'

# helpers ##############################################################

print_double_line () {
    eval printf %.0s= '{1..'"${COLUMNS:-$(tput cols)}"\}
}

print_line () {
    eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}
}

# compile ##############################################################

print_double_line
echo 'update cabal...'
cabal update

print_line
__TMPDIR="$(mktemp -t pandoc-compile.XXXXXXXXXX)"
echo "Created temp dir at $__TMPDIR"

command time -v \
    cabal install \
        pandoc pandoc-citeproc -fembed_data_files --reinstall

# archive ##############################################################

for filename in pandoc pandoc-citeproc; do
    command time -v \
        xz -k -9ve --threads=0 -c "$(command -v $filename)" \
            > "$__TMPDIR/$filename.xz"
done

# upload ###############################################################

ver="$(pandoc --version | head -n1 | grep -Eo '[0-9.]+')"

{
printf '%.0s#' {1..72}; echo
lsb_release -a

printf '%.0s#' {1..72}; echo
ghc --version

printf '%.0s-' {1..72}; echo
cabal --version

printf '%.0s#' {1..72}; echo
pandoc --version

printf '%.0s-' {1..72}; echo
pandoc-citeproc --version

printf '%.0s#' {1..72}; echo
} 2> /dev/null | github-release \
    release -u ickc -r pandoc-arm -t "v$ver" -n "pandoc $ver" -d -

for filename in pandoc pandoc-citeproc; do
    github-release upload -u ickc -r pandoc-arm -t "v$ver" \
        -n "$filename.xz" -f "$__TMPDIR/$filename.xz" -l "$filename"
done
