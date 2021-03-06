FROM centos:7.5.1804      
MAINTAINER yuhuashi
ENV REFRESHED_AT 2020-12-05

#切换镜像目录，进入/usr目录
WORKDIR /usr
#在/usr/下创建jdk目录,用来存放jdk文件
RUN mkdir jdk && mkdir tomcat

#将宿主机的jdk目录下的文件拷至镜像的/usr/jdk目录下
ADD jdk1.8.0_131  /usr/jdk/
#将k主机的tomcat目录下的文件拷至镜像的/usr/tomcat目录下
ADD tomcat /usr/tomcat/

COPY target/demo.war /tmp/ROOT.war

RUN yum -y install zip unzip rm &&  rm -rf /usr/tomcat/webapps/* &&  unzip /tmp/ROOT.war -d /usr/tomcat/webapps/ROOT && rm -f /tmp/ROOT.war

#设置环境变量
ENV JAVA_HOME=/usr/jdk
ENV CLASSPATH=.:/usr/jdk/lib/dt.jar:/usr/jdk/lib/tools.jar:/usr/jdk/jre/lib:
ENV PATH=/sbin:/usr/jdk/bin:/usr/jdk/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/git/bin:/root/bin

WORKDIR /usr/tomcat

EXPOSE 8057
ENTRYPOINT ["./bin/catalina.sh","run"]
