##########################################################################
## indicador 19c: percentual de existência de colegiados extraescolares ##
##########################################################################

library(openxlsx)
library(tidyverse)

# BASE ESTADIC - IBGE:

ESTADIC <- read.xlsx("Base_ESTADIC_2018_20201215.xlsx", 
                     sheet = "Educação")

variaveis_ext <- read.xlsx("/Base_ESTADIC_2018_20201215.xlsx", sheet = "Variáveis externas") %>% 
  select(COD.UF, REGIAO, UF)

MAX_COLEG <- 27*4

passo1 <- ESTADIC %>% 
  select(Cod.Uf, EEDU15, EEDU22, EEDU30, EEDU35) %>% 
  rename(COD.UF=Cod.Uf) %>% 
  left_join(variaveis_ext, by = "COD.UF")

passo2 <- passo1 %>% 
  mutate(TOTAL=rowSums(. == "Sim"))

TOTAL_COLEG <- passo2 %>% 
  summarise(TOTAL=sum(TOTAL))

IND19C_BR <- TOTAL_COLEG/MAX_COLEG*100

# REGIÕES:

passo3 <- passo2 %>% 
  group_by(REGIAO) %>% 
  summarise(TOTAL=sum(TOTAL))

IND19C_REG <- passo3 %>% 
  mutate(MAX_COLEG_REG=ifelse(REGIAO=="Norte", (4*7), (
    ifelse(REGIAO=="Nordeste", (4*9), (
      ifelse(REGIAO=="Sudeste", (4*4), (
        ifelse(REGIAO=="Sul", (4*3), (
          ifelse(REGIAO=="Centro-Oeste", (4*4), 0)))))))))) %>% 
  mutate(IND19C_REG=TOTAL/MAX_COLEG_REG*100)

# ESTADOS:

IND19D_UF <- passo2 %>% 
  group_by(COD.UF) %>% 
  summarise(IND19C_UF=(TOTAL/4*100))
