### Prerequisites:
- Java
- Conky
- yq | Install using command as `sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq`

### Add below to startup scripts

```
start-gnome-conky.sh
```

### Add Weather Extractor
- Edit the Path in `weather` file to your user's `home` directory
- Add `crontab` entry as below
```
*/5 * * * * ~/.conky/gnome-conky/weather >> /dev/null 2>&1
```
- Logs can be monitored in logs at `~/.conky/gnome-conky/weather.log`
