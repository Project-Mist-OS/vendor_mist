lunch_others_targets=()
for device in $(python vendor/mist/tools/get_official_devices.py)
do
    for var in user userdebug eng; do
        lunch_others_targets+=("mist_$device-$var")
    done
done
