import psycopg

def build_connection_string(host, port, username, password, database):
    return f"dbname=${database} user=${username} password=${password} host=${host} port=${port}"

def run(connection_string, script):
    with psycopg.connect(connection_string) as conn:
        with conn.cursor() as cur:
            cur.execute(script)

def run_batch(connection_string, scripts):
    with psycopg.connect(connection_string, autocommit=True) as conn:
        with conn.cursor() as cur:
            for script in scripts:
                with conn.transaction():
                    cur.execute(script)

def test_sql_connection(connection_string):
    success = False
    with psycopg.connect(connection_string) as conn:
        if not conn.closed:
            success = True
    return success
