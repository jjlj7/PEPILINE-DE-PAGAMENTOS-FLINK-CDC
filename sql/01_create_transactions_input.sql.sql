DROP TABLE IF EXISTS transactions_input;

CREATE TABLE transactions_input (
    after ROW<
        id STRING,
        customer_id STRING,
        card_id STRING,
        amount DOUBLE,
        `timestamp` BIGINT
    >
) WITH (
    'connector' = 'kafka',
    'topic' = 'v2.public.transactions',
    'properties.bootstrap.servers' = 'broker:29092',
    'properties.group.id' = 'flink-fraud-detector-group',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);