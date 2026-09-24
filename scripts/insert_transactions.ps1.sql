# Script para injeção de transacoes de teste no Postgres via Docker

Param(
    [string]$Id = "tx_v2_$(Get-Random -Minimum 100 -Maximum 999)",
    [string]$CustomerId = "cust_001",
    [string]$CardId = "card_888",
    [double]$Amount = 1500.00,
    [long]$Timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
)

$query = "INSERT INTO public.transactions (id, customer_id, card_id, amount, timestamp) VALUES ('$Id', '$CustomerId', '$CardId', $Amount, $Timestamp);"

Write-Host "Enviando transacao: $Id para o cliente $CustomerId (Valor: R$ $Amount)..." -ForegroundColor Cyan

docker exec -it postgres psql -U cdc_user -d payments_db -c "$query"