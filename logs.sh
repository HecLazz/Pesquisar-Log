#!/usr/bin/env bash
#
# listaUsuarios - Extrai logs específicos do auth.log.
#
# Site:           https://seusite.com.br
# Autor           Hector
# Manuntenção:    Hector
#
# --------------------------------------------------------------------
#   Irá extrair informações do auth.log (logs de autorização)
#   informações como, ssh, tentativa de login, abertura de sessão.
#
# Exemplos:
#     $ ./tarefa.sh -h
#       Menu de ajuda
# --------------------------------------------------------------------
# Histórico:
#
#     v1.  06/04/2025, Hector Lazzari:
#             - criação do programa.
# --------------------------------------------------------------------
# Testado em (bash --version):
#     bash 5.2.37
# --------------------------------------------------------------------

# ---------------------------Variáveis---------------------------------
padrao="$(cat /var/log/auth.log)"

mensagem="
  $(basename $0)
  [Opções]
    -h = Menu de Ajuda
    -v = Versão
    -s = ssh
    -a = Sessões (usuários)
    -p = Password (senhas)
    -r = sudo
"
versao="v1.1"

flag_s=0
flag_a=0
flag_p=0
flag_r=0

# ---------------------------Execução---------------------------------
while test -n "$1"
do
  case "$1" in
    -v) echo "$versao"&& exit 0            ;;
    -h) echo "$mensagem"&& exit 0          ;;
    -s) flag_s=1                           ;;
    -a) flag_a=1                           ;;
    -p) flag_p=1                           ;;
    -r) flag_r=1                           ;;
     *) echo "Comando inválido!" && exit 1 ;;
  esac
  shift # talvez o uso do grep não combina parâmetros porque seria como um
        # filtro em cima de outro filtro, exemplo: -s -p, aplicando o filtro
        # de ssh o -p tentaria procurar a palavra password em um filtro
        # somente de ssh.
done

[ "$flag_s" -eq 1 ] && padrao=$(echo "$padrao" | grep -i -n "ssh")
[ "$flag_a" -eq 1 ] && padrao=$(echo "$padrao" | grep -i -n "session")
[ "$flag_p" -eq 1 ] && padrao=$(echo "$padrao" | grep -i -n "password")
[ "$flag_r" -eq 1 ] && padrao=$(echo "$padrao" | grep -i -n "sudo")

echo "$padrao"
