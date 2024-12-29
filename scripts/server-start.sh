#ToDo: variabili da valorizzare con input utente
PUB_KEY="CHIAVE"
NODE_VERSION=22
HTML_SPLASH="https://raw.githubusercontent.com/lambia/struttura-setup-cli/master/public/index.html"
FLOATING_IP_CFG="https://raw.githubusercontent.com/lambia/struttura-setup-cli/master/public/60-floating-ip.yaml"
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
sudo nano /etc/nginx/nginx.conf 

# PARTE INTERATTIVA ??
echo
echo "Configurazione nginx"
echo "Modifica welcome page"
sudo curl --output /var/www/html/index.html "$HTML_SPLASH"
echo "Riavvio nginx"
sudo nginx -t
sudo systemctl restart nginx
# FINE PARTE INTERATTIVA

echo 
echo "Installo i pacchetti npm globali"
sudo npm install pm2@latest -g && sudo npm install npm@latest -g 
npm -v 

echo
echo "Imposto il Floating IP"
echo "Dovrai cambiare manualmente l'IP"
# PARTE INTERATTIVA
sudo curl --output /etc/netplan/60-floating-ip.yaml "$FLOATING_IP_CFG"
sudo nano /etc/netplan/60-floating-ip.yaml
# FINE PARTE INTERATTIVA
sudo chmod 600 /etc/netplan/60-floating-ip.yaml
sudo netplan apply

#echo 
#echo "Cambio il Default Source Address dal Primary IP al Floating IP 49.13.32.151 -- ATTENZIONE!!"
# non più necessario, spostato in netplan
#ip route show
#sudo ip route replace default via 172.31.1.1 dev eth0 proto dhcp src 49.13.32.151 metric 100

echo 
echo "Installo certbot e relativi certificati"
sudo apt install certbot python3-certbot-nginx
#sudo certbot --nginx -d staging.example.com
#sudo certbot --nginx -d example.com -d www.example.com
sudo systemctl status certbot.timer
sudo certbot renew --dry-run

echo 
echo "Setup completato, dovresti riavviare la macchina ed eseguire lo script di deploy"