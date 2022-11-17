SITE=$1
PORT_NUMBER=$2



        if [ -z ${PORT_NUMBER} ]

                then PORT_NUMBER=443

        fi

DATE_CERT=$(echo | openssl s_client -connect ${SITE}:${PORT_NUMBER} 2>/dev/null | openssl x509 -noout -dates |tail -n1|  sed -e '/notAfter=/s/notAfter=//g' | sed 's/GMT$//'| awk '{print "date --iso-8601 --date", "\""$0"\""}' | bash | awk -F"-" '{print $1$2$3}')
DATE_CERT_S=$(date +%s --date "${DATE_CERT}")
DATE_NOW=$(date +%s)
DATE_DIFF=$((${DATE_CERT_S}-${DATE_NOW}))
