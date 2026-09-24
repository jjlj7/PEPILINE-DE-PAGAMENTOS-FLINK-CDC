SELECT 
    after.customer_id AS customer_id, 
    COUNT(after.id) AS total_transacoes, 
    SUM(after.amount) AS valor_total 
FROM transactions_input 
WHERE after IS NOT NULL
GROUP BY after.customer_id;