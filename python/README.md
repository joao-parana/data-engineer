# Instalação do Python

## A partir dos fontes

```bash
wget wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
tar xf Python-2.7.13.tgz
cd Python-2.7.13/
echo "Instalando o Python no diretório $HOME/R"
./configure --prefix=$HOME/python
make && make install
cd ~/
ls -la python
echo "#" >> ~/.profile
echo "export PATH=~/python/bin:\$PATH" >> ~/.profile
echo "#" >> ~/.profile
export PATH=~/python/bin:$PATH
```

## Instalação de pacotes

**pip** é usado para instalar pacotes python. Precisamos instalar _pip_ de forma que ele instale os pacotes para a versão do Python correta.

```bash
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py -O - | python - --user
ls .local/bin .local/lib
echo "#" >> ~/.profile
echo "export PATH=.local/bin:\$PATH" >> ~/.profile
echo "#" >> ~/.profile
export PATH=.local/bin:$PATH
```
