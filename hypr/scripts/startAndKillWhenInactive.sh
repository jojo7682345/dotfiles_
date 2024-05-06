$1&disown
pid=$!

getActiveWindowPid() {
	echo $(hyprctl activewindow | grep "pid: " | cut -f2 -d' ' | sed -e 's/^[ \t]*//')
}
wasActive=false
sleep 3
while kill -0 $pid; do
	if [[ $(getActiveWindowPid) = $pid ]]; then
		wasActive=true;
	else
		if [[ $wasActive = true ]]; then
			kill -9 $pid
			break
		fi
	fi

	sleep 0.1;
done
