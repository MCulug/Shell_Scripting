#!/bin/bash

USER_NAME=someuser
USER_PASSWORD=somepass
CONFLUENCE_BASE_URL=https://someurl:someportnumber/confluence
i=$(($1))                      #index number

while [ $i -le $2 ];         #loop from first dir to last
do

cd KB/$i

Filecount=`ls | wc -l`
Photocount=$(($Filecount-1))
a=0

if [ $Filecount -eq 1 ]
then
   curl -k -u $USER_NAME:$USER_PASSWORD -X POST --header "Content-Type: application/json" -d @request.txt ${CONFLUENCE_BASE_URL}/rest/api/content
fi

if [ $Filecount -gt 1 ]
then
curl -k -u $USER_NAME:$USER_PASSWORD -X POST --header "Content-Type: application/json" -d @request.txt ${CONFLUENCE_BASE_URL}/rest/api/content > status.json
extract_contentID=`sed -n 1p status.json | awk -F "\"" '{print $4}'`
while [ $a -lt $Photocount ];    # request loop for photo attachments
do 
ATTACHMENT_FILE_NAME=$a".png"
curl -u $USER_NAME:$USER_PASSWORD -X POST -H "X-Atlassian-Token: nocheck" -F "file=@${ATTACHMENT_FILE_NAME}" -F "comment=File attached via REST API" ${CONFLUENCE_BASE_URL}/rest/api/content/${extract_contentID}/child/attachment 2>/dev/null 
a=$(($a+1))
done
fi

i=$(($i+1))
cd ../..

done

