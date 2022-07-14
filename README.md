# pee-es
Reprodução da metodologia nacional (INEP/PNE) para cálculo de indicadores 19b, 19c, 19d, 19e, 19f para o acompanhamento das metas do Plano Estadual de Educação do ES.

<h2>Introdução</h2>
As orientações passo a passo para o cálculo dos indicadores de acompanhamento das metas do Plano Nacional de Educação (PNE) são publicadas pelo Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (INEP) à cada <a href="https://www.gov.br/inep/pt-br/areas-de-atuacao/gestao-do-conhecimento-e-estudos-educacionais/estudos-educacionais/relatorios-de-monitoramento-do-pne">ciclo de monitoramento das metas</a>.
O Instituto Jones dos Santos Neves (IJSN/ES) segue as orientações e etapas descritas nos relatórios publicados pelo INEP para o cálculo dos indicadores em nível estadual para realizar o <a href="http://www.ijsn.es.gov.br/artigos/6108-acompanhamento-do-plano-estadual-de-educacao-do-espirito-santo-pee-2021">acompanhamento do Plano Estadual de Educação do estado do Espírito Santo</a>.
Os cálculos dos indicadores 19b, 19c, 19d, 19e e 19f do ES, aqui apresentados, foram desenvolvidos durante a execução do projeto “Estudos Educacionais”, vinculado ao IJSN em parceria com a Secretaria de Estado de Educação do Espírito Santo e financiado pela <a href="https://fapes.es.gov.br/">Fundação de Amparo à Pesquisa e Inovação do Espírito Santo (FAPES)</a>.

<h2>Indicadores Educacionais</h2>

Os scripts compartilhados são de cálculo de indicadores relacionados à meta 19 do PNE, referentes ao 3º ciclo de monitoramento das metas do PNE (2020):

<b>Meta 19</b>: Assegurar condições, no prazo de 2 (dois) anos, para a efetivação da gestão democrática da educação, associada a critérios técnicos de mérito e desempenho e à consulta pública à comunidade escolar, no âmbito das escolas públicas, prevendo recursos e apoio técnico da união para tanto.

<li><b>Indicador 19B:</b> Percentual de existência de colegiados intraescolares (conselho escolar, associação de pais e mestres, grêmio estudantil) nas escolas públicas.</li>

<li><b>Indicador 19C:</b> Percentual de existência de colegiados extraescolares (Conselho Estadual de Educação, Conselhos de Acompanhamento e Controle Social do Fundeb, Conselhos de Alimentação Escolar e Fórum Permanente de Educação) nas unidades federativas.</li>

<li><b>Indicador 19D:</b> Percentual de oferta de infraestrutura e capacitação aos membros dos Conselhos Estaduais de Educação, Conselhos de Acompanhamento e Controle Social do Fundeb e Conselhos de Alimentação Escolar pelas unidades federativas.</li>

<li><b>Indicador 19E:</b> Percentual de existência de colegiados extraescolares (Conselho Municipal de Educação, Conselhos de Acompanhamento e Controle Social do Fundeb, Conselhos de Alimentação Escolar e Fórum Permanente de Educação) nos municípios.</li>

<li><b>Indicador 19F:</b> Percentual de oferta de infraestrutura e capacitação aos membros de Conselho Municipal de Educação, Conselhos de Acompanhamento e Controle Social do Fundeb e Conselhos de Alimentação Escolar nos municípios.</li>

<h2>Fontes de Dados</h2>

<li><a href="https://www.ibge.gov.br/estatisticas/sociais/saude/16770-pesquisa-de-informacoes-basicas-estaduais.html?=&t=destaques">Pesquisa de Informações Básicas Estaduais (2018) - IBGE</a></li>

<li><a href="https://www.ibge.gov.br/estatisticas/sociais/educacao/10586-pesquisa-de-informacoes-basicas-municipais.html?=&t=destaques">Pesquisa de Informações Básicas Municipais (2018) - IBGE</a></li>

<li><a href="https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados">Censo Escolar (2020) - INEP</a></li>

<h2>Observações</h2>
Para a manipulação dos dados foi usado o pacote <i>dplyr</i> do <i>tidyverse</i>.

