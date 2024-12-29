# GESTIONE UTENTI 

Rimuovi utenti
`deluser --remove-home dev`

Elenca utenti
`cut -d: -f1 /etc/passwd`

# ASSEGNAZIONE FLOATING IP

Assegnazione temporanea
`sudo ip addr add 123.123.123.123 dev eth0`

Crea configurazione netplan per test
`sudo touch ~/ip-test.yaml`
`sudo chmod 600 ~/ip-test.yaml`

Crea configurazione netplan per test - Configurazione base IPv4
```
network:
   version: 2
   renderer: networkd
   ethernets:
     eth0:
       addresses:
       - 123.123.123.123/32
```

Test configurazione per 60 secondi
`sudo netplan try ip-test.yaml --timeout 60`
Se non funziona pare bisogna riavviare 

Sposta configurazione di test come permanente
`sudo mv ~/ip-test.yaml /etc/netplan/60-floating-ip.yaml`

Riavvia netplan per applicare
`sudo netplan apply`

# GESTIONE NGINX 

Verifica configurazione
`sudo nginx -t`

Controlla lo stato
`sudo systemctl status nginx`

Avvia
`sudo systemctl start nginx`

Ferma
`sudo systemctl stop nginx`

Riavvia
`sudo systemctl restart nginx`

Ricarica configurazione
`sudo systemctl reload nginx`

# VERIFICA UNATTENDED AUTO-UPGRADES

Verifica che sia abilitato
`cat /etc/apt/apt.conf.d/20auto-upgrades`

Verifica per cosa è abilitato
`cat /etc/apt/apt.conf.d/50unattended-upgrades |grep –v`

# GESTIONE GIT 

Imposta la chiave da usare per git a livello macchina, sconsigliato!
`GIT_SSH_COMMAND="ssh -i $PERCORSO_CERT"`

Imposta la chiave per ogni invocazione successiva su quella repo, sconsigliato se si è già usato il successivo!
`git config core.sshCommand "ssh -i $PERCORSO_CERT"`

Clona una repo specificando il certificato da usare
`git clone -c "core.sshCommand=ssh -i $PERCORSO_CERT" $PERCORSO_REPO $PERCORSO_DESTINAZIONE`

Verifica sshCommand 
`git config --get core.sshCommand`

# GESTIONE PM2 - GENERALE

Genera comando per avvio automatico
`pm2 startup systemd`

Avvia demone pm2 per l'utente. Richiede che sia stato generato il comando, v. comando precedente.
`sudo systemctl start pm2-$UTENTE`

Controlla lo stato del demone
`sudo systemctl status pm2-$UTENTE`

Lista processi gestiti
`pm2 ls`

Monitor real-time processi gestiti
`pm2 monit`

Avvia applicazione con un nome specifico
`pm2 start $PERCORSO_APP -n $NOME_APP`

Ferma applicazione
`pm2 stop $NOME_APP`

Elimina applicazione
`pm2 delete $NOME_APP`

Riavvia applicazione
`pm2 restart $NOME_APP`

Informazioni applicazione
`pm2 info $NOME_APP`

Esegui comando su tutte le applicazioni (es. avvia/rimuovi tutte)
`pm2 $COMANDO all`

# GESTIONE PM2 - ECOSYSTEM

Genera una configurazione semplice (/home/utente/ecosystem.config.js)
`pm2 init simple`

Start all applications
`pm2 start ecosystem.config.js`

Stop all
`pm2 stop ecosystem.config.js`

Restart all
`pm2 restart ecosystem.config.js`

Reload all
`pm2 reload ecosystem.config.js`

Delete all
`pm2 delete ecosystem.config.js`

Avvia app specifica/e
`pm2 start ecosystem.config.js --only $NOME_APP`
`pm2 start ecosystem.config.js --only "$NOME_APP1,$NOME_APP2"`

# Percorsi

`/etc/nginx`: The Nginx configuration directory. All of the Nginx configuration files reside here.

`/etc/nginx/nginx.conf`: The main Nginx configuration file. This can be modified to make changes to the Nginx global configuration.

`/etc/nginx/sites-available/`: The directory where per-site server blocks can be stored. Nginx will not use the configuration files found in this directory unless they are linked to the sites-enabled directory. Typically, all server block configuration is done in this directory, and then enabled by linking to the other directory.

`/etc/nginx/sites-enabled/`: The directory where enabled per-site server blocks are stored. Typically, these are created by linking to configuration files found in the sites-available directory.

`/etc/nginx/snippets`: This directory contains configuration fragments that can be included elsewhere in the Nginx configuration. Potentially repeatable configuration segments are good candidates for refactoring into snippets.

`/var/log/nginx/access.log`: Every request to your web server is recorded in this log file unless Nginx is configured to do otherwise.

`/var/log/nginx/error.log`: Any Nginx errors will be recorded in this log.

`/etc/netplan`: netplan configuration folder

`/etc/network`: ifupdown configuration folder

`/run/systemd/network/`: networkd configuration folder

`/etc/systemd/network/`: networkd  configuration folder (copy to)