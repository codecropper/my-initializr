#!/bin/bash
JAVA_VERSION=1.8
BOOT_VERSION=1.5.8.RELEASE
GROUP_ID=cn.imlh
BASE_DEPENDENCE=web,cloud-starter
LANG=java
TYPE=maven-project

WORK_DIR=`dirname $0`

function init(){
    artifactId=$1;baseDir=$1 # set project folder=artifactId
    name=$2                  # project name
    description=$3           # project description 
    dependencyX=$4           # extra dependency

    curl http://start.spring.io/starter.tgz \
    -d language=${LANG} -d type=${TYPE} \
    -d javaVersion=${JAVA_VERSION} -d bootVersion=${BOOT_VERSION} -d version=1.0.0.SNAPSHOT \
    -d groupId=${GROUP_ID} -d artifactId=${artifactId} -d baseDir=${artifactId} -d name=${name} \
    -d dependencies=${BASE_DEPENDENCE},${dependencyX} \
    -d description=${description} \
    |tar -xzvf -

    # 换阿里云wrapper加速
    mavenWrapper=$artifactId/.mvn/wrapper/maven-wrapper.properties
    if [ -f $mavenWrapper ];then
        sed -e 's#https://repo1.maven.org/maven2#http://maven.aliyun.com/nexus/content/groups/public#g' -i $mavenWrapper
    fi

    #　application.properties　-> application.yml
    mv $artifactId/src/main/resources/application.properties $artifactId/src/main/resources/application.yml
}

function batchFileInit(){
    echo '[log]unimplemented'
}

# gradle 阿里云加速
if [ "$TYPE"=="gradle-project" -a ! -f ~/.gradle/init.gradle ];then
    echo "[log]gradle use aliyun"
    cp -rfv $WORK_DIR/.gradle ~/
fi

# example 
#init sco-registry RegistryServer "Eureka server" cloud-eureka-server
if [ $# -gt 0 ]; then
    if [ -f $0 ];then
        batchFileInit $0
    else
        init $*
    fi
else
    echo 'init test Test "Test" cloud-eureka'
fi