### Prerequisites:
- Java
- Conky
- `sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq`

### Working

```
nohup conky -c ~/.conky/gnome-conky/gnome-rings 2>&1  </dev/null &
nohup conky -c ~/.conky/gnome-conky/gnome-mem-processes 2>&1  </dev/null &
nohup conky -c ~/.conky/gnome-conky/gnome-cpu-processes 2>&1  </dev/null &
nohup conky -c ~/.conky/gnome-conky/gnome-temp 2>&1  </dev/null &
nohup conky -c ~/.conky/gnome-conky/gnome-weather 2>&1  </dev/null &
```

### In Progress
```

```
