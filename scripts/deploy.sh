#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=springboot2-webservice

echo "> copy build files"

cp $REPOSITORY/zip//*.jar $REPOSITORY/

echo "> check running pid"

CURRENT_PID=$(pgrep -fl springboot2-webservice | grep jar | awk '{print $1}')

echo "current running pid: " $CURRENT_PID

if [ -z "$CURRENT_PID" ]; then
    echo "> no running application"
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "> deploy new appliecation"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> change permission $JAR_HOME"

chmod +x $JAR_NAME

echo "> running $JAR_NAME"

nohup java -jar \
    -Dspring.config.location=classpath:/application.yml,/home/ec2-user/app/application-oauth.yml,/home/ec2-user/app/aaplication-real-db.yml,classpath:/application-real.yml \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &