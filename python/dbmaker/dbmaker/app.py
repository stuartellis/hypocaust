import os

import aws_secrets
import pg_utils


def lambda_handler(event, context):
    print('Hello world!')
    aws_region = os.environ["AWS_REGION"]
    print(aws_region)
    db_host = os.environ["RDS_WRITE_ENDPOINT"]
    print(db_host)
    port = os.environ["RDS_PORT"]
    database = os.environ["RDS_DATABASE_NAME"]
    print(database)
    print(f"Fetching secret: {os.environ['SECRETS_RDS_CREDENTIALS_NAME']}")
    db_credentials = aws_secrets.get(aws_region, os.environ["SECRETS_RDS_CREDENTIALS_NAME"])
    username = db_credentials["username"]
    print(username)
    password = db_credentials["password"]
    conn_string = pg_utils.build_connection_string(db_host, port, username, password, database)
    result = pg_utils.test_sql_connection(conn_string)
    print(result)
