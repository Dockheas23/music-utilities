strippictags()
{
    metaflac --remove --block-type=PICTURE "$@"
}

setpictags()
{
    if [ -f cover.jpg ]
    then
	for f in $@; do
	    metaflac --import-picture-from=cover.jpg "$f"
	done
    elif [ -f cover.png ]
    then
	for f in $@; do
	    metaflac --import-picture-from=cover.png "$f"
	done
    fi
}

refreshpictags()
{
    if [ -f cover.jpg -o -f cover.png ]
    then
	strippictags "$@" && setpictags "$@"
    fi
}

flac2mp4()
{
    for f; do
	outfile=$(basename ${f/%flac/m4a})
	artist=$(metaflac --show-tag=ARTIST "$f" | sed 's/^ARTIST=//')
	album=$(metaflac --show-tag=ALBUM "$f" | sed 's/^ALBUM=//')
	genre=$(metaflac --show-tag=GENRE "$f" | sed 's/^GENRE=//')
	year=$(metaflac --show-tag=DATE "$f" | sed 's/^DATE=//')
	title=$(metaflac --show-tag=TITLE "$f" | sed 's/^TITLE=//')
	track=$(metaflac --show-tag=TRACKNUMBER "$f" | sed 's/^TRACKNUMBER=//')
	flac -dcs "$f" | faac -o "$outfile" --artist "$artist" \
	--album "$album" --genre "$genre" --year "$year" --title "$title" \
	--track "$track" -
    done
}

flac2mp3()
{
    for f; do
	outfile=$(basename ${f/%flac/mp3})
	artist=$(metaflac --show-tag=ARTIST "$f" | sed 's/^ARTIST=//')
	album=$(metaflac --show-tag=ALBUM "$f" | sed 's/^ALBUM=//')
	genre=$(metaflac --show-tag=GENRE "$f" | sed 's/^GENRE=//')
	year=$(metaflac --show-tag=DATE "$f" | sed 's/^DATE=//')
	title=$(metaflac --show-tag=TITLE "$f" | sed 's/^TITLE=//')
	track=$(metaflac --show-tag=TRACKNUMBER "$f" | sed 's/^TRACKNUMBER=//')
	flac -dcs "$f" | lame - "$outfile"
	id3v2 --artist "$artist" --album "$album" --genre "$genre" \
	--year "$year" --song "$title" --track "$track" "$outfile"
    done
}

flac2ogg()
{
    for f; do
	oggenc -o "$(basename ${f/%flac/ogg})" "$f"
    done
}
