#!/usr/bin/env bash

MPRIS_META=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata)
ARTIST=$(echo "$MPRIS_META" | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2)
SONG_TITLE=$(echo "$MPRIS_META" | sed -n '/title/{n;p}' | cut -d '"' -f 2)
ARTWORK=$(echo "$MPRIS_META" | sed -n '/artUrl/{n;p}' | cut -d '"' -f 2)
MEDIA_ICON=$(curl -sL "$ARTWORK" | base64 -w 0)
PLAY="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play"
PAUSE="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause"
PLAY_PAUSE="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
NEXT="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
PREVIOUS="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"

if [ ! -z "$ARTIST" ]; then
	echo "$ARTIST - $SONG_TITLE | image='$MEDIA_ICON' imageWidth=20"
	echo "---"
	if [ ! -z "$ARTWORK" ]; then
		echo "| image='$MEDIA_ICON' imageWidth=160 bash='wmctrl -a Spotify' terminal=false"
		echo "$ARTIST"
		echo "$SONG_TITLE"
		echo "---"
		echo "Skip Back | iconName=media-skip-backward bash='$PREVIOUS' terminal=false"
		echo "Play Pause | iconName=media-playback-start bash='$PLAY_PAUSE' terminal=false"
		echo "Skip Forward | iconName=media-skip-forward bash='$NEXT' terminal=false"
		if [ $(xwininfo -all -id 0x4a00001 | grep "Hidden" | wc -l) == "1" ]; then
			echo "---"
			echo "Open Spotify | bash='wmctrl -a Spotify' terminal=false"
		fi
	else
		echo "No Artwork"
	fi
else
	echo "Spotify | bash='spotify' terminal=false"
	echo "---"
	echo "Launch Spotify | bash='spotify' terminal=false"
fi