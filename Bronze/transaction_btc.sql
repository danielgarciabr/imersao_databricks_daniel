-- =====================================================
-- Bronze Layer - Ingestão de Transações Bitcoin
-- Pipeline de Segmentação de Clientes - Lakeflow Declarative Pipelines
-- =====================================================

CREATE OR REFRESH STREAMING TABLE bronze.transaction_btc
AS
SELECT 
    transaction_id,
    customer_id,
    data_hora,
    tipo_operacao,
    quantidade,
    preco,
    moeda,
    current_timestamp() as horario_coleta
FROM cloud_files(
    '/Volumes/lakehouse/raw_public/transacation_btc',
    'csv',
    map(
        'header', 'true',
        'inferSchema', 'true'
    )
)
CONSTRAINT transaction_id_not_null EXPECT (transaction_id IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT customer_id_not_null EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT data_hora_not_null EXPECT (data_hora IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT tipo_operacao_valid EXPECT (tipo_operacao IN ('COMPRA', 'VENDA')) ON VIOLATION DROP ROW
CONSTRAINT quantidade_positive EXPECT (quantidade > 0) ON VIOLATION DROP ROW
CONSTRAINT preco_positive EXPECT (preco > 0) ON VIOLATION DROP ROW
CONSTRAINT moeda_not_null EXPECT (moeda IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT horario_coleta_valid EXPECT (horario_coleta <= current_timestamp()) ON VIOLATION DROP ROW;
