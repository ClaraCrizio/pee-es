###########################################################################
## Indicador 19e: Percentual de colegiados extraescolares nos municípios ##
###########################################################################

library(openxlsx)
library(tidyverse)

MUNIC2018 <-  read.xlsx("Base_MUNIC_2018.xlsx", sheet = "Educação")
VARIAVEIS_EXT <- read.xlsx("Base_MUNIC_2018.xlsx", sheet = "Variáveis externas")

MAX_COLEG <- n_distinct(MUNIC2018)*4

# Número de municípios nos procedimentos do INEP é diferente = 5570 (número de municípios atualizado)

passo1 <- MUNIC2018 %>% 
  select(Cod.Municipio, MEDU15, MEDU22, MEDU30, MEDU35)

passo2 <- passo1 %>% 
  mutate(TOTAL=rowSums(. == "Sim"))

TOTAL_COLEG <- passo2 %>% 
  summarise(TOTAL=sum(TOTAL))

IND19E_BR <- TOTAL_COLEG/MAX_COLEG*100

# REGIÕES:

passo3 <- VARIAVEIS_EXT %>% 
  select(Cod.Municipio, UF, COD.UF, REGIAO, NOME.MUNIC) %>%
  left_join(passo1, by = "Cod.Municipio") %>% 
  mutate(TOTAL=rowSums(. == "Sim")) 
  
IND19E_REG <- passo3 %>%
  group_by(REGIAO) %>% 
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_COLEG=(n*4)) %>% 
  group_by(REGIAO) %>% 
  summarise(IND19E_REG=TOTAL/MAX_COLEG*100)
  
# MUNICÍPIOS DO BR:

IND19E_MUN <- passo3 %>% 
  group_by(Cod.Municipio, NOME.MUNIC) %>%
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_COLEG=(n*4)) %>% 
  group_by(Cod.Municipio, NOME.MUNIC) %>% 
  summarise(IND19E_MUN=TOTAL/MAX_COLEG*100)

# UF:

IND19E_UF <- passo3 %>% 
  group_by(COD.UF, UF) %>% 
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_COLEG=(n*4)) %>% 
  group_by(COD.UF, UF) %>% 
  summarise(IND19E_UF=TOTAL/MAX_COLEG*100)

# ES:

IND19E_ES <- IND19E_UF %>% 
  filter(COD.UF==32)

# MUNICÍPIOS DO ES:

IND19E_MUNES <- passo3 %>% 
  filter(COD.UF==32) %>% 
  group_by(Cod.Municipio, NOME.MUNIC) %>%
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_COLEG=(n*4)) %>% 
  group_by(Cod.Municipio, NOME.MUNIC) %>% 
  summarise(IND19E_MUNES=TOTAL/MAX_COLEG*100)

