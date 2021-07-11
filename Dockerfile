from openkbs/jre-mvn-py3
RUN python --version && python3 --version
RUN java --version
# assuming /home/developer is working dir

RUN echo $JAVA_HOME


## preprare spark
RUN curl -o spark-3.1.2-bin-hadoop3.2.tgz https://mirrors.estointernet.in/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
RUN tar -xzf spark-3.1.2-bin-hadoop3.2.tgz
RUN mv spark-3.1.2-bin-hadoop3.2 spark
RUN curl -o spark/jars/spark-avro_2.12-3.1.2.jar https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.1.2/spark-avro_2.12-3.1.2.jar
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENV SPARK_HOME /home/developer/spark
RUN export SPARK_HOME
ENV PATH "$PATH:$SPARK_HOME/bin"

ENV LOCAL_EXES /home/developer/.local/bin
RUN export LOCAL_EXES
ENV PATH "$PATH:$LOCAL_EXES"

#install requirements
COPY requirements.txt ./
RUN pip3 install -r requirements.txt

## start master


COPY . .
#CMD /home/developer/spark/sbin/start-master.sh --port 6066 --webui-port 9090
EXPOSE 8000 6066 9090
ENTRYPOINT ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]
