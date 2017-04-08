# Instalação do R

## A partir dos fontes

```
wget https://cran.rstudio.com/src/base/R-3/R-3.3.3.tar.gz
# tar xvf install/R/R-3.3.3.tar.gz
tar xvf R-3.3.3.tar.gz
cd R-3.3.3
echo "Instalando o R no diretório $HOME/R"
./configure --prefix=$HOME/R --with-readline=no --with-x=no
make && make install
cd ~/
ls -la R
echo "#" >> ~/.profile
echo "export PATH=~/R/bin:\$PATH" >> ~/.profile
echo "#" >> ~/.profile

```
