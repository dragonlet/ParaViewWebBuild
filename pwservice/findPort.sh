 #!/bin/bash
 # FileName: findPort.sh
 
for port in {11111..11211}
do 
   result=`netstat -vatn | grep ":$port " | wc -l`
   if [ $result == 0 ]
   then
       echo "$port"
       exit 0
   fi
done
