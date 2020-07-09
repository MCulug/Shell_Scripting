#!/bin/sh
WSPcount=`cat input.txt | wc -l`    #count the rows inside text
i=1

while [ $i -le $WSPcount ];         #loop for the word count
do
sed -n $i'p' input.txt > temp.txt   #copy first row of input file to temporary file for loop

parameter_one="$(cat temp.txt | cut -d'#' -f1)"   #extract first parameter in temp.txt delimited by # character
>temp.txt

echo "<soapenv:Envelope xmlns:soapenv="'"http://schemas.xmlsoap.org/soap/envelope/"'">" >> somerequest.xml
echo "<soapenv:Header/>" >>  somerequest.xml
echo "<soapenv:Body>" >>  somerequest.xml
echo "<name="'"'$parameter_one'"'"/>" >>  somerequest.xml     #create some xml file and insert parameter_one into it

curl -k -u user:pass -d @somerequest.xml https://targethost > status.xml   # do curl request

cp status.xml $parameter_one"status.xml"
>somerequest.xml            

extract_parameter=`sed -n '/.*<sometag>\([^<][^<]*\)<\/sometag>.*/s//\1/p' status.xml`  #extract another parameter inside status.xml

cat $extract_parameter | openssl enc -base64 >> Upload.xml                              #encode base64 the file and write it to xml

curl -k -u user:pass -d @Upload.xml https://targethost > $WSPname"uploadresult.xml"     #make the final curl request
>Upload.xml

i=$(($i+1))
done
