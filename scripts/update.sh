SITO=alphawax.com

############ INIZIO LOOP
cd /var/www/$SITO 
git pull #forse meglio prima stoppare pm2

pm2 delete $SITO 
pm2 start /var/www/$SITO/app/server.js -n $SITO 
# <- qui attendi conferma prima della prossima iterazione
############ FINE LOOP

pm2 ls 
# pm2 save <--- ???