Entrega 2 — Modelo Lógico, Implementação SQL e Apresentação Final
Modelagem de um sistema de gestão de informações para uma organização de pequeno porte
Este arquivo é o esqueleto dos artefatos finais do grupo, a serem organizados no repositório GitHub. Será corrigido exclusivamente o conteúdo da branch main do repositório — arquivos que estiverem em qualquer outra branch não serão considerados, mesmo que o link enviado aponte para ela. Preencha cada seção com o conteúdo do seu projeto. Alguns itens são documentos Markdown, outros são arquivos separados (diagramas, dicionário de dados, script .sql, massa de dados, slides) — está indicado em cada seção. Nesta etapa vocês atuam como uma software house implementando o banco de dados completo do sistema modelado na Entrega 1 e revisado na seção 1.1 — seja para uma empresa, uma ONG ou outra organização escolhida pelo grupo.
Lembrete: termos como "empresa" e "negócio" usados abaixo são o vocabulário técnico padrão de modelagem de dados e se aplicam a qualquer tipo de organização, com ou sem fins lucrativos.
Importante: esta etapa exige uma organização real, com evidências de existência e contato com um responsável.
•	Se a organização da Entrega 1 era real, continue com ela — não é permitido trocá-la por outra.
•	Se a organização da Entrega 1 era fictícia (ou não teve a existência comprovada na correção), o grupo deve procurar agora uma organização real e refazer, para ela, toda a base da Entrega 1, inclusive o DER (ver seção 1.1, Caso B).
Em qualquer caso, o grupo deve manter o acesso à organização, pois pode ser necessário voltar a campo para validar regras, tirar dúvidas sobre o processo de normalização ou conferir se a massa de dados reflete a realidade observada.
________________________________________
1. Relatório Técnico Final
(arquivo Markdown — reúne a maior parte da Dimensão Conceitual, 30%)
O Relatório Técnico Final deve ser o próprio README.md da raiz da branch main, seguindo a estrutura deste esqueleto. Relatório entregue em outro arquivo (PDF, Word, outro .md, Google Docs, wiki do GitHub etc.) não será corrigido. Os demais artefatos (DER, modelo lógico, dicionário de dados, levantamento, script SQL, massa de dados, slides) ficam em arquivos separados no repositório, com link a partir do README.
Integrantes
Nome completo do aluno	RGM	Usuário do GitHub

**Nomes dos alunos e RGM Nome: Ryan Vitor RGM: 49307509 Nome: Karyza Ribeiro RGM: 48065064 Nome: Maria Eduarda RGM: 048098035 Nome: Daniel Felipe RGM: 47576723 Nome: Vinicius Gomes RGM: 48108804 Nome: Ana Julia De Angelo RGM:46764348



1.1 Revisão do Modelo Conceitual
(obrigatória, sem peso próprio — mas todo o restante da entrega é construído e avaliado sobre este modelo: um erro que permanecer no DER revisado se propaga para a conversão, a normalização, o modelo lógico e o script SQL)
Caracterização da organização (todos os grupos)
Repita aqui a caracterização da organização — atualizada, mesmo que a organização seja a da Entrega 1. Na Entrega 1, os erros mais comuns foram: porte sem números, problema declarado que depois não aparecia no DER, evidências fora do repositório e modelo cobrindo só parte da organização. Evite-os:
•	Nome e natureza da organização: qual organização real o grupo escolheu (com acesso garantido para pesquisa de campo) — pode ser uma empresa (livraria, lanchonete, pet shop), uma ONG, uma associação comunitária ou outra instituição. 
A Marcenariarte Planejados é uma empresa privada que trabalha com marcenaria e fabricação de móveis sob medida. O grupo terá acesso à empresa para conhecer de perto seu funcionamento, conversar com o responsável e entender como são realizadas as atividades de produção, atendimento aos clientes e vendas. Essas informações serão utilizadas para identificar as necessidades da empresa e desenvolver um sistema que possa ajudar a melhorar suas atividades.

•	Contexto e porte: com ou sem fins lucrativos; tamanho da operação; número de pessoas envolvidas (funcionários, voluntários, membros, fiéis); volume de atividades (vendas, atendimentos, doações, rituais, eventos). 
A Marcenariarte Planejados é uma empresa privada com fins lucrativos, de pequeno a médio porte, especializada na fabricação e montagem de móveis planejados para residências e ambientes comerciais. A empresa conta com 8 pessoas, incluindo o proprietário, distribuídas entre as seguintes funções:
1 proprietário: responsável pela administração e pelas decisões gerais da empresa.
1 vendedor/projetista: responsável pelo atendimento aos clientes, elaboração de orçamentos e desenvolvimento dos projetos de móveis.
1 comprador: responsável pela compra de materiais e insumos necessários para a fabricação dos móveis.
2 marceneiros: responsáveis pela fabricação e pelo acabamento dos móveis na oficina.
2 montadores: responsáveis pela montagem e instalação dos móveis nos locais dos clientes.
1 entregador: responsável pela entrega dos materiais e móveis.

•	Informe números, não só adjetivos (ex.: "cerca de 300 pedidos por semana", e não "grande movimento") — são eles que justificam o tamanho da massa de dados (seção 4).
A empresa trabalha com uma média estimada de 4 a 6 projetos de móveis planejados por mês, dependendo do tamanho e da complexidade de cada pedido. Sua rotina envolve o atendimento aos clientes, a elaboração de orçamentos, a compra de materiais, a fabricação, a entrega e a montagem dos móveis.
•	Problemas e necessidades identificados: qual é a "crise operacional" — o que está desorganizado hoje (planilhas soltas, papel, falta de controle de estoque/doações/cadastros etc.)? Numere cada problema (P1, P2…). Todo problema declarado aqui precisa ser resolvido pelo modelo: deve aparecer no DER e ter ao menos uma consulta gerencial no script SQL (ver a tabela de rastreabilidade da seção 1.6). O problema deve ser de gestão de informações — refazer o site ou melhorar a divulgação da organização, por exemplo, não é um problema que um banco de dados resolva.

•	P1: A negociação dos projetos é registrada em fichas comerciais pelo setor de vendas, enquanto a emissão de notas fiscais ocorre manualmente após a conclusão do serviço. Sem a integração de dados, ocorrem divergências frequentes entre o valor contratado, o montante pago pelo cliente e o valor faturado, além do risco de projetos concluídos ficarem sem a devida emissão da nota fiscal correspondente.

•	P2: A atribuição de marceneiros para a fabricação na oficina e de montadores para a instalação no cliente é feita de forma verbal ou em quadros brancos que são apagados diariamente. Quando ocorrem defeitos de fabricação, atrasos na montagem ou solicitações de garantia, a empresa não consegue identificar no histórico quais profissionais atuaram no projeto, inviabilizando a apuração de responsabilidades e a avaliação do desempenho individual da equipe.

•	P3: Cada projeto gera um plano de corte técnico com retalhos de madeira que possuem potencial de reutilização. Como não há um cadastro sistematizado dessas sobras reaproveitáveis atreladas ao estoque de materiais, a marcenaria perde visibilidade do seu saldo real de insumos na oficina. Isso resulta na compra desnecessária e duplicada de materiais que já estão disponíveis fisicamente no galpão.

•	P4: A cotação e a emissão de ordens de compra de matérias-primas junto aos fornecedores ocorrem via aplicativos de mensagem sem o devido registro formal de quem solicitou cada insumo. Essa falha de rastreabilidade entre o comprador responsável, o pedido emitido e o fornecedor contratado geram atrasos na entrega de insumos essenciais, paralisações na linha de produção e falta de controle do histórico de preços praticados no mercado.

•	P5: Como os móveis são fabricados sob medida, cada pedido pode apresentar características e prazos diferentes. É necessário registrar o andamento dos projetos e suas respectivas etapas para facilitar o acompanhamento da produção e identificar pedidos que ainda precisam ser concluídos.

•	Escopo do sistema: o banco de dados deve reunir todos os dados da organização, não só os de um setor ou processo. Mesmo que os problemas declarados se concentrem em uma área, o modelo não pode servir somente a um recorte (ex.: só o estoque de uma clínica, deixando de fora pacientes e atendimentos).

O sistema de banco de dados da empresa tem como objetivo reunir e organizar as informações da empresa em um só lugar, facilitando o acesso aos dados e o controle das atividades do dia a dia. A ideia é ajudar a empresa a manter suas informações mais organizadas, desde o atendimento aos clientes da fabricação até as montagens dos móveis.
O sistema contará com o cadastro de clientes e funcionários, registrando os pedidos e os projetos, com um acompanhamento de produção e de montagem, além do controle dos materiais, das sobras que podem ser reaproveitadas, das compras e dos fornecedores. Também serão registradas informações sobre os pagamentos e as notas fiscais dos projetos.
Com essas informações organizadas, será possível acompanhar o andamento dos pedidos, verificar os prazos de entrega, identificar os materiais disponíveis e consultar quais funcionários participaram de cada projeto. Isso ajudará o proprietário a ter uma visão melhor do funcionamento da empresa e a tomar decisões com mais facilidade.
Dessa forma, o sistema pretende melhorar a organização das informações da empresa, facilitando o trabalho dos profissionais e reduzindo as dificuldades na consulta e no controle dos dados. Assim, a empresa poderá ter mais controle sobre suas atividades e manter as informações importantes reunidas em um único banco de dados.

•	Justificativa da escolha: por que essa organização foi escolhida e por que ela é um bom caso para o projeto? Se algum integrante trabalha na organização ou tem vínculo familiar com os responsáveis, declare isso — o vínculo não gera desconto, mas não dispensa a comprovação da entrevista com o responsável, realizada no ambiente da organização.
A empresa foi escolhida para este projeto por ser uma empresa que trabalha com diferentes atividades, como atendimento aos clientes, elaboração de projetos, compra de materiais, fabricação e montagem de móveis sob medida. Essa variedade de processos permite entender melhor o funcionamento da empresa e identificar como um banco de dados pode ajudar na organização das informações.
A escolha também foi facilitada pelo fato de um dos integrantes do grupo ser filho do proprietário da empresa, o que possibilitou o acesso ao local para conhecer as atividades realizadas e conversar com o responsável.
Evidências da organização: comprove que a organização existe e que o grupo teve acesso a ela — fotos do local/da visita, link da organização no Google, endereço completo e forma de contato. Prefira o perfil da organização no Google Meu Negócio (Google Business Profile), que é a comprovação mais direta; site e redes sociais complementam. As fotos só são aceitas como arquivos JPG ou PNG dentro do repositório — fotos hospedadas fora dele (Google Drive, Imgur, anexos colados no editor do GitHub etc.) não são consideradas.
•	Responsável pela organização: nome e telefone de quem atendeu o grupo — o professor pode entrar em contato para confirmar as informações.

Relato da entrevista (todos os grupos)
Relate a entrevista com o responsável pela organização. A entrevista da Entrega 1 pode ser reaproveitada se atender a todos os itens abaixo — inclusive ter sido feita no ambiente da organização, com foto — e se tiver levantado o necessário para os processos, requisitos e regras desta etapa. Se algo precisou ser confirmado depois (ex.: processos típicos levantados por pesquisa), relate também a nova visita.
•	Quem: nome e função do entrevistado e quais integrantes do grupo participaram.
O entrevistado foi Ricardo dos Santos, proprietário da Marcenariarte Planejados. A entrevista teve como objetivo compreender melhor o funcionamento da empresa, conhecer os procedimentos utilizados nas atividades administrativas e produtivas e identificar as necessidades que podem ser atendidas por meio de um banco de dados.

•	Quando e onde: data e local — a entrevista deve ser realizada no ambiente da organização. A observação presencial da rotina é parte importante do levantamento de requisitos: o que o grupo vê acontecer no local (como um pedido é anotado, onde o estoque é controlado, que papéis e planilhas circulam) muitas vezes difere do que é dito na entrevista. Destaque os achados obtidos pela observação, separados dos obtidos pelas respostas do entrevistado.
A entrevista foi realizada em 20 De Outubro, nas dependências da Marcenariarte Planejados, localizada em Itaquera-SP.

•	O que foi levantado: o que foi perguntado, o que foi confirmado e, se houve nova visita, o que mudou em relação à Entrega 1 (processos, regras, volumes, problemas). O levantamento completo fica em um arquivo Markdown (.md) à parte no repositório, com link no README — recomenda-se fortemente colocá-lo numa pasta chamada levantamento (ex.: levantamento/levantamento.md). Esse arquivo é um texto organizado, escrito pelo grupo, sobre o que foi levantado — não é um vídeo ou áudio da entrevista, nem a transcrição crua de formulários ou de perguntas e respostas. No README, apresente um resumo do levantamento.
Em comparação com o Trabalho 1, este levantamento permitiu aprofundar o conhecimento sobre o funcionamento da marcenaria e compreender melhor as necessidades da empresa. Por meio de perguntas direcionadas e do contato com profissionais de diferentes áreas, como vendas e compras, foi possível conhecer melhor os procedimentos utilizados no registro dos projetos, no controle financeiro, na aquisição de materiais e na organização das informações. Dessa forma, o levantamento serviu como uma etapa importante para aprimorar o projeto iniciado no Trabalho 1, buscando desenvolver uma solução que atenda às necessidades reais da marcenaria. A proposta é centralizar as informações, facilitar as consultas e contribuir para um melhor acompanhamento das atividades administrativas e produtivas da empresa.

Nível de detalhe — processos, requisitos e regras de negócio (todos os grupos)
Frases genéricas como "o sistema deve permitir cadastrar cliente" são superficiais e não bastam. Em processos, requisitos e regras, indique quais dados estão envolvidos — todos os campos que aparecem no trabalho (DER, dicionário de dados, modelo lógico):
Superficial	Detalhado
O sistema deve permitir cadastrar cliente.	O sistema deve permitir registrar clientes com nome completo, CPF, telefone, e-mail e endereço.
O sistema deve registrar os funcionários.	O sistema deve permitir registrar os colaboradores com identificador único, nome completo, telefone, e-mail e cargo.
O sistema deve permitir cadastrar projetos.	O sistema deve permitir registrar cada projeto com um identificador único, descrição dos móveis, data de início, prazo previsto, valor negociado, situação atual do projeto e quais funcionários irão participar. 
O sistema deve controlar as notas fiscais.	O sistema deve permitir registrar as informações das notas fiscais relacionadas aos projetos, incluindo número da nota, série, data de emissão, valor, cliente e situação, mantendo o vínculo com o projeto correspondente.
O sistema deve registrar a forma de pagamento	O sistema deve permitir registrar a forma de pagamento, data de pagamento, valor de pagamento, status de pagamento.
O sistema deve controlar as compras.	O sistema deve permitir registrar pedidos de compra com número identificador, fornecedor, data da solicitação, materiais solicitados, quantidades, valor total e situação do pedido.
O sistema deve registrar os fornecedores.	O sistema deve cadastrar todos os fornecedores deve ser cadastrado com um identificador único, número do pedido, e-mail, CNPJ e endereço.
O sistema deve controlar os materiais.	O sistema deve registrar todo material que chega dos fornecedores com identificador único, nome do material, tipo de material, unidade de medida e descrição do material.
O sistema deve registrar os planos de cortes.	O sistema deve registrar cada plano de corte com a respectiva liberação dos materiais exigidos pelo projeto.
O sistema deve registrar um controle de estoques.	O sistema deve registrar um estoque que possui um identificador único, nome do produto, quantidade e as unidades de medidas.

Processos de negócio (todos os grupos)
Apresente os principais processos mapeados na organização — ex.: cadastro de clientes/beneficiários/fiéis, controle de estoque ou doações, vendas ou arrecadação, emissão de pedidos ou solicitações, entregas ou distribuição, organização de eventos/rituais/mutirões.
•	Levante os processos típicos do tipo de organização. É recomendável usar pesquisas e ferramentas de IA para descobrir quais processos são comuns em organizações do mesmo tipo (ex.: o que toda pizzaria, ONG de doação de alimentos ou oficina mecânica costuma fazer) e conferir se eles existem na organização escolhida. Isso pode exigir uma nova visita à organização para confirmar como cada processo funciona lá. Registre esse uso de IA na seção 6.
•	Inclua os processos que existem na organização, mesmo os que não estão ligados aos problemas declarados — o banco de dados reúne todos os dados da organização (ver Escopo do sistema acima).
•	Justifique os processos prováveis não incluídos: se um processo comum nesse tipo de organização ficou de fora (ex.: compras de fornecedores, cancelamentos, escala da equipe), explique por quê — por exemplo, a organização não o realiza, ou ele é feito por terceiros.
Requisitos (todos os grupos)
Apresente os requisitos do sistema, atualizados com base na correção da Entrega 1 (ou elaborados agora, para quem trocou de organização):
•	Requisitos Funcionais: o que o sistema precisa fazer, com os dados envolvidos (ex.: "o sistema deve permitir registrar uma venda com data, cliente, vendedor, forma de pagamento e, para cada item, produto, quantidade e preço unitário"). Cada um com um código (RF01, RF02…).
•	Requisitos Não Funcionais: características de qualidade (ex.: desempenho, segurança, usabilidade, disponibilidade). Cada um com um código (RNF01, RNF02…).
•	Levante os requisitos típicos do tipo de organização. Assim como nos processos, é recomendável usar pesquisas e ferramentas de IA para descobrir quais requisitos funcionais e não funcionais são comuns em sistemas de organizações semelhantes e conferir se eles se aplicam à organização escolhida — o que pode exigir confirmação com o responsável. Registre esse uso de IA na seção 6.
•	Justifique os requisitos prováveis não incluídos: se um requisito comum nesse tipo de organização ficou de fora, explique por quê (ex.: a organização não realiza o processo correspondente, ou a necessidade não existe no porte dela).
Na Entrega 1, os erros mais comuns foram: requisitos de um sistema diferente do que foi mapeado (ex.: cardápio por QR Code ou motor de recomendação, quando o processo real é o garçom anotar o pedido), problemas declarados sem nenhum requisito que os resolva e requisitos técnicos (autenticação por JWT, hospedagem em nuvem) listados como funcionais. Os requisitos devem corresponder aos processos de negócio descritos acima e cobrir todos os problemas declarados (P1, P2…).
Regras de negócio (todos os grupos)
Liste as regras de negócio vigentes, cada uma com um código (RN01, RN02…) — mantenha os códigos da Entrega 1 quando já existirem. Esses códigos são citados nas justificativas das restrições (seção 1.5) e nas consultas de auditoria do script SQL (seção 3).
•	Levante as regras típicas do tipo de organização. Assim como nos processos e nos requisitos, é recomendável usar pesquisas e ferramentas de IA para descobrir quais regras são comuns em organizações semelhantes e conferir se elas valem na organização escolhida — o que pode exigir confirmação com o responsável. Considere tanto as regras operacionais (ex.: pedido só é entregue se estiver registrado; cancelamento fica no histórico, não é apagado) quanto as restrições legais e organizacionais (ex.: LGPD, emissão de nota fiscal, normas sanitárias, idade mínima, acesso por cargo). Registre esse uso de IA na seção 6.
•	Justifique as regras prováveis não incluídas: se uma regra comum nesse tipo de organização ficou de fora, explique por quê (ex.: a organização não realiza o processo correspondente, ou a regra não se aplica ao porte ou à natureza dela)

Notação do DER conceitual (todos os grupos — Caso A e Caso B)
O DER deve seguir a notação do brModelo, como no exemplo abaixo:
Elemento	Como aparece	No exemplo
Entidade	retângulo	Entity 1 a Entity 5
Relacionamento	losango	Rel 33, Rel 34
Cardinalidade mínima e máxima	par (mín, máx) dos dois lados de cada relacionamento	(0, 1), (1, n), (0, n)
Autorrelacionamento	losango ligado duas vezes à mesma entidade, cada lado com sua cardinalidade	Rel 33, em Entity 3
Atributo identificador (chave)	círculo preenchido	Chave 1, Chave 2, Chave 3, Chave 4
Identificador composto	mais de um círculo preenchido na mesma entidade (obrigatório) — ou mais de um atributo sublinhado, se os atributos estiverem listados no retângulo	Chave 50 + Chave 51, em Entity 5
Atributo comum	círculo vazio	Attribute 10, Attribute 30
Atributo multivalorado	círculo vazio com a cardinalidade do atributo	Attribute 11 (1, n)
Atributo composto (representação gráfica opcional)	atributo com seus próprios subatributos ligados a ele	Attribute 21, com attr 211 e attr 212
Generalização/especialização	triângulo ligando a entidade genérica às especializadas. A indicação de totalidade e disjunção não é obrigatória	Entity 1 → Entity 2 e Entity 3
Entidade associativa	retângulo envolvendo o losango do relacionamento, que passa a poder se relacionar com outras entidades e ter atributos próprios	Rel 53, com Attribute 530


•	Representação gráfica opcional: atributos compostos podem ser desenhados como no exemplo (subatributos ligados ao atributo), mas não é obrigatório; o mesmo vale para a indicação de totalidade/disjunção da generalização/especialização.
•	Atributos de entidades: podem ser representados como no brModelo (círculos ligados à entidade, como no exemplo) ou listados dentro do retângulo da entidade — nesse caso, o identificador deve estar sublinhado.
•	Atributos de relacionamentos e de entidades associativas: somente como no brModelo, ligados ao losango ou à entidade associativa (como Attribute 530) — não podem ser listados dentro de um retângulo.
•	Sem chaves estrangeiras — elas só aparecem no modelo lógico (seção 2).
Informe no README em qual software ou aplicativo o DER foi criado.
Ferramenta utilizada: brModelo, utilizado para a elaboração e revisão do Diagrama Entidade-Relacionamento (DER) conceitual.
Caso A — mesma organização da Entrega 1
Apresente o DER conceitual revisado, na notação descrita acima. A revisão parte da correção da Entrega 1 recebida pelo grupo — o DER e os demais itens acima. Para cada apontamento da correção, registre o que foi feito:
Apontamento da correção da E1	O que mudou no trabalho	Por quê
Entidade CLIENTE duplicada.
	A representação de Cliente foi reorganizada para utilizar uma única entidade, relacionada ao Projeto.
	Evitar duplicidade de informações e manter a consistência do modelo conceitual.

Ausência de atributos nas entidades.
	Foram acrescentados atributos identificadores e comuns às entidades representadas no DER.
	Permitir a identificação dos registros e a representação das informações necessárias aos processos da empresa.

Ausência da entidade associativa para os itens do pedido de compra.
	Foi identificada a necessidade de representar os itens de cada pedido, incluindo quantidade e preço.
	Permitir que um pedido contenha vários materiais e registrar as informações específicas de cada item.

Inconsistências entre o DER e o README.
	Os relacionamentos estão sendo revisados para manter a coerência entre o modelo conceitual, os processos de negócio e a documentação.
	Garantir que o diagrama represente os processos descritos no projeto.

		
Relacionamento entre Projeto e Plano de Corte.
	O relacionamento está sendo revisado para refletir a regra de negócio referente à quantidade de planos de corte permitidos por projeto.
	Evitar contradições entre o modelo de dados e as regras documentadas.

Representação da participação dos profissionais na fabricação e montagem.
	Os relacionamentos entre Projeto, Plano de Corte, Marceneiro e Montador estão sendo revisados.
	Permitir a identificação dos profissionais envolvidos e dos projetos nos quais atuaram.


Se o grupo discordar de algum apontamento e mantiver o modelo como estava, registre isso na tabela com a justificativa. Apontamento não citado na tabela é tratado como não corrigido.
Caso B — nova organização (a da Entrega 1 era fictícia ou não teve a existência comprovada)
Além de todos os itens acima, apresente o DER conceitual da nova organização, na notação descrita acima.
Use a correção da Entrega 1 do grupo como guia dos erros a não repetir, mesmo sendo outra organização.
1.2 Conversão do Modelo Conceitual para o Modelo Lógico
(vale 7,5%)
•	Entidades → Tabelas: como cada entidade virou tabela.
•	Atributos → Colunas: conversão correta dos atributos.
•	Relacionamentos → Chaves: como os relacionamentos foram traduzidos.
•	Cardinalidades: como cada cardinalidade (1:1, 1:N, N:N) foi tratada (inclusive tabelas associativas, se houver).
•	Generalização/especialização: se o DER tiver, qual estratégia de conversão foi usada (tabela única, uma tabela por entidade ou só as especializadas) e por quê.
Conversão do Modelo Conceitual para o Modelo Lógico
A conversão do modelo conceitual para o modelo lógico foi realizada considerando as entidades, os atributos, os relacionamentos e as cardinalidades identificados no DER da Marcenariarte Planejados. O objetivo foi estruturar os dados em tabelas relacionadas entre si, reduzindo a duplicidade de informações e garantindo a integridade dos registros.

Entidades e tabelas: cada entidade do modelo conceitual foi convertida em uma tabela do modelo lógico, como Cliente, Projeto, Vendedor, Comprador, Fornecedor, Pedido, Material, Estoque, Plano De Corte, Pagamento e Nota Fiscal.

Atributos e colunas: os atributos das entidades foram convertidos em colunas das respectivas tabelas. Os atributos identificadores foram utilizados como base para a definição das chaves primárias, responsáveis por identificar unicamente cada registro.

Relacionamentos e chaves estrangeiras: os relacionamentos entre as entidades foram implementados conforme suas cardinalidades. Nos relacionamentos de um para muitos (1), a chave estrangeira é normalmente inserida na tabela correspondente ao lado N. Nos relacionamentos de muitos para muitos (N), utiliza-se uma tabela associativa para representar a ligação entre as entidades.

Cardinalidades e integridade: as cardinalidades definidas no modelo conceitual orientaram a estrutura das tabelas e a implementação dos relacionamentos. As restrições de integridade devem assegurar que os registros relacionados respeitem as regras de negócio da organização.
A estrutura lógica foi planejada para apoiar os processos de cadastro de clientes, elaboração de projetos, compras de materiais, controle de estoque, fabricação, montagem, faturamento e pagamentos, permitindo maior organização e rastreabilidade das informações.




1.3 Definição de Chaves Primárias e Estrangeiras
Liste as PKs e FKs de cada tabela (serve de base para a justificativa técnica abaixo).
Vendedor- Campo	Tipo de Chave
ID Vendedor	Chave primaria 
Nome	Atributo comum
Email	Atributo comum
Telefone	Atributo comum
Cargo	Atributo comum

Projeto- Campo	Tipo de Chave
ID Projeto	Chave primaria 
Descrição	Atributo comum
Data	Atributo comum
Valor	Atributo comum
Prazo	Atributo comum
Status	Atributo comum

Cliente- Campo	Tipo de Chave
ID Cliente	Chave primaria 
Nome	Atributo comum
Telefone	Atributo comum
CPF	Atributo comum
Email	Atributo comum
Endereço	Atributo comum

Pagamento- Campo	Tipo de Chave
ID Pagamento	Chave primaria 
Valor	Atributo comum
Data de Emissão 	Atributo comum
Forma de Pagamento	Atributo comum
Status	Atributo comum

Nota Fiscal- Campo	Tipo de Chave
ID Nota	Chave primaria 
Número 	Atributo comum
Data de Emissão 	Atributo comum
Valor	Atributo comum


Plano de Corte- Campo 	Tipo de Chave
ID Plano	Chave primaria 
Data	Atributo comum
Descrição	Atributo comum

Comprador- Campo	Tipo de Chave
ID Comprador	Chave primaria 
Nome	Atributo comum
Email	Atributo comum
Telefone	Atributo comum
Cargo	Atributo comum

Pedido- Campo	Tipo de Chave
ID Pedido	Chave primaria 
Material	Atributo comum
Quantidade	Atributo comum
Status	Atributo comum
Data	Atributo comum
Valor	Atributo comum

Fornecedor- Campo	Tipo de Chave
ID Fornecedor	Chave primaria 
Nome	Atributo comum
Telefone	Atributo comum
Email	Atributo comum
CNPJ	Atributo comum
Endereço	Atributo comum

Material- Campo	Tipo de Chave
ID Material	Chave primaria 
Nome	Atributo comum
Descrição	Atributo comum
Tipo De Material	Atributo comum
Medida	Atributo comum

Estoque- Campo	Tipo de Chave
ID Estoque	Chave primaria 
Nome	Atributo comum
Quantidade	Atributo comum
Medida	Atributo comum


1.4 Processo de Normalização (1FN, 2FN e 3FN)
(vale 7,5%)
•	1FN: eliminação de grupos repetitivos/atributos multivalorados.
•	2FN: eliminação de dependências parciais.
•	3FN: eliminação de dependências transitivas.
•	Justificativa do processo: por que cada forma normal foi necessária no seu caso.
A normalização do banco de dados da Marcenariarte Planejados foi considerada para organizar as informações, reduzir a duplicidade de dados e evitar inconsistências durante as operações de cadastro, consulta e atualização.

Primeira Forma Normal (1FN):
As tabelas foram organizadas para que cada campo armazene um único valor por registro, evitando listas de informações em uma mesma coluna e grupos repetitivos. Os dados de clientes, projetos, fornecedores, materiais, compras e pagamentos foram separados conforme suas respectivas entidades.

Segunda Forma Normal (2FN):
A estrutura foi organizada para que os atributos dependam integralmente das chaves primárias de suas respectivas tabelas. A separação das entidades permite evitar dependências parciais, especialmente em relacionamentos que envolvem mais de uma informação para identificar um registro. 

Terceira Forma Normal (3FN):
As tabelas foram separadas de acordo com suas responsabilidades, evitando que informações de uma entidade sejam armazenadas desnecessariamente em outra. Dessa forma, dados de clientes, vendedores, fornecedores, materiais e demais registros permanecem em suas próprias tabelas, sendo relacionados por meio de chaves estrangeiras.

Justificativa do processo:
A aplicação das formas normais contribui para manter os dados organizados, reduzir redundâncias e preservar a integridade das informações. Essa organização é importante para os processos da marcenaria, principalmente no controle de projetos, compras, estoque, fabricação, montagem e faturamento.

1.5 Justificativas Técnicas das Decisões
(vale 7,5%)
•	Justificar as chaves primárias escolhidas.
•	Justificar as chaves estrangeiras e os relacionamentos que elas implementam.
•	Justificar as restrições aplicadas (unicidade, obrigatoriedade, valores permitidos etc.), citando o código da regra de negócio (RNxx) que cada restrição implementa, quando houver.
•	Justificar decisões arquiteturais gerais do modelo.
•	1.5 Justificativas Técnicas das Decisões

 Justificativa das chaves primárias (PKs)
Foram definidos identificadores próprios para as tabelas do banco de dados, como id cliente, id projeto, id vendedor, id comprador, id pedido, id fornecedor e id material. A utilização dessas chaves primárias permite identificar cada registro individualmente, evitar duplicidades e facilitar a consulta e atualização das informações.
 Justificativa das chaves estrangeiras (FKs) e relacionamentos
As chaves estrangeiras foram planejadas para conectar as tabelas de acordo com os relacionamentos identificados no DER. Essa estrutura permite relacionar clientes aos projetos, vendedores às negociações, compradores aos pedidos, fornecedores às compras e materiais aos registros de estoque.
Também permite relacionar projetos às respectivas notas fiscais, pagamentos, planos de corte e atividades de montagem. Nos relacionamentos de muitos para muitos, a utilização de tabelas associativas permite registrar informações específicas de cada participação, como quantidade e preço dos materiais adquiridos em cada pedido.


 Justificativa das restrições aplicadas
As restrições de integridade foram consideradas para garantir que os registros respeitem as regras de negócio da Marcenariarte Planejados.
RN01 — Identificação dos projetos: cada projeto deverá possuir um identificador único.
RN02 — Vínculo com o cliente: todo projeto deverá estar associado a um cliente cadastrado.
RN04 — Controle fiscal: cada nota fiscal deverá estar vinculada ao projeto correspondente, respeitando a regra de uma nota fiscal por projeto.
RN05 — Registro de pagamentos: os pagamentos deverão estar relacionados aos projetos correspondentes.
RN06 — Responsabilidade pelas compras: cada pedido deverá identificar o comprador responsável.
RN07 — Identificação do fornecedor: cada pedido deverá estar associado a um fornecedor cadastrado.
RN08 — Identificação dos materiais: cada material deverá possuir um identificador próprio.
Essas restrições poderão ser implementadas por meio de chaves primárias, chaves estrangeiras, restrições de unicidade e obrigatoriedade, conforme as necessidades de cada relacionamento.
 
Justificativa das decisões arquiteturais
A estrutura do banco de dados foi organizada de forma relacional, separando as informações de clientes, vendedores, compradores, projetos, fornecedores, pedidos, materiais, estoque, pagamentos e notas fiscais em tabelas específicas.
Essa decisão busca reduzir a repetição de informações, facilitar a manutenção dos registros e permitir consultas integradas entre os diferentes processos da empresa.
A separação das informações também favorece a rastreabilidade das atividades, principalmente no acompanhamento dos projetos, nas compras de materiais, no controle de estoque e no registro das operações financeiras e fiscais.
Dessa forma, o modelo foi planejado para centralizar as informações da Marcenariarte Planejados e permitir futuras melhorias, como relatórios gerenciais e análises de desempenho.

1.6 Proposta de Arquitetura Analítica para BI e IA
(vale 7,5%)
•	Informações estratégicas que podem ser extraídas dos dados para a gestão da organização.
O banco de dados poderá fornecer informações importantes para a administração da empresa, como:
Quantidade de projetos realizados em determinado período.
Valores contratados e pagamentos registrados.
Quantidade de pedidos de compra realizados.
Materiais cadastrados e quantidades disponíveis em estoque.
Participação dos profissionais nos projetos de fabricação e montagem.
Situação dos projetos e acompanhamento dos registros fiscais.
Essas informações poderão ajudar a identificar dificuldades operacionais, acompanhar os resultados da empresa e melhorar o planejamento das atividades.

•	Indicadores e métricas gerenciais propostos (KPIs).
Indicador (KPI)	Fórmula De Cálculo	Periodicidade
Quantidade de projetos registrados
		Contagem de projetos cadastrados no período
		Mensal

Valor total contratado
		Soma dos valores contratados dos projetos
		Mensal

Total de pagamentos recebidos
	Soma dos valores dos pagamentos registrados
		Mensal

Quantidade de pedidos de compra
		Contagem dos pedidos registrados
	Mensal

Tempo médio de recebimento de compras
	Média da diferença entre a data do pedido e a data de recebimento
	Mensal

Quantidade de materiais em estoque
		Soma das quantidades registradas no estoque
	Mensal


•	Potencial dos dados para BI: como a estrutura apoia dashboards/relatórios.
A estrutura do banco de dados poderá servir como base para a criação de dashboards e relatórios gerenciais. Esses recursos poderão apresentar gráficos e indicadores relacionados aos projetos, faturamento, pagamentos, compras e estoque. Por meio dessas informações, a administração poderá acompanhar os resultados financeiros, observar a evolução dos projetos, identificar materiais com quantidades reduzidas e avaliar o volume de compras realizadas.
•	Aplicações analíticas e de IA: como o modelo pode alimentar análises preditivas, recomendações etc.
Com o crescimento do volume de informações armazenadas, os dados poderão ser utilizados futuramente em aplicações de análise e Inteligência Artificial, como:
•	Previsão de demanda: analisar o histórico de projetos para estimar períodos de maior procura por móveis planejados.
•	Previsão de compras: utilizar o histórico de consumo de materiais para auxiliar no planejamento de novas aquisições.
•	Análise financeira: identificar padrões nos valores contratados e pagamentos registrados.
•	Identificação de padrões operacionais: analisar informações de fabricação, montagem e compras para identificar possíveis dificuldades nos processos.
Essas aplicações são propostas para futuras melhorias e dependerão da existência de dados suficientes, organizados e confiáveis.

Rastreabilidade: inclua uma tabela que ligue cada problema declarado na caracterização da organização e cada KPI proposto às tabelas que o sustentam e à consulta do script SQL que o responde (pelo código da consulta — ver seção 3):
Problema ou KPI	Tabelas envolvidas	Consulta no script
Descontrole no faturamento e inconsistências fiscais
	Projeto, Nota Fiscal e Pagamento
	G01 — Projetos, notas fiscais e pagamentos

Falta de rastreabilidade na fabricação e montagem
	Projeto, Plano De Corte, Marceneiro, Participação Montagem e Montador
	G02 — Profissionais envolvidos nos projetos

Falta de registro de sobras e desperdício de materiais
	Material e Estoque
	G03 — Consulta de sobras e materiais disponíveis

Quantidade de projetos por mês
	Projeto	Projetos registrados por período

Valor total contratado
	Projeto
	Valores contratados por período

Quantidade e tempo de recebimento dos pedidos
	Pedido e Fornecedor
	Análise dos pedidos de compra


KPI sem consulta no script que o calcule não é considerado KPI. Cada problema declarado deve ter pelo menos uma consulta que o responda.
O que é KPI: Key Performance Indicator (indicador-chave de desempenho) é um número que mostra, de forma objetiva, se a organização está indo bem em algo que importa para a gestão dela. Um KPI tem fórmula (como é calculado), período (por dia, semana, mês) e, de preferência, uma meta para comparação. Exemplos: ticket médio por venda, taxa de cancelamento de pedidos, produtos abaixo do estoque mínimo, tempo médio de atendimento, número de beneficiários atendidos por mês, percentual de doações recorrentes. "Melhorar o atendimento" não é KPI; "tempo médio entre o pedido e a entrega, por semana" é.
Como levantar: é recomendável usar pesquisas e ferramentas de IA para descobrir quais indicadores são usados por organizações do mesmo tipo (ex.: "principais KPIs de uma pizzaria", "indicadores de gestão de uma ONG de doação de alimentos") e quais análises de BI e de IA costumam ser aplicadas a elas. Depois, filtre pelo que o seu banco consegue calcular: um KPI só vale se as tabelas do modelo tiverem os dados necessários e se houver uma consulta no script que o calcule (ver Rastreabilidade, abaixo). Se possível, confirme com o responsável pela organização quais indicadores seriam úteis para ele. Registre esse uso de IA na seção 6.
________________________________________
12. Modelo Lógico Relacional
(diagrama separado — vale 10% na Dimensão Procedimental)
O modelo lógico deve seguir a notação visual do brModelo para o modelo lógico, como no exemplo abaixo. Informe no README em qual software ou aplicativo ele foi criado.
Software utilizado: brModelo, utilizado para a elaboração dos diagramas conceitual e lógico relacional.
Elemento	Como aparece	No exemplo
Tabela	retângulo com o nome da tabela no topo e uma linha por coluna	Entity 1, Entity 5
Coluna	nome da coluna, à esquerda, com o tipo de dado à direita	Attribute 30 — INT
Chave primária	marca PK ao lado do tipo	Chave 1, em Entity 1; Chave 50 + Chave 51, em Entity 5 (chave primária composta)
Chave estrangeira	marca FK ao lado do tipo	Chave 3, em Entity 4
Coluna que é chave primária e estrangeira	marcas PK, FK	Chave 1, em Entity 2
Ligação entre tabelas	linha entre a tabela da FK e a tabela referenciada, com a cardinalidade (mín, máx) em cada ponta	Entity 3 — Entity 4: (1, 1) e (0, n)

Deve apresentar claramente:
•	Tabelas
•	Atributos (colunas), com seus tipos de dados
•	Chaves primárias
•	Chaves estrangeiras
•	Cardinalidades já convertidas
As demais restrições de integridade — obrigatoriedade (NOT NULL), unicidade (UNIQUE), valores permitidos (CHECK), valores padrão (DEFAULT) — não aparecem no diagrama do brModelo e devem ser documentadas no dicionário de dados (seção 5) e implementadas no script SQL (seção 3).
________________________________________
3. Script SQL Completo
(arquivo .sql — vale 12% na Dimensão Procedimental)
O script completo é um arquivo no formato .sql disponível no repositório, de preferência numa pasta chamada docs (ex.: docs/script.sql), com link no README. Script colado só no README, em PDF, em imagem ou em outro formato não é aceito.
SGBD: MySQL — o disponível no laboratório ou outra instalação equivalente a que o grupo tenha acesso. O script deve executar no MySQL.
O script deve conter, nesta ordem lógica:
1.	CREATE DATABASE
2.	CREATE TABLE (todas as tabelas, com tipos de dados adequados)
3.	Constraints (PK, FK, NOT NULL, UNIQUE, CHECK etc.)
4.	INSERT INTO (carga da massa de dados — ver seção 4)
5.	SELECT com JOIN (consultas que cruzam múltiplas tabelas)
6.	UPDATE
7.	DELETE
8.	Consultas gerenciais (que respondem perguntas de gestão, ex.: faturamento/arrecadação por período, número de atendimentos/beneficiários)
9.	Consultas de auditoria (que verificam consistência/integridade dos dados)
Cada consulta gerencial e cada consulta de auditoria deve ter um cabeçalho em comentário com um código (G01, G02… para gerenciais; A01, A02… para auditoria), a pergunta que ela responde em português e o que ela atende:
-- G03 — Quais bebidas estão abaixo do estoque mínimo hoje?
-- Atende: P1 (ruptura de estoque de bebidas)
SELECT ...

-- A02 — Existe pedido registrado sem nenhum item?
-- Verifica: RN04 (todo pedido tem ao menos um item)
SELECT ...


•	Consultas gerenciais respondem aos problemas declarados e aos KPIs da seção 1.6 — pelo menos uma por problema declarado e por KPI.
•	Consultas de auditoria verificam regras de negócio, citando o código da regra (RNxx) que cada uma confere.
•	Essas mesmas consultas são as usadas na demonstração da apresentação final (seção 7).
Teste o script do zero (banco vazio) antes de entregar, para garantir que ele executa sem erros.
________________________________________
4. Massa de Dados
(incluída no script ou em arquivo separado — parte da nota de Implementação SQL, 12%)
Se a massa de dados ficar em arquivo separado, ele deve seguir a mesma regra do script: um arquivo no formato .sql no repositório, de preferência na pasta docs (ex.: docs/massa_de_dados.sql), com link no README.
•	Dados reais da organização (nomes de clientes, fiéis, beneficiários, doadores, valores reais etc.) não devem ser utilizados, em respeito à privacidade dessas informações. A massa de dados deve ser fictícia, mas coerente com as operações modeladas (mesmos tipos de processo, volumes e regras observados na organização real).
•	Volume de registros coerente com a realidade da organização (nada de 3 linhas de exemplo — mas também nada artificialmente inflado sem sentido).
•	Explique como o volume real da organização — os números informados em Contexto e porte (seção 1.1), como clientes ativos, pedidos por mês, atendimentos por semana, itens no estoque — justifica a quantidade de registros de cada tabela da massa de dados.
•	Dados consistentes o suficiente para validar os processos organizacionais modelados (ex.: pedidos que referenciam clientes e produtos existentes, ou doações que referenciam doadores e campanhas existentes).
•	Variedade e quantidade coerentes com a organização, para que os testes sejam possíveis: os dados devem cobrir as situações reais — não só o caso comum, mas também pedidos cancelados, clientes sem compras, produtos abaixo do estoque mínimo, pagamentos em formas diferentes, registros em períodos diferentes. Sem essa variedade, as consultas gerenciais e de auditoria (seção 3) não têm o que mostrar: uma consulta de produtos abaixo do estoque mínimo que retorna vazio não demonstra nada.
•	Documente o uso de LLMs para gerar essa massa de dados na seção 6 (Uso de Inteligência Artificial), incluindo ferramentas, prompts e ajustes feitos manualmente.
________________________________________

5. Repositório GitHub
(vale 13% — Documentação e Repositório)
O repositório deve conter:
•	Relatório Técnico (no README.md)
•	Dicionário de Dados atualizado, no modelo do arquivo 02-03g_Exemplo_Dicionario_Dados.pdf e com as restrições de integridade de cada coluna (obrigatoriedade, unicidade, valores permitidos, valor padrão), em um único arquivo HTML no repositório. Exceção — turma de GTI: o dicionário é apresentado em um único arquivo Markdown (.md) separado do README, seguindo o mesmo modelo do 02-03g_Exemplo_Dicionario_Dados.pdf.
•	Diagramas (DER revisado e modelo lógico)
•	Levantamento (pasta levantamento, recomendada) e evidências da organização e da entrevista (fotos JPG ou PNG)
•	Script SQL completo em arquivo .sql (de preferência na pasta docs)
•	Histórico de commits que evidencie o desenvolvimento ao longo do tempo (evite um único commit final)
•	Evidências de colaboração entre os membros do grupo: é a listagem de commits do repositório, que deve estar equilibrada entre os integrantes — a quantidade de commits deve se distribuir de forma proporcional entre todos os membros do grupo, cada um fazendo commits com a própria conta do GitHub. O integrante precisa ser identificável na conta do GitHub: o nome configurado na conta deve ser compatível com o nome do aluno na tabela de Integrantes, onde também deve constar o usuário do GitHub de cada um
________________________________________
6. Uso de Inteligência Artificial
(documentação obrigatória — não é opcional se o grupo usou IA em qualquer etapa: pesquisa, levantamento de processos, requisitos e regras típicos, escrita, organização de ideias, revisão de texto, geração de massa de dados ou apoio a scripts SQL)
Para cada uso relevante de ferramenta de IA (ChatGPT, Claude, Gemini, Perplexity etc.), registre:
Item	O que registrar
Ferramenta e etapa	Qual IA foi usada e em qual parte do trabalho (ex.: normalização, geração da massa de dados, escrita de queries SQL, redação do relatório, preparação dos slides).
Motivação	Por que o grupo recorreu à IA nesse ponto específico.
Prompt(s) utilizados	Texto exato (ou muito próximo) do que foi perguntado/pedido à IA.
Resposta recebida	Resumo ou trecho relevante da resposta da IA.
Fontes consultadas e verificadas	Se a IA citou fontes/dados, quais foram checadas pelo grupo e como.
Trechos rejeitados ou corrigidos	O que da resposta da IA foi descartado, editado ou corrigido manualmente (ex.: query SQL ajustada, dado fictício alterado), e por quê.
Justificativa da escolha final	Por que o grupo manteve, adaptou ou rejeitou o que a IA sugeriu.
Reflexão crítica	Limites, vieses ou erros identificados no uso da IA nessa etapa (ex.: normalização incorreta sugerida pela IA, script SQL com erro de sintaxe, dado fictício incoerente com o volume real da organização).

Se o grupo não usou nenhuma ferramenta de IA em alguma dessas etapas, declare isso explicitamente.
Uso de IA observado e não declarado será penalizado.
Solicitei o auxílio do ChatGPT para desenvolver e organizar o trabalho, buscando orientações sobre sua estrutura, formatação e descrição das informações do projeto. A ferramenta foi utilizada como apoio para melhorar a clareza e a organização do conteúdo, mantendo as informações e decisões do trabalho desenvolvidas pelo grupo.
________________________________________
7. Apresentação Corporativa Final
(pitch cronometrado de 8 minutos — vale 15%, maior peso individual da Dimensão Procedimental)
Formato: slides com estética limpa e minimalista — proibida a leitura de blocos longos de texto.
O pitch deve conter, nesta ordem:
1.	Contextualização do problema institucional/organizacional solucionado
2.	Apresentação da solução proposta
3.	Apresentação do modelo lógico
4.	Demonstração da implementação (SQL rodando)
5.	Demonstração de consultas (gerenciais/auditoria)
6.	Potencial para BI e IA
7.	Benefícios diretos para a tomada de decisão da organização
Defesa do modelo lógico: logo após o pitch, fora do tempo cronometrado, o grupo responde às perguntas do professor e da turma. Cada pergunta deve ser respondida exclusivamente pelo aluno a quem foi dirigida — os colegas não podem responder por ele.
Regras da apresentação:
•	Participação: não é necessário e nem recomendável que todos os integrantes falem durante o pitch, mas é obrigatório que todos participem da apresentação e estejam presentes para a defesa.
•	Ausência: o integrante ausente na apresentação terá nota reduzida, exceto em casos com justificativa legal (ex.: doença que impeça o comparecimento, com atestado).
•	Apresentação pessoal: será avaliada. Postura e vestimenta adequadas a uma apresentação corporativa. Não são adequados bonés, bermudas, chinelos, camisas de time, roupas esportivas ou semelhantes.
________________________________________
Critérios Atitudinais (20%)
Estes critérios NÃO constam explicitamente como item de entrega nos artefatos do grupo. Eles são avaliados por meio de Avaliação 360º entre os integrantes do grupo (cada membro avalia os colegas de equipe) e, no caso da colaboração, também pela colaboração equilibrada no histórico de commits do repositório GitHub (Seção 5) e pela conduta do grupo na Apresentação Corporativa Final (seção 7) — não pela leitura do relatório:
•	Participação e colaboração (5%): participação técnica ativa + colaboração com o grupo, incluindo colaboração equilibrada no histórico de commits do repositório GitHub.
•	Responsabilidade (5%): cumprimento de prazos + entrega dos itens sob sua responsabilidade.
•	Postura profissional (5%): comunicação profissional + conduta ética.
•	Autonomia e resolução de problemas (5%): buscar soluções independentes + propor melhorias.
________________________________________
Resumo dos Pesos
Dimensão	Peso total	Itens principais
Conceitual	30%	Conversão conceitual→lógico (7,5%), Normalização (7,5%), Justificativas técnicas (7,5%), Análise BI/IA (7,5%)
Procedimental	50%	Modelo lógico (10%), Implementação SQL (12%), Documentação/repositório (13%), Apresentação final (15%)
Atitudinal	20%	Participação/colaboração, responsabilidade, postura profissional, autonomia

Entrega final: Relatório Técnico + Dicionário de Dados + Modelo Conceitual + Modelo Lógico + Script SQL + Massa de Dados + Repositório GitHub, seguidos da Apresentação Corporativa Final perante o professor e a turma.

