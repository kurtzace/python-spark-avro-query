## Goal

- Read sample AVRO file using Apache spark
- Query AVRO as an API using Fast API and pyspark
- Spin up master slave within the same node
- No complex setup - just plain old docker

Why?
Spark has easy-to-use APIs for operating on large datasets
and We can add numerous nodes from diffirent machines as slaves to process larger datasets

Plus processing AVRO using spark requires just a few lines of code

## running API
```
sudo docker build -t spark-avro .
sudo docker run -p 8000:8000 spark-avro

```
Visit 

http://localhost:8000

## test api
To give you column list
```
curl -X 'GET' 'http://localhost:8000/columns' -H 'accept: application/json'
```

to search by first name

```
curl -X 'POST' \
  'http://localhost:8000/postQuery' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "first_name": "Amanda"
}'
```

## running pyspark in cmd

sudo docker exec -it <containerID> sh

then from inside container
```
pyspark --jars spark/jars/spark-avro_2.12-3.1.2.jar
>>> df = spark.read.format("com.databricks.spark.avro").load("userdata1.avro")
>>> df.columns

```

## ref
- [userdata1.avro](https://github.com/Teradata/kylo/blob/master/samples/sample-data/avro/userdata1.avro)
- Plusralsight course on spark
