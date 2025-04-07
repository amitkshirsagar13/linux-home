### shared folder for users

```bash
sudo mkdir shared
sudo groupadd shared
sudo usermod -a -G shared kira
sudo chown :shared shared
sudo chmod g+rwx shared
sudo chmod g+s shared
```
### ollama and lm-studio

```
curl -fsSL https://ollama.com/install.sh | sh

sudo vi 
Environment="OLLAMA_MODELS=/home/shared/ollama/.ollama/models"

sudo usermod -a -G shared ollama

```
