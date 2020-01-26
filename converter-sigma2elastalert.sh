#!/bin/bash
#author kalle.eriksson@pm.me

## Debug properties 
#set -x
VERBOSE="NO"

[ "$1x" = "-vx" ] && VERBOSE=YES
[ ${VERBOSE} = YES ] && echo "Converter for sigma to elastic 6.8"

#working in if .. of sigma.

[ ! -d sigma ] && echo "Cant find sigma folder - git clone https://github.com/Neo23x0/sigma" && exit 1
[ ${VERBOSE} = YES ] && echo "Found sigma pull"

SIGMAC_BASE_PATH="sigma"
SIGMAC_BIN="$SIGMAC_BASE_PATH/tools/sigmac"
SIGMAC_CONF="SIGMAC_BASE_PATH/tools/config/generic/windows-audit.yml"

ELASTALERT_OUTPUT_FOLDER=elastalert
ELASTALERT_ELASTIC_COMPAT=winlogbeat-old
# enable below for 7.x
#ELASTALERT_ELASTIC_COMPAT=winlogbeat

function worker () {
  SIGMAC_RULES_PATH="sigma/$1"
  for folder in $(ls ${SIGMAC_RULES_PATH})
  do
    [[ "$folder" == "*windows" ]] && echo Changing BASE to windows && SIGMAC_RULES_PATH="sigma/rules/windows" 
    [ ${VERBOSE} == YES ] && echo " - Working with ${folder} in $SIGMAC_RULES_PATH"
    [ ${VERBOSE} = YES ] && echo " - Creating output ${ELASTALERT_OUTPUT_FOLDER}/${SIGMAC_RULES_PATH}/${folder}"
    mkdir -p ${ELASTALERT_OUTPUT_FOLDER}/${SIGMAC_RULES_PATH}/${folder}
    for alert in $(ls ${SIGMAC_RULES_PATH}/${folder}/*yml 2>/dev/null)
    do 
      [ ${VERBOSE} == YES ] && echo " -- Woring with ${alert}"
      #[[ $alert == sysmon* ]] && SIGMAC_CONF="sigma/tools/config/generic/sysmon.yml"
      #[[ $alert == powershell* ]] && SIGMAC_CONF="sigma/tools/config/powershell.yml"
      #[[ $alert == windows* ]] && SIGMAC_CONF="sigma/tools/config/generic/windows-audit.yml"
      [ ${VERBOSE} == YES ] && echo " -- Processing $alert"
      ${SIGMAC_BIN} -t elastalert -c ${ELASTALERT_ELASTIC_COMPAT} ${alert} -o ${ELASTALERT_OUTPUT_FOLDER}/${alert} 2>/dev/null
    done
  done
}
disclaimer () {
  NOT_SuP=( $(find sigma/rules -type file -exec grep -Hn  near {} \; |cut -f1 -d:) )
  [ ${VERBOSE} = YES ] && echo "- DISCLAIMER"
  [ ${VERBOSE} = YES ] && echo "-- These files alerts were not processed - not supported by backend"
  [ ${VERBOSE} = YES ] && echo "--- ${NOT_SuP[*]}" 
}
main () {
  worker rules
  worker rules/windows
  disclaimer 
}
main
