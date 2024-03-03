import snowflake.connector
import toml

class SnowflakeManager:
    def __init__(self, config_file='secrets.toml'):
        self.config = self.load_credentials(config_file)
        self.conn = self.establish_connection()

    def load_credentials(self, file_path):
        with open(file_path, 'r') as file:
            return toml.load(file)['snowflake']

    def establish_connection(self):
        return snowflake.connector.connect(
            account=self.config['account'],
            user=self.config['user'],
            password=self.config['password'],
            warehouse=self.config['warehouse'],
            database=self.config['database'],
            schema=self.config['schema']
        )

    def connect_to_snowflake(self, params):
        return snowflake.connector.connect(**params)

    def close_connection(self, cursor):
        cursor.close()
        self.conn.close()

class SnowflakeDataLoader:
    def __init__(self, cursor):
        self.cursor = cursor

    def create_snowflake_stage(self, stage_name):
        self.cursor.execute('USE ROLE ACCOUNTADMIN')
        self.cursor.execute(f'CREATE OR REPLACE STAGE {stage_name}')

    def put_csv_file_to_stage(self, csv_file_path, stage_name):
        self.cursor.execute(f"PUT file://{csv_file_path} @{stage_name}")

    def create_table_if_not_exists(self, table_name):
        create_table_query = f'''
            CREATE TABLE IF NOT EXISTS {database}.{schema}.{table_name} (
                factory_id INT,
                location_id INT,
                size VARCHAR,
                number_of_employees INT,
                in_use BOOLEAN
            )
        '''
        self.cursor.execute(create_table_query)

    def copy_data_to_table(self, table_name, stage_name):
        copy_command = f'COPY INTO {database}.{schema}.{table_name} FROM @{stage_name}/factories.csv FILE_FORMAT=(TYPE=CSV FIELD_OPTIONALLY_ENCLOSED_BY=\'"\' SKIP_HEADER=1)'
        self.cursor.execute(copy_command)

    def verify_data_loaded(self, table_name):
        self.cursor.execute(f'SELECT * FROM {database}.{schema}.{table_name}')
        one_row = self.cursor.fetchone()
        print(one_row)

    def drop_snowflake_stage(self, stage_name):
        self.cursor.execute(f'DROP STAGE IF EXISTS {stage_name}')

if __name__ == "__main__":
    # Snowflake stage information
    stage_name = 'MY_LOCAL_STAGE'

    # CSV file information
    csv_file_path = 'C:\\Users\\luism\\Desktop\\data\\github_repos\\sliide\\data\\pipeline_data\\factories.csv'
    table_name = 'FACTORIES'

    # Initialize SnowflakeManager and SnowflakeDataLoader
    snowflake_manager = SnowflakeManager()
    cursor = snowflake_manager.conn.cursor()
    data_loader = SnowflakeDataLoader(cursor)

    try:
        data_loader.create_snowflake_stage(stage_name)
        data_loader.create_table_if_not_exists(table_name)
        data_loader.put_csv_file_to_stage(csv_file_path, stage_name)
        data_loader.copy_data_to_table(table_name, stage_name)
        data_loader.verify_data_loaded(table_name)
    finally:
        # Uncomment the line below to drop the stage
        # data_loader.drop_snowflake_stage(stage_name)

        # Close cursor and connection
        snowflake_manager.close_connection(cursor)
