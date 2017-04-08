# Instalação do Python

## A partir dos fontes

```
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

```
