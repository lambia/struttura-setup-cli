REPO=lambia/struttura
REPO_CONN=git@github.com:$REPO.git
GIT_CERT=struttura_git
PERSON=dev

echo 
echo "Creo chiave SSH per Git"
ssh-keygen -t ed25519 -a 100 -C server@github.com -f ~/$GIT_CERT -q -N ""
echo "Copia la seguente chiave tra le deploy keys della tua repo"
echo "Link: https://github.com/$REPO/settings/keys"
cat ~/$GIT_CERT.pub 

############## qui inizia loop
SITO=alphawax.com
PORT=8001

echo
echo "Creo la cartella per $SITO e ne imposto i permessi"
sudo mkdir /var/www/$SITO 
sudo chown -R $PERSON:$PERSON /var/www/$SITO 
sudo chmod -R 755 /var/www/$SITO

echo
echo "Clono la repo, installo le dipendenze, imposto il .env e avvio PM2"
git clone -c "core.sshCommand=ssh -i ~/$GIT_CERT" $REPO_CONN /var/www/$SITO 
cd /var/www/$SITO #importante per npm ma anche per lanciare pm2
npm i 
cp .env.example .env
echo "APP_PORT=$PORT" >> .env
echo "APP_SITE_FOLDER=../sites/$SITO" >> .env
pm2 start /var/www/$SITO/app/server.js -n $SITO 

echo
echo "Creo server-block per nginx e lo abilito"
sudo touch /etc/nginx/sites-available/$SITO
$SITE_CFG = "server { 
        listen 80; 
        listen [::]:80; 

        server_name $SITO www.$SITO; 

        location / { 
                proxy_pass http://localhost:$PORT; 
                proxy_http_version 1.1; 
                proxy_set_header Upgrade \$http_upgrade; 
                proxy_set_header Connection 'upgrade'; 
                proxy_set_header Host \$host; 
                proxy_cache_bypass \$http_upgrade; 
        } 
} "
sudo echo $SITE_CFG > /etc/nginx/sites-available/$SITO
sudo ln -s /etc/nginx/sites-available/$SITO /etc/nginx/sites-enabled/

SITO=
############## qui fine loop

echo
echo "Imposto PM2 per l'avvio automatico"
pm2 ls
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u dev --hp /home/dev 
pm2 save

sudo nginx -t
sudo systemctl restart nginx

echo 
echo "Setup completato, dovresti riavviare la macchina"


# todo
# manca https
# chiedere all'utente quali passaggi eseguire
# mancano header addizionali per il server
# sites_available: fare cURL di una config su github
# sites_available: gestire location /editor 
# sites_available: gestire static assets e 404 
# rimuovi default site /var/www/html 
