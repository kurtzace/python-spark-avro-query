from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from pyspark import SparkConf
from pyspark import SparkContext
from pyspark import SQLContext
from pydantic import BaseModel
import subprocess
import os
from pyspark.sql.functions import col

subprocess.run(["/home/developer/spark/sbin/start-master.sh", "--host", "localhost", "--port", "6066", "--webui-port", "9090"])
subprocess.run(["/home/developer/spark/sbin/start-slave.sh", "--host", "localhost","spark://localhost:6066", "--port", "10001", "--webui-port", "9091"])
conf = SparkConf()
conf.setMaster('spark://localhost:6066')
conf.setAppName('spark-avro')
sc = SparkContext(conf=conf)
sqlcontext = SQLContext(sc)
df = sqlcontext.read.format("com.databricks.spark.avro").load("userdata1.avro")


class Item(BaseModel):
    first_name: str

app = FastAPI(
    title="Python spark query",
    version=1.0,
    description="",
)

@app.get("/", include_in_schema=False)
async def redirect():
    return RedirectResponse("/docs")

@app.get(
    "/columns"
)
async def getColumns():
    return df.columns

@app.get(
    "/top5"
)
async def top5():
    return df.head(5)


@app.post(
    "/postQuery"
)
async def postQuery(body: Item):
    request = body.dict()
    return df.filter(col("first_name").contains(request['first_name'])).head(5)