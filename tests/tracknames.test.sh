#!/bin/bash

TESTPROG=../scripts/tracknames.py
TMP=/tmp
TEMPDIR=$TMP/$(basename $0).$$.$(date +%s)

mkdir $TEMPDIR

cat > $TEMPDIR/info.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<disc>
<artist>Test</artist>
<album>Test</album>

<track>
<tracknumber>1</tracknumber>
<title>Hellö Worldé</title>
</track>

<track>
<tracknumber>2</tracknumber>
<title>You, Me &amp; Bobby Màgee/One More Time...</title>
</track>

<track>
<tracknumber>3</tracknumber>
<title>&quot;::Big ([bad?]) Betty::!&quot;</title>
</track>

<track>
<tracknumber>4</tracknumber>
<title>Große Fuge</title>
</track>
</disc>
EOF

tests=('01.ogg' '03 Big Betty.flac' 'Track02---.wav' \
    'Große Fuge 04.ogg')

results=('01-Hello_Worlde.ogg' \
    '03-___Big___bad____Betty____.flac' \
    '02-You_Me_And_Bobby_Magee--One_More_Time.wav' \
    '04-Grosse_Fuge.ogg')

errorCode=0

trap 'rm -rf $TEMPDIR' EXIT

#
# First run test by changing to directory
#

cd $TEMPDIR

set "${tests[@]}"
for testFile; do touch "$testFile"; done

if ! ~-/$TESTPROG "$@"; then
    echo "Error returned from $TESTPROG, called with $@" >&2
    errorCode=1
fi

set "${results[@]}"
for resultFile; do
    if [ ! -f "$resultFile" ]; then
        echo "Error: Expected $resultFile, but not found" >&2
        errorCode=1
    fi
done

rm *.flac *.ogg *.wav
cd - > /dev/null

#
# Test from different directory
#

set "${tests[@]}"
for testFile; do touch "$TEMPDIR/$testFile"; done

argList=("${tests[@]/#/$TEMPDIR/}")

if ! $TESTPROG "${argList[@]}"; then
    echo "Error returned from $TESTPROG, called with ${argList[@]}" >&2
    errorCode=1
fi

set "${results[@]}"
for resultFile; do
    if [ ! -f "$TEMPDIR/$resultFile" ]; then
        echo "Error: Expected $resultFile, but not found" >&2
        errorCode=1
    fi
done

exit $errorCode
