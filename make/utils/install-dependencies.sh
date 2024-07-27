#!/usr/bin/env sh

for prj in $(ls -d $@ 2>/dev/null | grep -v '/_'); do
    ( cd "${prj}" && make install-production )
done

exit 0
