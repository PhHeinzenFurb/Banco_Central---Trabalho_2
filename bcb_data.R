# carregando as bibliotecas
library(GetBCBData)
library(tidyverse)

# código a ser utilizado para a análise: 29037
# Endividamento das famílias com o Sistema Financeiro Nacional 
# em relação à renda acumulada dos últimos doze meses (RNDBF)
my_id <- c("Endividamento das famílias %" = 29037)

df_bcb <- gbcbd_get_series(
  id = my_id,
  first.date = "2005-01-01",
  last.date = Sys.Date(),
  format.data = "long",
  use.memoise = TRUE,
  cache.path = tempdir(),
  do.parallel = FALSE
)

# tratando os dados
df_bcb_alter <- df_bcb |>
  select(-id.num) |>
  pivot_wider(
    names_from = series.name,
    values_from = value
  ) |>
  mutate(
    `MoM Endividamento %`  = round(
      ((`Endividamento das famílias %` - lag(`Endividamento das famílias %`)) / 
      lag(`Endividamento das famílias %`)) * 100, digits = 2),
    `YoY Endividamento %` = round(
      ((`Endividamento das famílias %` - lag(`Endividamento das famílias %`, 12)) / 
      lag(`Endividamento das famílias %`, 12)) * 100, digits = 2)
  )
