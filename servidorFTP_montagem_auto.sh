#!/bin/bash
#################
#Script de servidor FTP basico com montagem automatico
#v 1.0
#################

ftpverifica=`dpkg -l | cut -b 1-17 | grep proftpd`
var1="ii  proftpd-basic"
ftpdir="/etc/proftpd"

if [ "$ftpverifica" == "$var1" ] 2> /dev/null; then
echo "Proftpd instalado.....[OK]"
else
echo "instalando Proftpd"
apt-get install proftpd -y
fi

while true; do
read -p 'Parar servidor FTP? [s/n]' OP
case $OP in
	n ) echo "continuando Script..." ;;
	y ) clear; /etc/init.d/proftpd stop;;
esac
echo
done

cd $ftpdir
mv proftpd.conf proftpd.conf_ORIGINAL &&

echo "
#Nome do Servidor
ServerName ''Servidor FTP Auto''

#Modo no qual rodará (standalone ou inetd)
ServerType standalone
DeferWelcome off

#Não exibe informações sobre que tipo de servidor está rodando
ServerIdent off

#fuso horário universal (GMT) e não o local
TimesGMT off
MultilineRFC2228 on

#Tempo Máximo sem transferência de dados
TimeoutNoTransfer 600

#Tempo Máximo com transferência parada(travada)
TimeoutStalled 600

#Tempo Máximo conectado mas sem troca de dados
TimeoutIdle 1200

DisplayLogin welcome.msg
DisplayFirstChdir .message
ListOptions ''-l''
DenyFilter \*.*/

#Logs no Proftp
WtmpLog off

#Arquivo de log geral
SystemLog /var/log/proftpd.log

#Arquivo de log das transferências
TransferLog /var/log/xferlog

#Porta para socket de controle
Port 21
Umask 022 022

#Máximo de usuários autenticados
MaxClientesPerHost 2 ''Mensagem de erro para usuário''

#Numero Máximo de tentativas de login
MaxLoginAttempts 2

#Usuário sob qual o servidor irá rodar
User
nobody
#Grupo
Group nogroup

#Os Usuários não poderão sair de seu diretório home
DefaultRoot ~

#Não permite o login do usuário root
RootLogin off

#Não requer que os usuários tenham um shell válido
RequireValidShell off

#Não bloqueia usuários baseando-se no arquivo /etc/ftpusers
UseFtpUsers off 

 " > proftpd.conf &&

#update-rc.d -f proftpd enable 2 3 4 5

/etc/init.d/proftpd restart &&

echo "é recomendavel que crie um usuario somente para usar o servidor ftp"

echo "Servidor FTP pronto!"
echo ""
echo "exemplo de como acessa servidor ftp, ftp://<ip_do_servidorFTP>"

exit 0
