#!/bin/bash
cd

# Setup python environment
python3 -m virtualenv -p python3 venv
source venv/bin/activate
pip3 install setuptools==36.2.7
pip3 install pip==9.0.1
pip3 install numpy==1.13.1
pip3 install jupyter==1.0.0
pip3 install matplotlib==2.0.2
pip3 install scipy==0.19.1
pip3 install pandas==0.20.2
pip3 install sympy==1.1.1
pip3 install scikit-learn==0.19.0
pip3 install tensorflow==1.3.0
pip3 install xgboost==0.6a2
pip3 install theano==0.10.0b1
pip3 install Cython==0.26
#pip3 install llvmlite==0.5.0
#pip3 install numba==0.34.0
pip3 install numexpr==2.6.2
pip3 install WordCloud==1.3.1

# Clone git repository
git clone https://gitlab.ekp.kit.edu/tkeck/GridKaSchool.git

# Generate SSL Certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout jupyter_key.key -out jupyter_cert.pem <<CERTEOF
DE
BW
KA
KIT
SCC
$(hostname).scc.kit.edu
.
CERTEOF
mkdir ssl
mv jupyter_key.key ssl/ 
mv jupyter_cert.pem ssl/ 

# Configure Jupyter notebook
jupyter notebook --generate-config
echo "c.NotebookApp.certfile = '/home/gks/ssl/jupyter_cert.pem'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = '/home/gks/ssl/jupyter_key.key'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = u'"$(python3 -c "from notebook.auth import passwd; print(passwd('$PASSWORD'))")"'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8080" >> .jupyter/jupyter_notebook_config.py

# Automatically source environment and workaround for
# https://github.com/jupyter/notebook/issues/1318
echo "source ~/venv/bin/activate" >> .bashrc
echo "unset XDG_RUNTIME_DIR" >> .bashrc

