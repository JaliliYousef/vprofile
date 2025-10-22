FROM tomcat:9-jdk8
LABEL maintainer="jalili_yousef@yahoo.com"

COPY target/vprofile-v2.war /usr/local/tomcat/webapps/vprofile.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
