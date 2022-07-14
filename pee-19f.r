##########################################################################################################
## Indicador 19f: Percentual de oferta de infra e capacitação aos membros de conselhos pelos municípios ##
##########################################################################################################

library(openxlsx)
library(tidyverse)

MUNIC2018 <- read.xlsx("Base_MUNIC_2018.xlsx", sheet = "Educação")
VARIAVEIS_EXT <- read.xlsx("Base_MUNIC_2018.xlsx", sheet = "Variáveis externas")

MAX_INFRA <- n_distinct(MUNIC2018)*6

passo1 <- MUNIC2018 %>% 
  select(Cod.Municipio, MEDU27, MEDU34, MEDU40, MEDU261, MEDU262, MEDU331, MEDU332, MEDU391, MEDU392)

passo2 <- passo1 %>% 
  mutate(MEDU261_262=ifelse(MEDU261=="Sim"|MEDU262=="Sim","Sim","0"), 
         MEDU331_332=ifelse(MEDU331=="Sim"|MEDU332=="Sim", "Sim", "0"),
         MEDU391_392=ifelse(MEDU391=="Sim"|MEDU392=="Sim", "Sim", "0")) %>% 
  select(Cod.Municipio, MEDU27, MEDU34, MEDU40, MEDU261_262, MEDU331_332, MEDU391_392)

passo3 <- passo2 %>% 
  mutate(TOTAL=rowSums(. == "Sim"))

TOTAL_INFRA <- passo3 %>% 
  summarise(TOTAL=sum(TOTAL))

IND19F_BR <- TOTAL_INFRA/MAX_INFRA*100

# REGIÕES:

passo4 <- VARIAVEIS_EXT %>% 
  select(Cod.Municipio, UF, COD.UF, REGIAO, NOME.MUNIC) %>%
  left_join(passo1, by = "Cod.Municipio") %>% 
  mutate(TOTAL=rowSums(. == "Sim")) 

IND19F_REG <- passo4 %>%
  group_by(REGIAO) %>% 
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_INFRA=(n*6)) %>% 
  group_by(REGIAO) %>% 
  summarise(IND19F_REG=TOTAL/MAX_INFRA*100)

# UF:

IND19F_UF <- passo4 %>% 
  group_by(COD.UF, UF) %>% 
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_INFRA=(n*6)) %>% 
  group_by(COD.UF, UF) %>% 
  summarise(IND19F_UF=TOTAL/MAX_INFRA*100)

# ES:

IND19F_ES <- IND19F_UF %>% 
  filter(COD.UF==32)

# MUNICÍPIOS DO ES:

IND19F_MUNES <- passo4 %>% 
  filter(COD.UF==32) %>% 
  group_by(Cod.Municipio, NOME.MUNIC) %>%
  summarise(TOTAL=sum(TOTAL), n=n()) %>% 
  mutate(MAX_INFRA=(n*6)) %>%  
  group_by(Cod.Municipio, NOME.MUNIC) %>% 
  summarise(IND19F_MUNES=TOTAL/MAX_INFRA*100)
