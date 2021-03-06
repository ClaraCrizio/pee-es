################################################################################
# indicador 19b: percentual de colegiados intraescolares nas escolas públicas ##
################################################################################

library(openxlsx)
library(tidyverse)

# INDICADOR 19B NACIONAL:
# Obs.: indicador só coincide com relatório INEP quando inserido filtro para respondentes

escolas <- read.csv("/microdados_educacao_basica_2020/DADOS/escolas.csv", sep = "|")

passo1_BR <- escolas %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1, 
         TP_DEPENDENCIA==1|TP_DEPENDENCIA==2|TP_DEPENDENCIA==3) %>% 
  filter(IN_ORGAO_CONSELHO_ESCOLAR==1|IN_ORGAO_CONSELHO_ESCOLAR==0|
           IN_ORGAO_GREMIO_ESTUDANTIL==1|IN_ORGAO_GREMIO_ESTUDANTIL==0|
           IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS==0|
           IN_ORGAO_ASS_PAIS_MESTRES==1|IN_ORGAO_ASS_PAIS_MESTRES==0)

passo2_BR <- passo1_BR %>% 
  mutate(IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES=ifelse(IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS_MESTRES==1,1,0))

passo3_BR <- passo2_BR %>% 
  select(TP_DEPENDENCIA, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  mutate(QTD_ASSOC_ESCOLA=IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES + IN_ORGAO_CONSELHO_ESCOLAR + IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(TP_DEPENDENCIA) %>% 
  summarise(QTD_ASSOC_ESCOLA=sum(QTD_ASSOC_ESCOLA))

passo4_BR <- passo2_BR %>% 
  select(TP_DEPENDENCIA, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(TP_DEPENDENCIA) %>% 
  summarise(MAX_ASSOC=(n())*3)

IND19b_BR_DP <- passo3_BR %>% 
  left_join(passo4_BR, by="TP_DEPENDENCIA") %>% 
  group_by(TP_DEPENDENCIA) %>% 
  summarise(ind19b_BR=QTD_ASSOC_ESCOLA/MAX_ASSOC*100)

IND19b_BR<- passo3_BR %>% 
  left_join(passo4_BR, by="TP_DEPENDENCIA") %>% 
  summarise(ind19b_BR=sum(QTD_ASSOC_ESCOLA)/sum(MAX_ASSOC)*100)

# INDICADOR 19B PARA REGIÕES:

passo1_REG <- escolas %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1, 
         TP_DEPENDENCIA==1|TP_DEPENDENCIA==2|TP_DEPENDENCIA==3) %>% 
  filter(IN_ORGAO_CONSELHO_ESCOLAR==1|IN_ORGAO_CONSELHO_ESCOLAR==0|
           IN_ORGAO_GREMIO_ESTUDANTIL==1|IN_ORGAO_GREMIO_ESTUDANTIL==0|
           IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS==0|
           IN_ORGAO_ASS_PAIS_MESTRES==1|IN_ORGAO_ASS_PAIS_MESTRES==0)

passo2_REG <- passo1_REG %>% 
  mutate(IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES=ifelse(IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS_MESTRES==1,1,0))

# REGIÕES - TOTAL:

passo3_REG <- passo2_REG %>% 
  select(CO_REGIAO, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  mutate(QTD_ASSOC_ESCOLA=IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES+IN_ORGAO_CONSELHO_ESCOLAR+IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(CO_REGIAO) %>% 
  summarise(QTD_ASSOC_ESCOLA=sum(QTD_ASSOC_ESCOLA))

passo4_REG <- passo2_REG %>% 
  select(CO_REGIAO, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  group_by(CO_REGIAO) %>% 
  summarise(MAX_ASSOC=(n())*3)

IND19b_REG <- passo3_REG %>% 
  left_join(passo4_REG, by="CO_REGIAO") %>% 
  group_by(CO_REGIAO) %>% 
  summarise(ind19b_REG=QTD_ASSOC_ESCOLA/MAX_ASSOC*100) %>% 
  mutate(REGIAO = case_when(
    CO_REGIAO == 1 ~ "NORTE",
    CO_REGIAO == 2 ~ "NORDESTE",
    CO_REGIAO == 3 ~ "SUDESTE",
    CO_REGIAO == 4 ~ "SUL",
    CO_REGIAO == 5 ~ "CENTROESTE"))

#REGIÕES - POR DEPENDÊNCIA ADMINISTRATIVA:

passo3_REG_DP <- passo2_REG %>% 
  select(TP_DEPENDENCIA, CO_REGIAO, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  mutate(QTD_ASSOC_ESCOLA=IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES+IN_ORGAO_CONSELHO_ESCOLAR+IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(TP_DEPENDENCIA, CO_REGIAO) %>% 
  summarise(QTD_ASSOC_ESCOLA=sum(QTD_ASSOC_ESCOLA))

passo4_REG_DP <- passo2_REG %>% 
  select(TP_DEPENDENCIA, CO_REGIAO, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  group_by(TP_DEPENDENCIA, CO_REGIAO) %>% 
  summarise(MAX_ASSOC=(n())*3)

IND19b_REG_DP <- passo3_REG_DP %>% 
  left_join(passo4_REG_DP, by=c("CO_REGIAO", "TP_DEPENDENCIA")) %>% 
  group_by(CO_REGIAO,TP_DEPENDENCIA) %>% 
  summarise(ind19b_REG=QTD_ASSOC_ESCOLA/MAX_ASSOC*100) %>% 
  mutate(REGIAO = case_when(
    CO_REGIAO == 1 ~ "NORTE",
    CO_REGIAO == 2 ~ "NORDESTE",
    CO_REGIAO == 3 ~ "SUDESTE",
    CO_REGIAO == 4 ~ "SUL",
    CO_REGIAO == 5 ~ "CENTROESTE")) %>% 
  select(CO_REGIAO,REGIAO,TP_DEPENDENCIA,ind19b_REG) %>% 
  group_by(CO_REGIAO, TP_DEPENDENCIA) %>% 
  pivot_wider(names_from = TP_DEPENDENCIA, values_from = ind19b_REG)

# DESAGREGAÇÃO POR UF:

estados <- read.xlsx("/codigo_ibge_estados.xlsx") %>% 
  mutate(codigo=as.numeric(codigo))

passo1_UF <- escolas %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1, 
         TP_DEPENDENCIA==1|TP_DEPENDENCIA==2|TP_DEPENDENCIA==3) %>% 
  filter(IN_ORGAO_CONSELHO_ESCOLAR==1|IN_ORGAO_CONSELHO_ESCOLAR==0|
           IN_ORGAO_GREMIO_ESTUDANTIL==1|IN_ORGAO_GREMIO_ESTUDANTIL==0|
           IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS==0|
           IN_ORGAO_ASS_PAIS_MESTRES==1|IN_ORGAO_ASS_PAIS_MESTRES==0)

passo2_UF <- passo1_UF %>% 
  mutate(IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES=ifelse(IN_ORGAO_ASS_PAIS==1|IN_ORGAO_ASS_PAIS_MESTRES==1,1,0))

# UF - TOTAL:

passo3_UF <- passo2_UF %>% 
  select(CO_UF, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  mutate(QTD_ASSOC_ESCOLA=IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES+IN_ORGAO_CONSELHO_ESCOLAR+IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(CO_UF) %>% 
  summarise(QTD_ASSOC_ESCOLA=sum(QTD_ASSOC_ESCOLA))

passo4_UF <- passo2_UF %>% 
  select(CO_UF, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  group_by(CO_UF) %>% 
  summarise(MAX_ASSOC=(n())*3)

IND19b_UF <- passo3_UF %>% 
  left_join(estados, by=c("CO_UF"="codigo")) %>% 
  left_join(passo4_UF, by=c("CO_UF")) %>% 
  group_by(CO_UF, estado) %>% 
  summarise(ind19b_UF=QTD_ASSOC_ESCOLA/MAX_ASSOC*100)

write.xlsx(IND19b_UF, "ind19b_uf_2020.xlsx")

# UF: ES:

IND19b_UF_ES <- IND19b_UF %>% 
  filter(estado=="Espírito Santo")

# UF - POR DEPENDÊNCIA ADMINISTRATIVA:

passo3_UF_DP <- passo2_UF %>% 
  select(TP_DEPENDENCIA, CO_UF, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  mutate(QTD_ASSOC_ESCOLA=IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES+IN_ORGAO_CONSELHO_ESCOLAR+IN_ORGAO_GREMIO_ESTUDANTIL) %>% 
  group_by(TP_DEPENDENCIA, CO_UF) %>% 
  summarise(QTD_ASSOC_ESCOLA=sum(QTD_ASSOC_ESCOLA))

passo4_UF_DP <- passo2_UF %>% 
  select(TP_DEPENDENCIA, CO_UF, IN_ORGAO_ASS_PAIS_OU_PAIS_MESTRES, IN_ORGAO_CONSELHO_ESCOLAR, IN_ORGAO_GREMIO_ESTUDANTIL) %>%
  group_by(TP_DEPENDENCIA, CO_UF) %>% 
  summarise(MAX_ASSOC=(n())*3)

IND19b_UF_DP <- passo3_UF_DP %>% 
  left_join(estados, by=c("CO_UF"="codigo")) %>% 
  left_join(passo4_UF_DP, by=c("CO_UF", "TP_DEPENDENCIA")) %>% 
  mutate(ind19b_UF_DP=(QTD_ASSOC_ESCOLA/MAX_ASSOC)*100) %>% 
  select(CO_UF, estado, TP_DEPENDENCIA, ind19b_UF_DP) %>% 
  group_by(CO_UF, TP_DEPENDENCIA) %>% 
  pivot_wider(names_from = TP_DEPENDENCIA, values_from = ind19b_UF_DP)

# UF: ES - POR DEPENDÊNCIA ADMINISTRATIVA:

IND19b_UF_DP_ES <- IND19b_UF_DP %>% 
  filter(estado=="Espírito Santo")

