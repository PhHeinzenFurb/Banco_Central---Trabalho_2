# chamando as biliotecas
library(GetBCBData)
library(tidyverse)

# FUNÇÃO PARA EXTRAIR OS DADOS DO BCB VIA BIBLIOTECA GetBCBData
get_bcb_data <- function(id, first_date){
  gbcbd_get_series(
    id = id,
    first.date = first_date,
    last.date = Sys.Date(),
    format.data = "long",
    use.memoise = TRUE,
    cache.path = tempdir(),
    do.parallel = FALSE
  )
}

# FUNÇÃO PARA TRATAMENTO PADRÃO DOS DADOS GERADOS POR get_bcb_data
df_bcb_format <- function(df){
  df |>
    select(-id.num) |>
    pivot_wider(
      names_from = series.name,
      values_from = value
    )
}

# CÓDIGO A SER UTILIZADO: 29037
# Endividamento das famílias com o Sistema Financeiro Nacional 
# em relação à renda acumulada dos últimos doze meses (RNDBF)

my_id_29037 <- c("Endividamento das famílias %" = 29037)

df_endiv <- get_bcb_data(my_id_29037, "2012-02-01")
df_endiv_format <- df_bcb_format(df_endiv)

# CÓDIGO A SER UTILIZADO: 4393
# Índice de Confiança do Consumidor

my_id_4393 <- c("Índice de Confiança do Consumidor" = 4393)

df_indice <- get_bcb_data(my_id_4393, "2012-02-01")
df_indice_format <- df_bcb_format(df_indice)

# CÓDIGO A SER UTILIZADO: 27735
# Saldo das operações de crédito por atividade econômica 
# - Geral - veículos automotores

my_id_27735 <- c("Operações de Crédito - Veículos (R$ milhões)" = 27735)

df_cred_veic <- get_bcb_data(my_id_27735, "2012-02-01")
df_cred_veic_format <- df_bcb_format(df_cred_veic)

# CÓDIGO A SER UTILIZADO: 20612
# Saldo da carteira de crédito com recursos direcionados 
# - Pessoas físicas - Financiamento imobiliário total

my_id_20612 <- c("Operações de Crédito - Imobiliário (R$ milhões)" = 20612)

df_cred_imob <- get_bcb_data(my_id_20612, "2012-02-01")
df_cred_imob_format <- df_bcb_format(df_cred_imob)

# CÓDIGO A SER UTILIZADO: 20606
# Saldo da carteira de crédito com recursos direcionados 
# - Pessoas físicas - Total

my_id_20606<- c("Operações de Crédito - Total (R$ milhões)" = 20606)

df_cred_total <- get_bcb_data(my_id_20606, "2012-02-01")
df_cred_total_format <- df_bcb_format(df_cred_total)



