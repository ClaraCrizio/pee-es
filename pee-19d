#################################################################################################
## indicador 19d: percentual de oferta de infrestrutura e capacitação aos membros de conselhos ##
#################################################################################################

library(openxlsx)
library(tidyverse)

ESTADIC <- read.xlsx("/Base_ESTADIC_2018_20201215.xlsx", sheet = "Educação")

variaveis_ext <- read.xlsx("/Base_ESTADIC_2018_20201215.xlsx", sheet = "Variáveis externas")

MAX_OFERTA <- 27*6

passo1 <- ESTADIC %>% 
  select(Cod.Uf, EEDU27, EEDU34, EEDU40, EEDU261, EEDU262, EEDU331, EEDU332, EEDU391, EEDU392) %>% 
  rename(COD.UF=Cod.Uf) %>% 
  left_join(variaveis_ext, by = "COD.UF")

passo2 <- passo1 %>% 
  mutate(EEDU261_262=ifelse(EEDU261=="Sim"|EEDU262=="Sim","Sim","0"), 
         EEDU331_332=ifelse(EEDU331=="Sim"|EEDU332=="Sim", "Sim", "0"),
         EEDU391_392=ifelse(EEDU391=="Sim"|EEDU392=="Sim", "Sim", "0")) %>% 
  select(COD.UF, UF, REGIAO, EEDU27, EEDU34, EEDU40, EEDU261_262, EEDU331_332, EEDU391_392)
  
passo3 <- passo2 %>% 
  mutate(TOTAL=rowSums(. == "Sim"))
  
TOTAL_OFERTA <- passo3 %>% 
  summarise(TOTAL=sum(TOTAL))

IND19D_BR <- TOTAL_OFERTA/MAX_OFERTA*100

# REGIÕES:

passo4 <- passo3 %>% 
  group_by(REGIAO) %>% 
  summarise(TOTAL=sum(TOTAL))

IND19D_REG <- passo4 %>% 
  mutate(MAX_OFERTA_REG=ifelse(REGIAO=="Norte", (6*7), (
    ifelse(REGIAO=="Nordeste", (6*9), (
      ifelse(REGIAO=="Sudeste", (6*4), (
        ifelse(REGIAO=="Sul", (6*3), (
          ifelse(REGIAO=="Centro-Oeste", (6*4), 0)))))))))) %>% 
  group_by(REGIAO) %>% 
  summarise(IND19D_REG=TOTAL/MAX_OFERTA_REG*100)

# ESTADOS:

IND19D_UF <- passo3 %>% 
  group_by(COD.UF, UF) %>% 
  summarise(IND19D_UF=(TOTAL/6*100))

write.xlsx(IND19D_UF, "IND19D_UF_2018.xlsx")
