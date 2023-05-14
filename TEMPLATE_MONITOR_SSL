#/usr/bin/env bash
{ IFS=$'\n'
var=$({
        echo | openssl s_client -connect $1:443 2>/dev/null |\
        openssl x509 -noout -dates
})
var2=$( for i in ${var//GMT/} ; do date -d "${i//not*=/}" +"%s" ; done )

if [[ "$2" == "expired_sum" ]]
        then
        var3=$(echo $(("${var2//[[:space:]]/-}"))) ; echo ${var3:1}
        exit 0
fi

if [[ "$2" == "certgen" ]]
        then head -n1 <<<${var2}
        else tail -n1 <<<${var2}
fi
}
