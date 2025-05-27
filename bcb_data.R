# carregando as bibliotecas
library(GetBCBData)
library(tidyverse)

# CÓDIGO A SER UTILIZADO: 29037
# Endividamento das famílias com o Sistema Financeiro Nacional 
# em relação à renda acumulada dos últimos doze meses (RNDBF)
my_id_29037 <- c("Endividamento das famílias %" = 29037)

df_bcb_endiv <- gbcbd_get_series(
  id = my_id,
  first.date = "2012-02-01",
  last.date = Sys.Date(),
  format.data = "long",
  use.memoise = TRUE,
  cache.path = tempdir(),
  do.parallel = FALSE
)

# CÓDIGO A SER UTILIZADO: 24381
# Rendimento médio real efetivo de todos os trabalhos - PNADC
my_id_24381 <- c("Rendimento médio real efetivo de todos os trabalhos R$" = 24381)

df_bcb_rend <- gbcbd_get_series(
  id = my_id_24381,
  first.date = "2012-02-01",
  last.date = Sys.Date(),
  format.data = "long",
  use.memoise = TRUE,
  cache.path = tempdir(),
  do.parallel = FALSE
)

# TRATANDO OS DADOS
# 1. retirando a coluna "id.num"
# 2. alterando o nome da coluna "values" para o valor em "series.name"
df_bcb_endiv_alter <- df_bcb_endiv |>
  select(-id.num) |> 
  pivot_wider(
    names_from = series.name,
    values_from = value
  ) 

df_bcb_rend_alter <- df_bcb_rend |>
  select(-id.num) |>
  pivot_wider(
    names_from = series.name,
    values_from = value
  )

# JUNTANDO AS TABELAS df_bcb_endiv_alter E df_bcb_rend_alter (MERGE)
df_bcb <- merge(df_bcb_endiv_alter, df_bcb_rend_alter)

# TRATANDO OS DADOS 2
# criando colunas para analises MoM e YoY
df_bcb <- df_bcb |>
  mutate(
    `MoM Endividamento %`  = round(
      ((`Endividamento das famílias %` - lag(`Endividamento das famílias %`)) / 
         lag(`Endividamento das famílias %`)) * 100, digits = 2),
    `YoY Endividamento %` = round(
      ((`Endividamento das famílias %` - lag(`Endividamento das famílias %`, 12)) / 
         lag(`Endividamento das famílias %`, 12)) * 100, digits = 2),
    `MoM Renda Media %` = round(
      ((`Rendimento médio real efetivo de todos os trabalhos R$`) - lag(`Rendimento médio real efetivo de todos os trabalhos R$`)) /
         lag(`Rendimento médio real efetivo de todos os trabalhos R$`) * 100, digits = 2),
    `YoY Renda Media %` = round(
      ((`Rendimento médio real efetivo de todos os trabalhos R$`) - lag(`Rendimento médio real efetivo de todos os trabalhos R$`, 12)) /
         lag(`Rendimento médio real efetivo de todos os trabalhos R$`, 12) * 100, digits = 2)
    )
