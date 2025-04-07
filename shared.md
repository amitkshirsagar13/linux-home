### shared folder for users


```bash
sudo mkdir shared
sudo groupadd shared
sudo usermod -a -G shared kira
sudo chown :shared shared
sudo chmod g+rwx shared
sudo chmod g+s shared
```
