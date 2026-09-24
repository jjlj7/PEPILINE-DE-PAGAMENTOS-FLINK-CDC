-- Criar banco de dados e usuario do CDC se nao existirem
CREATE DATABASE payments_db;
CREATE USER cdc_user WITH REPLICATION PASSWORD 'cdc_password';

\c payments_db;

-- Criar tabela de transacoes
CREATE TABLE IF NOT EXISTS public.transactions (
    id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    card_id VARCHAR(50) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    timestamp BIGINT NOT NULL
);

-- Permissoes para o CDC
GRANT ALL PRIVILEGES ON DATABASE payments_db TO cdc_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cdc_user;
ALTER TABLE public.transactions REPLICA IDENTITY FULL;