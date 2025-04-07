### shared folder for users

```bash
sudo mkdir shared
sudo groupadd shared
sudo usermod -a -G shared kira
sudo chown :shared shared
sudo chmod g+rwx shared
sudo chmod g+s shared
```

### Ollama and lm-studio setup

```
curl -fsSL https://ollama.com/install.sh | sh

sudo vi /etc/systemd/system/ollama.service
Environment="OLLAMA_MODELS=/home/shared/ollama/.ollama/models"
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_NUM_PARALLEL=2"


sudo usermod -a -G shared ollama

```
