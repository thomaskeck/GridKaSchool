GKUSER=gks
PASSWORD=thebestscipyintroductionatthegridkaschool

# Install required packages
apt-get install python3-pip python3-virtualenv
apt-get install libfreetype6-dev libpng12-dev pkg-config
apt-get install llvm libedit-dev
apt-get install git

# Change to user account and to his home directory
su $GKUSER
cd

# Setup python environment
python3 -m virtualenv -p python3 venv
source venv/bin/activate
pip3 install -U pip3 setuptools
pip3 install numpy
pip3 install widgetsnbextension
pip3 install jupyter ipython matplotlib pandas scipy scikit-learn sympy
pip3 install Cython tensorflow
pip3 install llvmlite==0.5.0
pip3 install numba
pip3 install xgboost
pip3 install WordCloud numexpr theano 
pip3 install --upgrade jupyter

# Clone git repository
git clone https://gitlab.ekp.kit.edu/tkeck/GridKaSchool.git

# Generate SSL Certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout jupyter_key.key -out jupyter_cert.pem
mkdir ssl
mv jupyter_key.key ssl/ 
mv jupyter_cert.pem ssl/ 

# Configure Jupyter notebook
jupyter notebook --generate-config
echo "c.NotebookApp.certfile = '/home/$GKUSER/ssl/jupyter_cert.pem'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = '/home/$GKUSER/ssl/jupyter_key.key'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = u'"$(python3 -c "from notebook.auth import passwd; print(passwd('$PASSWORD'))")"'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8080" >> .jupyter/jupyter_notebook_config.py

# Automatically source environment and workaround for
# https://github.com/jupyter/notebook/issues/1318
echo "source ~/venv/bin/activate" >> .bashrc
echo "unset XDG_RUNTIME_DIR" >> .bashrc
