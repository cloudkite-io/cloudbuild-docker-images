#!/bin/bash
HELM_HISTORY=$(helm history $1 -n $2)
HELM_STATUS=$( echo "$HELM_HISTORY" | tail -n 1 | awk '{print $7}')

echo "#################### Checking if there is a pending upgrade..."

if [[ $HELM_STATUS != "pending-upgrade" ]]
then
  echo "#################### There is no pending upgrade."
  exit 0
fi

if [[ $HELM_STATUS = "pending-upgrade" ]]
then
  CURRENT_UPGRADE_TIME=$( echo "$HELM_HISTORY" | tail -n 1 | awk '{print $3" "$4" "$5" "$6}')
  UPGRADE_DURATION=$(echo $(( ($(date +%s) - $(date --date="$CURRENT_UPGRADE_TIME" +%s))/(60) )))

  if [[ $UPGRADE_DURATION -lt 30 ]]
  then
    echo "#################### The previous build is still running. Please try again in $(( 30-$UPGRADE_DURATION )) minutes".
    exit 1
  else
    echo "#################### There is a failed deployment."

    history_length=$(( $( echo "$HELM_HISTORY" | wc -l ) - 1))

    i=1
    while [[ "$i" -le "$history_length" ]]; do
    
      LAST_DEPLOYMENT=$( echo "$HELM_HISTORY" | tail -n "$i" | head -n 1)
      CURRENT_STATUS=$( echo $LAST_DEPLOYMENT | awk '{print $7}')
      CURRENT_HISTORY=$( echo $LAST_DEPLOYMENT | awk '{print $1}')

      if [[ $CURRENT_STATUS = "deployed" ]]
      then
        echo -e "\n$HELM_HISTORY\n"

        echo  -e "Rolling back to the last successful deployment($CURRENT_HISTORY) ...\n\n"
        helm rollback $1 $CURRENT_HISTORY -n $2 --debug

        if [ $? -eq 0 ]
        then
          echo "#################### Successfully rolled back to $CURRENT_HISTORY!!!".
          exit 0
        else
          echo "#################### The helm release could not be rolled back. Please try again."
          exit 1
        fi

      fi
      i=$(($i + 1))
    done
  fi
fi