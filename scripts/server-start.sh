#ToDo: variabili da valorizzare con input utente
PUB_KEY="CHIAVE"
NODE_VERSION=22
HTML_SPLASH="https://raw.githubusercontent.com/lambia/struttura-setup-cli/master/index.html"
PERSON=dev

echo 
echo "Disabilito autenticazione SSH via password"
echo "#Luca's Override Config" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep "PasswordAuthentication "
grep PubkeyAuthentication /etc/ssh/sshd_config

echo 
echo "Creo utente non-root ma sudoer"
adduser $PERSON
usermod -aG sudo $PERSON

echo 
echo "Imposto la chiave SSH per l'utente"
mkdir /home/$PERSON/.ssh
touch /home/$PERSON/.ssh/authorized_keys
echo $PUB_KEY > /home/$PERSON/.ssh/authorized_keys

echo 
echo "Imposto i permessi per l'utente"
chown -R $PERSON:$PERSON /home/$PERSON/.ssh 
chmod 700 /home/$PERSON/.ssh 
chmod 600 /home/$PERSON/.ssh/authorized_keys 

echo 
echo "Riavvio SSH"
service ssh restart

echo 
echo "Da questo momento puoi accedere alla macchina con account \"$PERSON\" usando il comando:"
echo "ssh -i PATHCERTIFICATO $PERSON@IPMACCHINA"

echo "Da questo momento impersonifico l'utente \"$PERSON\""
su $PERSON
whoami

echo 
echo "Eseguo gli aggiornamenti"
sudo apt udate 
sudo apt upgrade -y

echo 
echo "Installo i pacchetti system-wide"
cd ~
sudo apt install nginx -y && sudo apt install nginx-extras -y && sudo apt install build-essential -y && sudo apt install nodejs -y
curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x -o nodesource_setup.sh && sudo bash nodesource_setup.sh 

echo 
echo "Verifica dei pacchetti"
sudo systemctl status nginx
node -v 
npm -v 

echo
echo "Configurazione nginx"
echo "Una volta confermato si apre /etc/nginx/nginx.conf per effettuare modifiche manuali"
echo "- Decommenta \"server_names_hash_bucket_size 64\" per fixare il problema di memoria hash bucket"
echo "- Decommenta \"server_tokens off\" per nascondere la versione di nginx e il sistema operativo"
echo "- Aggiungi  \"more_set_headers 'Server: struttura/2.0.0';\" per customizzare l'header \"server\""
pause
sudo nano /etc/nginx/nginx.conf # PARTE INTERATTIVA
echo "Modifica welcome page"
sudo touch /var/www/html/index.html
sudo curl $HTML_SPLASH > /var/www/html/index.html #ToDo: testare
echo "Riavvio nginx"
sudo nginx -t
sudo systemctl restart nginx

echo 
echo "Installo i pacchetti npm globali"
sudo npm install pm2@latest -g && sudo npm install npm@latest -g 
npm -v 

echo 
echo "Setup completato, dovresti riavviare la macchina ed eseguire lo script di deploy"