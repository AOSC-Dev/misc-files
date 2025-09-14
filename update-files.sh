#!/bin/bash

while IFS= read -r file; do
    [[ -z "$file" || "${file:0:1}" == "#" ]] && continue
    _arr=($file)
    dir=${_arr[0]}
    url=${_arr[1]}
    filename=${_arr[2]:-$(basename "$url")}
    echo "[+] Removing old file $dir/$(basename $filename) ..."
    rm -v $dir/$filename{,.sha256sum}
    echo "[+] Downloading file $dir/$(basename $filename) ..."
    mkdir -p $dir
    curl -Lo $dir/$filename $url
    echo "[+] Creating checksum (sha256) for $dir/$filename ..."
    sha256sum $dir/$filename \
        > $dir/$filename.sha256sum
done < files.list
