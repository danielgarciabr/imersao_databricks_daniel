-- =====================================================
-- Bronze Layer - Ingestão de Cotações yFinance
-- Pipeline de Segmentação de Clientes - Lakeflow Declarative Pipelines
-- =====================================================

CREATE OR REFRESH STREAMING TABLE bronze.quotation_yfinance
AS
SELECT 
    data_hora,
    moeda,
    preco_abertura,
    preco_fechamento,
    preco_maximo,
    preco_minimo,
    volume,
    current_timestamp() as horario_coleta
FROM cloud_files(
    '/Volumes/lakehouse/raw_public/quotation_yfinance',
    'csv',
    map(
        'header', 'true',
        'inferSchema', 'true'
    )
)
CONSTRAINT data_hora_not_null EXPECT (data_hora IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT moeda_not_null EXPECT (moeda IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT preco_abertura_positive EXPECT (preco_abertura > 0) ON VIOLATION DROP ROW
CONSTRAINT preco_fechamento_positive EXPECT (preco_fechamento > 0) ON VIOLATION DROP ROW
CONSTRAINT preco_maximo_positive EXPECT (preco_maximo > 0) ON VIOLATION DROP ROW
CONSTRAINT preco_minimo_positive EXPECT (preco_minimo > 0) ON VIOLATION DROP ROW
CONSTRAINT volume_positive EXPECT (volume > 0) ON VIOLATION DROP ROW
CONSTRAINT horario_coleta_valid EXPECT (horario_coleta <= current_timestamp()) ON VIOLATION DROP ROW;
