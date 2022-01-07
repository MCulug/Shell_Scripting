#!/bin/sh

USER_NAME=api.admin
USER_PASSWORD=pass
CONFLUENCE_BASE_URL=https://sdlctest.ibtech.com.tr:444/confluence
i=1

ls KB > counter.txt
counter=`cat counter.txt | wc -l`

while [ $i -le $counter ];         #loop from first dir to last
do

dir=`sed -n ${i}'p' counter.txt`
cd KB/$dir

Filecount=`ls | wc -l`
Photocount=$(($Filecount-1))
a=0

if [ $Filecount -eq 1 ];
then
curl -k -u $USER_NAME:$USER_PASSWORD -X POST --header "Content-Type: application/json" -d @request.txt ${CONFLUENCE_BASE_URL}/rest/api/content
fi

if [ $Filecount -gt 1 ];
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

