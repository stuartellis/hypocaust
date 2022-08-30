import os

import aws_secrets
import pg_utils


def lambda_handler(event, context):
    print('Hello world!')
    aws_region = os.environ["AWS_REGION"]
    print(aws_region)
    db_credentials = aws_secrets.get(aws_region, os.environ["SECRETS_RDS_CREDENTIALS_NAME"])
    db_host = os.environ["RDS_WRITE_ENDPOINT"]
    print(db_host)
    port = os.environ["RDS_PORT"]
    username = db_credentials["username"]
    password = db_credentials["password"]
    database = os.environ["RDS_DATABASE"]
    print(database)
    conn_string = pg_utils.build_connection_string(db_host, port, username, password, database)
    result = pg_utils.test_sql_connection(conn_string)
    print(result)
