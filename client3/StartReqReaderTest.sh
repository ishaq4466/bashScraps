#!/bin/bash

SCRIPT_PATH="/home/ec2-user/bashScraps/client3/"
# Main function for starting the reqReader on Remote Server

startReqReader()
{

# Main programs to start the reqReader
echo "****Executing the main logic to start the reqReader****"
sleep 10s
}


# Function will return the reqReader status flag from the db table
getReqReaderStatus()
{

sqlQuery="select column_name  from table_name where condition"

:<<COMMENT	
	reqReadStatus= $ (
		sqlplus -S $USER/$PASSWD@$TNS<<-END
		set heading off
		set feedback off
		set pages
		$sqlQuery
		END
		)	
	echo $reqReadStatus
COMMENT
	source $SCRIPT_PATH/Master.config
	echo $READERSTATUS
}

# Function will update the status flag for reqReader in db table
# Funtion calling: updateReqReaderStatus <status-to-update>
updateReqReaderStatus()
{
	statusToUpdte=$1
	echo "UPDATING STATUS TO '$statusToUpdte'"
	sqlQuery="update table_name set column_name='$statusToUpdte' where condition"
	echo $sqlQuery

:<<COMMENT	
	sqlplus -S $USER/$PASSWD@$TNS<<-END
	set heading off
	set feedback off
	set pages
	$sqlQuery
	END
COMMENT
	sed -i "s/READERSTATUS=.*/READERSTATUS=$statusToUpdte/g" $SCRIPT_PATH/Master.config
}

CRONLOG=$SCRIPT_PATH/CRONLOG_$(date "+%d%h%Y").log

exec 3>&1 1>>$CRONLOG 2>&1  

echo "*****************************************"
echo "CRON TRIGERRED AT: $(date "+%H:%M:%S")"
echo "*****************************************"
echo "================================================="
echo "FETCHING THE REQREADER STATUS FROM DB TABLE"
echo "================================================="
readerStatus=$(getReqReaderStatus) 
echo "REQREADER STATUS IN DB TABLE: $readerStatus"
echo "================================================="
if [ "$readerStatus" == "START" ]
then
	echo "Starting the reqReader on the remote Server"
	startReqReader
	echo "ReqReader Started successfully on Remote server"
	updateReqReaderStatus "STARTED"
echo "================================================="
elif [ "$readerStatus" == "STARTED" ]
then
	echo "ReqReader is already in started state on the remote server"

fi
echo
echo




#https://drive.google.com/open?id=1BhE_iOnFJmKzQjS0ulg47PXuuCmn-QFw

:<<COMMENT

while :
do 
clear
echo "Configured a cron job of 1minute interval"
echo "***********************************************"
./StartReqReaderTest.sh
sleep 1m
echo "************************************************"
clear
# */1 * * * * . /home/ec2-user/bashScraps/client3/StartReqReaderTest.sh
done
COMMENT





