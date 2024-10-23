USER="seu_user"
DBPASS="$1"
DBHOST="seu_endpoint.com"

OUTPUT=$(mysql -u ${USER} -p''${DBPASS}'' -h ${DBHOST} -e "
SELECT sla.slaid,
       REGEXP_REPLACE(sla.name, '.*/', '') AS sla_name,
       svc.serviceid,
       REGEXP_REPLACE(svc.name, '.*/', '') AS service_name
FROM sla sla
JOIN services svc
  ON sla.name LIKE CONCAT('%', SUBSTRING_INDEX(svc.name, '/', -1))
WHERE sla.name LIKE 'SLA/VENDAS/TOTEM/%'
  AND svc.name regexp 'SERVICE/VENDAS/TOTEM/.*WKT0[678]$'
  ORDER BY sla_name
  ; " --database=zabbix --batch --skip-column-names 2>/dev/null | sed -r 's:\t:,:g' )


OB_NAME=${3:-"SLA_NAME"}

jq -Rn --arg OB_NAME "$OB_NAME" '
{
  "data": [
    inputs
    | split(",")
    | {("{#SLA_ID}"): .[0], ("{#" + $OB_NAME + "}"): .[1], "{#SERVICE_ID}": .[2]}
  ]
}' <<<"${OUTPUT}"
