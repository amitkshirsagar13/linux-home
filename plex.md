### plex setup

```
# Create link for library data
cd /var/lib/plexmediaserver/
sudo ln -s /media/kira/2tb/plex.data/library Library

# change user and group for plex service
sudo systemctl stop plexmediaserver
sudo vi /usr/lib/plexmediaserver/lib/plexmediaserver.default
sudo vi /lib/systemd/system/plexmediaserver.service
systemctl status plexmediaserver.service
sudo systemctl daemon-reload
sudo systemctl start plexmediaserver
```
