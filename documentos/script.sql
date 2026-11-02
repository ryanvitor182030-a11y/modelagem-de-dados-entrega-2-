MIT License

Copyright (c) 2026 Ryan Vitor 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-- ================================================================
-- Banco de dados: Marcenariarte Planejados
-- SGBD: MySQL 8.0.16 ou superior (por causa das restrições CHECK)
--
-- Escopo: clientes, projetos sob medida, etapas de produção,
-- profissionais de fabricação/montagem, planos de corte, sobras,
-- estoque, compras, fornecedores, pagamentos e notas fiscais.
--
-- Os registros abaixo são fictícios e servem apenas para demonstração.
-- Execute em um banco novo. Este script não apaga bancos existentes.
-- ================================================================

CREATE DATABASE IF NOT EXISTS marcenariarte
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE marcenariarte;

-- ================================================================
-- 1. ESTRUTURA DO BANCO (DDL)
-- ================================================================

CREATE TABLE cliente (
    id_cliente       INT AUTO_INCREMENT PRIMARY KEY,
    nome             VARCHAR(120) NOT NULL,
    telefone         VARCHAR(20),
    email            VARCHAR(150),
    cpf              VARCHAR(14) UNIQUE,
    endereco         VARCHAR(255),
    data_cadastro    DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE funcionario (
    id_funcionario  INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    email           VARCHAR(150) UNIQUE,
    telefone        VARCHAR(20),
    cargo           VARCHAR(30) NOT NULL,
    ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_funcionario_cargo CHECK (
        cargo IN ('PROPRIETARIO', 'VENDEDOR_PROJETISTA', 'COMPRADOR',
                  'MARCENEIRO', 'MONTADOR', 'ENTREGADOR')
    )
) ENGINE=InnoDB;

CREATE TABLE fornecedor (
    id_fornecedor  INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(120) NOT NULL,
    telefone       VARCHAR(20),
    email          VARCHAR(150),
    cnpj           VARCHAR(18) UNIQUE,
    endereco       VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE material (
    id_material       INT AUTO_INCREMENT PRIMARY KEY,
    nome              VARCHAR(120) NOT NULL,
    tipo_material     VARCHAR(60) NOT NULL,
    descricao         VARCHAR(255),
    unidade_medida    VARCHAR(20) NOT NULL,
    estoque_minimo    DECIMAL(10,2) NOT NULL DEFAULT 0,
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_material_estoque_minimo CHECK (estoque_minimo >= 0)
) ENGINE=InnoDB;

-- Quantidade de material novo disponível no galpão.
-- As sobras reaproveitáveis são controladas separadamente em sobra_material.
CREATE TABLE estoque_material (
    id_material          INT PRIMARY KEY,
    quantidade_disponivel DECIMAL(10,2) NOT NULL DEFAULT 0,
    data_atualizacao     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                         ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_estoque_quantidade CHECK (quantidade_disponivel >= 0),
    CONSTRAINT fk_estoque_material FOREIGN KEY (id_material)
        REFERENCES material(id_material)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE projeto (
    id_projeto          INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente          INT NOT NULL,
    id_vendedor         INT NOT NULL,
    descricao           VARCHAR(500) NOT NULL,
    data_inicio         DATE NOT NULL,
    prazo_previsto      DATE NOT NULL,
    valor_contratado    DECIMAL(12,2) NOT NULL,
    status_projeto      VARCHAR(20) NOT NULL DEFAULT 'ORCAMENTO',
    CONSTRAINT chk_projeto_valor CHECK (valor_contratado >= 0),
    CONSTRAINT chk_projeto_prazo CHECK (prazo_previsto >= data_inicio),
    CONSTRAINT chk_projeto_status CHECK (
        status_projeto IN ('ORCAMENTO', 'APROVADO', 'EM_PRODUCAO',
                           'PRONTO', 'EM_MONTAGEM', 'CONCLUIDO', 'CANCELADO')
    ),
    CONSTRAINT fk_projeto_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_projeto_vendedor FOREIGN KEY (id_vendedor)
        REFERENCES funcionario(id_funcionario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Uma linha representa o andamento de uma etapa de um projeto.
CREATE TABLE etapa_projeto (
    id_etapa          INT AUTO_INCREMENT PRIMARY KEY,
    id_projeto        INT NOT NULL,
    nome_etapa        VARCHAR(40) NOT NULL,
    status_etapa      VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    data_inicio       DATE,
    data_conclusao    DATE,
    observacao        VARCHAR(255),
    CONSTRAINT chk_etapa_status CHECK (
        status_etapa IN ('PENDENTE', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA')
    ),
    CONSTRAINT chk_etapa_datas CHECK (
        data_conclusao IS NULL OR data_inicio IS NULL OR data_conclusao >= data_inicio
    ),
    CONSTRAINT fk_etapa_projeto FOREIGN KEY (id_projeto)
        REFERENCES projeto(id_projeto)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE plano_corte (
    id_plano_corte  INT AUTO_INCREMENT PRIMARY KEY,
    id_projeto      INT NOT NULL,
    numero_plano    SMALLINT NOT NULL DEFAULT 1,
    data_criacao    DATE NOT NULL,
    descricao       VARCHAR(500),
    CONSTRAINT uq_plano_numero_projeto UNIQUE (id_projeto, numero_plano),
    -- Chave única composta para assegurar que uma sobra esteja vinculada
    -- ao mesmo projeto do plano de corte informado.
    CONSTRAINT uq_plano_id_projeto UNIQUE (id_plano_corte, id_projeto),
    CONSTRAINT chk_plano_numero CHECK (numero_plano > 0),
    CONSTRAINT fk_plano_projeto FOREIGN KEY (id_projeto)
        REFERENCES projeto(id_projeto)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Materiais previstos/liberados para cada plano de corte.
CREATE TABLE plano_corte_material (
    id_plano_corte       INT NOT NULL,
    id_material          INT NOT NULL,
    quantidade_prevista  DECIMAL(10,2) NOT NULL,
    quantidade_liberada  DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_plano_corte, id_material),
    CONSTRAINT chk_plano_material_quantidades CHECK (
        quantidade_prevista > 0 AND quantidade_liberada >= 0
    ),
    CONSTRAINT fk_pcm_plano FOREIGN KEY (id_plano_corte)
        REFERENCES plano_corte(id_plano_corte)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pcm_material FOREIGN KEY (id_material)
        REFERENCES material(id_material)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Registra retalhos/sobras para que possam ser consultados e reaproveitados.
CREATE TABLE sobra_material (
    id_sobra          INT AUTO_INCREMENT PRIMARY KEY,
    id_projeto        INT NOT NULL,
    id_plano_corte    INT NOT NULL,
    id_material       INT NOT NULL,
    quantidade        DECIMAL(10,2) NOT NULL,
    dimensoes         VARCHAR(120),
    data_registro     DATE NOT NULL,
    status_sobra      VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL',
    CONSTRAINT chk_sobra_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_sobra_status CHECK (
        status_sobra IN ('DISPONIVEL', 'RESERVADA', 'CONSUMIDA', 'DESCARTADA')
    ),
    CONSTRAINT fk_sobra_plano_projeto FOREIGN KEY (id_plano_corte, id_projeto)
        REFERENCES plano_corte(id_plano_corte, id_projeto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sobra_material FOREIGN KEY (id_material)
        REFERENCES material(id_material)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Registra quais profissionais atuaram em cada projeto e em qual atividade.
CREATE TABLE participacao_projeto (
    id_projeto        INT NOT NULL,
    id_funcionario    INT NOT NULL,
    atividade         VARCHAR(20) NOT NULL,
    data_inicio       DATE NOT NULL,
    data_fim          DATE,
    observacao        VARCHAR(255),
    PRIMARY KEY (id_projeto, id_funcionario, atividade),
    CONSTRAINT chk_participacao_atividade CHECK (
        atividade IN ('FABRICACAO', 'MONTAGEM')
    ),
    CONSTRAINT chk_participacao_datas CHECK (
        data_fim IS NULL OR data_fim >= data_inicio
    ),
    CONSTRAINT fk_participacao_projeto FOREIGN KEY (id_projeto)
        REFERENCES projeto(id_projeto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_participacao_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pedido_compra (
    id_pedido         INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor     INT NOT NULL,
    id_comprador      INT NOT NULL,
    data_pedido       DATE NOT NULL,
    data_prevista     DATE,
    data_recebimento  DATE,
    status_pedido     VARCHAR(20) NOT NULL DEFAULT 'SOLICITADO',
    observacao        VARCHAR(255),
    CONSTRAINT chk_pedido_status CHECK (
        status_pedido IN ('SOLICITADO', 'APROVADO', 'RECEBIDO', 'CANCELADO')
    ),
    CONSTRAINT chk_pedido_datas CHECK (
        data_prevista IS NULL OR data_prevista >= data_pedido
    ),
    CONSTRAINT fk_pedido_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor(id_fornecedor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_comprador FOREIGN KEY (id_comprador)
        REFERENCES funcionario(id_funcionario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Entidade associativa: um pedido pode conter vários materiais.
CREATE TABLE item_pedido_compra (
    id_pedido          INT NOT NULL,
    id_material        INT NOT NULL,
    quantidade         DECIMAL(10,2) NOT NULL,
    preco_unitario     DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_material),
    CONSTRAINT chk_item_pedido_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_item_pedido_preco CHECK (preco_unitario >= 0),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido_compra(id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_item_material FOREIGN KEY (id_material)
        REFERENCES material(id_material)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pagamento (
    id_pagamento       INT AUTO_INCREMENT PRIMARY KEY,
    id_projeto         INT NOT NULL,
    data_pagamento     DATE NOT NULL,
    valor              DECIMAL(12,2) NOT NULL,
    forma_pagamento    VARCHAR(20) NOT NULL,
    status_pagamento   VARCHAR(20) NOT NULL DEFAULT 'RECEBIDO',
    CONSTRAINT chk_pagamento_valor CHECK (valor > 0),
    CONSTRAINT chk_pagamento_forma CHECK (
        forma_pagamento IN ('PIX', 'DINHEIRO', 'CARTAO', 'TRANSFERENCIA', 'BOLETO')
    ),
    CONSTRAINT chk_pagamento_status CHECK (
        status_pagamento IN ('PENDENTE', 'RECEBIDO', 'ESTORNADO')
    ),
    CONSTRAINT fk_pagamento_projeto FOREIGN KEY (id_projeto)
        REFERENCES projeto(id_projeto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- A regra documentada prevê no máximo uma nota fiscal por projeto.
CREATE TABLE nota_fiscal (
    id_nota_fiscal   INT AUTO_INCREMENT PRIMARY KEY,
    id_projeto       INT NOT NULL UNIQUE,
    numero           VARCHAR(30) NOT NULL,
    serie            VARCHAR(10),
    data_emissao     DATE NOT NULL,
    valor            DECIMAL(12,2) NOT NULL,
    status_nota      VARCHAR(20) NOT NULL DEFAULT 'EMITIDA',
    CONSTRAINT uq_nota_numero_serie UNIQUE (numero, serie),
    CONSTRAINT chk_nota_valor CHECK (valor >= 0),
    CONSTRAINT chk_nota_status CHECK (status_nota IN ('EMITIDA', 'CANCELADA')),
    CONSTRAINT fk_nota_projeto FOREIGN KEY (id_projeto)
        REFERENCES projeto(id_projeto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ================================================================
-- 2. MASSA DE DADOS FICTÍCIA (DML)
-- Os nomes, contatos e valores abaixo são ilustrativos.
-- ================================================================

INSERT INTO cliente (id_cliente, nome, telefone, email, endereco) VALUES
(1, 'Cliente Ficticio Um', '(11) 90000-0001', 'cliente1@example.com', 'Rua das Flores, 100'),
(2, 'Cliente Ficticio Dois', '(11) 90000-0002', 'cliente2@example.com', 'Av. Central, 250'),
(3, 'Cliente Ficticio Tres', '(11) 90000-0003', 'cliente3@example.com', 'Rua do Lago, 75'),
(4, 'Cliente Ficticio Quatro', '(11) 90000-0004', 'cliente4@example.com', 'Rua das Palmeiras, 40'),
(5, 'Cliente Ficticio Cinco', '(11) 90000-0005', 'cliente5@example.com', 'Av. Norte, 510'),
(6, 'Cliente Ficticio Seis', '(11) 90000-0006', 'cliente6@example.com', 'Rua do Bosque, 18');

INSERT INTO funcionario (id_funcionario, nome, email, telefone, cargo) VALUES
(1, 'Alex Proprietario Ficticio', 'alex@example.com', '(11) 91111-0001', 'PROPRIETARIO'),
(2, 'Bianca Vendedora Ficticia', 'bianca@example.com', '(11) 91111-0002', 'VENDEDOR_PROJETISTA'),
(3, 'Caio Comprador Ficticio', 'caio@example.com', '(11) 91111-0003', 'COMPRADOR'),
(4, 'Davi Marceneiro Ficticio', 'davi@example.com', '(11) 91111-0004', 'MARCENEIRO'),
(5, 'Eva Marceneira Ficticia', 'eva@example.com', '(11) 91111-0005', 'MARCENEIRO'),
(6, 'Fabio Montador Ficticio', 'fabio@example.com', '(11) 91111-0006', 'MONTADOR'),
(7, 'Gi Montadora Ficticia', 'gi@example.com', '(11) 91111-0007', 'MONTADOR'),
(8, 'Heitor Entregador Ficticio', 'heitor@example.com', '(11) 91111-0008', 'ENTREGADOR');

INSERT INTO fornecedor (id_fornecedor, nome, telefone, email, cnpj, endereco) VALUES
(1, 'Madeireira Exemplo', '(11) 92222-0001', 'vendas@madeireira.example', NULL, 'Rua Industrial, 300'),
(2, 'Ferragens Exemplo', '(11) 92222-0002', 'contato@ferragens.example', NULL, 'Av. das Oficinas, 90');

INSERT INTO material (id_material, nome, tipo_material, descricao, unidade_medida, estoque_minimo) VALUES
(1, 'MDF Branco 18 mm', 'PAINEL', 'Chapa branca para mobiliario planejado', 'CHAPA', 10),
(2, 'MDF Amadeirado 18 mm', 'PAINEL', 'Chapa amadeirada para mobiliario planejado', 'CHAPA', 6),
(3, 'Fita de borda branca', 'ACABAMENTO', 'Fita para acabamento das bordas', 'METRO', 100),
(4, 'Dobradiça com amortecedor', 'FERRAGEM', 'Dobradiça para portas de armario', 'UNIDADE', 30),
(5, 'Corrediça telescopica', 'FERRAGEM', 'Par de corredicas para gaveta', 'PAR', 12);

INSERT INTO estoque_material (id_material, quantidade_disponivel) VALUES
(1, 12), (2, 4), (3, 140), (4, 25), (5, 14);

INSERT INTO projeto
(id_projeto, id_cliente, id_vendedor, descricao, data_inicio, prazo_previsto, valor_contratado, status_projeto)
VALUES
(1, 1, 2, 'Cozinha planejada em MDF branco', '2026-10-02', '2026-10-25', 12400.00, 'CONCLUIDO'),
(2, 2, 2, 'Guarda-roupa planejado para dormitorio', '2026-10-06', '2026-11-15', 18300.00, 'EM_MONTAGEM'),
(3, 3, 2, 'Gabinete e armario para banheiro', '2026-10-11', '2026-11-20', 9950.00, 'EM_PRODUCAO'),
(4, 4, 2, 'Armarios planejados para escritorio', '2026-10-14', '2026-11-25', 15750.00, 'APROVADO'),
(5, 5, 2, 'Painel de sala e rack sob medida', '2026-10-18', '2026-12-01', 21600.00, 'ORCAMENTO'),
(6, 6, 2, 'Balcao comercial sob medida', '2026-10-22', '2026-11-30', 7800.00, 'CANCELADO');

INSERT INTO etapa_projeto
(id_etapa, id_projeto, nome_etapa, status_etapa, data_inicio, data_conclusao, observacao)
VALUES
(1, 1, 'PLANEJAMENTO', 'CONCLUIDA', '2026-10-02', '2026-10-03', NULL),
(2, 1, 'CORTE', 'CONCLUIDA', '2026-10-04', '2026-10-06', NULL),
(3, 1, 'FABRICACAO', 'CONCLUIDA', '2026-10-07', '2026-10-16', NULL),
(4, 1, 'ACABAMENTO', 'CONCLUIDA', '2026-10-17', '2026-10-19', NULL),
(5, 1, 'MONTAGEM', 'CONCLUIDA', '2026-10-22', '2026-10-24', NULL),
(6, 2, 'PLANEJAMENTO', 'CONCLUIDA', '2026-10-06', '2026-10-08', NULL),
(7, 2, 'FABRICACAO', 'CONCLUIDA', '2026-10-09', '2026-10-29', NULL),
(8, 2, 'MONTAGEM', 'EM_ANDAMENTO', '2026-11-02', NULL, NULL),
(9, 3, 'PLANEJAMENTO', 'CONCLUIDA', '2026-10-11', '2026-10-12', NULL),
(10, 3, 'CORTE', 'EM_ANDAMENTO', '2026-10-20', NULL, NULL),
(11, 4, 'PLANEJAMENTO', 'PENDENTE', NULL, NULL, NULL),
(12, 5, 'ORCAMENTO', 'EM_ANDAMENTO', '2026-10-18', NULL, NULL),
(13, 6, 'CANCELAMENTO', 'CANCELADA', '2026-10-22', NULL, NULL);

INSERT INTO plano_corte (id_plano_corte, id_projeto, numero_plano, data_criacao, descricao) VALUES
(1, 1, 1, '2026-10-03', 'Plano de corte da cozinha'),
(2, 2, 1, '2026-10-08', 'Plano de corte do guarda-roupa'),
(3, 3, 1, '2026-10-12', 'Plano de corte do gabinete'),
(4, 4, 1, '2026-10-20', 'Plano preliminar do escritorio');

INSERT INTO plano_corte_material (id_plano_corte, id_material, quantidade_prevista, quantidade_liberada) VALUES
(1, 1, 5.00, 5.00), (1, 3, 35.00, 35.00), (1, 4, 8.00, 8.00),
(2, 2, 7.00, 7.00), (2, 3, 42.00, 42.00), (2, 5, 6.00, 6.00),
(3, 1, 2.00, 1.00), (3, 3, 18.00, 10.00), (3, 4, 4.00, 2.00),
(4, 1, 4.00, 0.00), (4, 4, 6.00, 0.00);

INSERT INTO sobra_material
(id_sobra, id_projeto, id_plano_corte, id_material, quantidade, dimensoes, data_registro, status_sobra)
VALUES
(1, 1, 1, 1, 1.50, '120 x 40 cm', '2026-10-19', 'DISPONIVEL'),
(2, 2, 2, 2, 0.75, '90 x 35 cm', '2026-10-30', 'DISPONIVEL'),
(3, 2, 2, 3, 12.00, 'Rolo parcial', '2026-10-30', 'DISPONIVEL'),
(4, 3, 3, 1, 0.50, '60 x 30 cm', '2026-10-21', 'RESERVADA'),
(5, 1, 1, 4, 2.00, 'Unidades sem uso', '2026-10-24', 'DISPONIVEL');

INSERT INTO participacao_projeto
(id_projeto, id_funcionario, atividade, data_inicio, data_fim, observacao)
VALUES
(1, 4, 'FABRICACAO', '2026-10-04', '2026-10-19', 'Fabricacao e acabamento'),
(1, 5, 'FABRICACAO', '2026-10-04', '2026-10-19', 'Apoio na fabricacao'),
(1, 6, 'MONTAGEM', '2026-10-22', '2026-10-24', NULL),
(2, 4, 'FABRICACAO', '2026-10-09', '2026-10-29', NULL),
(2, 7, 'MONTAGEM', '2026-11-02', NULL, NULL),
(3, 5, 'FABRICACAO', '2026-10-20', NULL, NULL),
(4, 4, 'FABRICACAO', '2026-10-21', NULL, 'Aguardando liberacao da producao');

INSERT INTO pedido_compra
(id_pedido, id_fornecedor, id_comprador, data_pedido, data_prevista, data_recebimento, status_pedido, observacao)
VALUES
(1, 1, 3, '2026-10-01', '2026-10-04', '2026-10-03', 'RECEBIDO', 'Compra de chapas para projetos'),
(2, 2, 3, '2026-10-12', '2026-10-17', '2026-10-16', 'RECEBIDO', 'Reposicao de ferragens'),
(3, 1, 3, '2026-10-25', '2026-10-30', NULL, 'CANCELADO', 'Pedido cancelado antes da entrega');

INSERT INTO item_pedido_compra (id_pedido, id_material, quantidade, preco_unitario) VALUES
(1, 1, 10.00, 320.00), (1, 2, 5.00, 350.00),
(2, 4, 20.00, 18.50), (2, 5, 10.00, 42.00),
(3, 1, 2.00, 325.00);

INSERT INTO pagamento
(id_pagamento, id_projeto, data_pagamento, valor, forma_pagamento, status_pagamento)
VALUES
(1, 1, '2026-10-03', 6200.00, 'PIX', 'RECEBIDO'),
(2, 1, '2026-10-24', 6200.00, 'TRANSFERENCIA', 'RECEBIDO'),
(3, 2, '2026-10-07', 9000.00, 'PIX', 'RECEBIDO'),
(4, 3, '2026-10-13', 3000.00, 'CARTAO', 'RECEBIDO'),
(5, 4, '2026-10-20', 5000.00, 'BOLETO', 'PENDENTE');

INSERT INTO nota_fiscal
(id_nota_fiscal, id_projeto, numero, serie, data_emissao, valor, status_nota)
VALUES
(1, 1, 'NF-DEMO-0001', '1', '2026-10-25', 12400.00, 'EMITIDA');

-- ================================================================
-- 3. SELECTs COM JOIN (consultas operacionais)
-- ================================================================

-- Projetos com cliente, vendedor e situação atual.
SELECT p.id_projeto, c.nome AS cliente, f.nome AS vendedor,
       p.descricao, p.data_inicio, p.prazo_previsto,
       p.valor_contratado, p.status_projeto
FROM projeto AS p
JOIN cliente AS c ON c.id_cliente = p.id_cliente
JOIN funcionario AS f ON f.id_funcionario = p.id_vendedor
ORDER BY p.data_inicio;

-- Materiais previstos em cada plano de corte.
SELECT pc.id_plano_corte, pc.id_projeto, m.nome AS material,
       pcm.quantidade_prevista, pcm.quantidade_liberada, m.unidade_medida
FROM plano_corte AS pc
JOIN plano_corte_material AS pcm ON pcm.id_plano_corte = pc.id_plano_corte
JOIN material AS m ON m.id_material = pcm.id_material
ORDER BY pc.id_projeto, m.nome;

-- ================================================================
-- 4. ATUALIZAÇÃO (exemplo de mudança de andamento)
-- ================================================================
-- Exemplo: projeto 4 foi aprovado e iniciou a produção.
UPDATE projeto
SET status_projeto = 'EM_PRODUCAO'
WHERE id_projeto = 4
  AND status_projeto = 'APROVADO';

-- ================================================================
-- 5. EXCLUSÃO SEGURA (demonstração)
-- ================================================================
-- A transação demonstra como excluir um pedido cancelado e seus itens,
-- mas termina com ROLLBACK para preservar a massa de dados de exemplo.
START TRANSACTION;
DELETE FROM pedido_compra
WHERE id_pedido = 3
  AND status_pedido = 'CANCELADO';
ROLLBACK;

-- ================================================================
-- 6. CONSULTAS GERENCIAIS
-- ================================================================

-- G01 — Quais são os valores contratados, faturados e recebidos por projeto?
-- Atendimento: P1 (divergências entre contrato, pagamento e nota fiscal).
SELECT p.id_projeto, c.nome AS cliente, p.status_projeto,
       p.valor_contratado,
       COALESCE(nf.valor_faturado, 0) AS valor_faturado,
       COALESCE(pg.total_pago, 0) AS valor_pago,
       p.valor_contratado - COALESCE(pg.total_pago, 0) AS saldo_a_receber,
       nf.numero AS numero_nota,
       nf.status_nota
FROM projeto AS p
JOIN cliente AS c ON c.id_cliente = p.id_cliente
LEFT JOIN nota_fiscal AS nf ON nf.id_projeto = p.id_projeto
LEFT JOIN (
    SELECT id_projeto, SUM(valor) AS total_pago
    FROM pagamento
    WHERE status_pagamento = 'RECEBIDO'
    GROUP BY id_projeto
) AS pg ON pg.id_projeto = p.id_projeto
ORDER BY p.id_projeto;

-- G02 — Quais profissionais participaram da fabricação ou montagem de cada projeto?
-- Atendimento: P2 (rastreabilidade da equipe e das responsabilidades).
SELECT p.id_projeto, p.descricao, pp.atividade,
       GROUP_CONCAT(f.nome ORDER BY f.nome SEPARATOR ', ') AS profissionais,
       MIN(pp.data_inicio) AS inicio_atividade,
       MAX(pp.data_fim) AS fim_atividade
FROM projeto AS p
JOIN participacao_projeto AS pp ON pp.id_projeto = p.id_projeto
JOIN funcionario AS f ON f.id_funcionario = pp.id_funcionario
GROUP BY p.id_projeto, p.descricao, pp.atividade
ORDER BY p.id_projeto, pp.atividade;

-- G03 — Quais sobras reaproveitáveis e materiais disponíveis existem?
-- Atendimento: P3 (visibilidade do estoque e redução de compras duplicadas).
SELECT m.id_material, m.nome, m.unidade_medida,
       em.quantidade_disponivel AS material_novo,
       COALESCE(sm.quantidade_sobra, 0) AS sobras_disponiveis,
       em.quantidade_disponivel + COALESCE(sm.quantidade_sobra, 0) AS total_disponivel,
       m.estoque_minimo
FROM material AS m
JOIN estoque_material AS em ON em.id_material = m.id_material
LEFT JOIN (
    SELECT id_material, SUM(quantidade) AS quantidade_sobra
    FROM sobra_material
    WHERE status_sobra = 'DISPONIVEL'
    GROUP BY id_material
) AS sm ON sm.id_material = m.id_material
WHERE m.ativo = TRUE
ORDER BY m.nome;

-- G04 — Quem solicitou cada compra, de qual fornecedor, por qual valor e quando chegou?
-- Atendimento: P4 (rastreabilidade de comprador, fornecedor, materiais e preços).
SELECT pc.id_pedido, pc.data_pedido, pc.data_prevista, pc.data_recebimento,
       pc.status_pedido, f.nome AS fornecedor, comp.nome AS comprador,
       COUNT(ip.id_material) AS quantidade_de_materiais,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS valor_total_pedido,
       DATEDIFF(pc.data_recebimento, pc.data_pedido) AS dias_ate_recebimento
FROM pedido_compra AS pc
JOIN fornecedor AS f ON f.id_fornecedor = pc.id_fornecedor
JOIN funcionario AS comp ON comp.id_funcionario = pc.id_comprador
LEFT JOIN item_pedido_compra AS ip ON ip.id_pedido = pc.id_pedido
GROUP BY pc.id_pedido, pc.data_pedido, pc.data_prevista, pc.data_recebimento,
         pc.status_pedido, f.nome, comp.nome
ORDER BY pc.data_pedido;

-- G05 — Em que situação estão os projetos e suas etapas de produção/montagem?
-- Atendimento: P5 (acompanhamento do andamento e dos prazos dos pedidos).
SELECT p.id_projeto, c.nome AS cliente, p.descricao,
       p.status_projeto, p.prazo_previsto,
       COUNT(ep.id_etapa) AS total_etapas,
       SUM(ep.status_etapa = 'CONCLUIDA') AS etapas_concluidas,
       SUM(ep.status_etapa IN ('PENDENTE', 'EM_ANDAMENTO')) AS etapas_abertas,
       GROUP_CONCAT(CONCAT(ep.nome_etapa, ': ', ep.status_etapa)
                    ORDER BY ep.id_etapa SEPARATOR ' | ') AS andamento_detalhado
FROM projeto AS p
JOIN cliente AS c ON c.id_cliente = p.id_cliente
LEFT JOIN etapa_projeto AS ep ON ep.id_projeto = p.id_projeto
GROUP BY p.id_projeto, c.nome, p.descricao, p.status_projeto, p.prazo_previsto
ORDER BY p.prazo_previsto;

-- G06 — Quantos projetos foram registrados por mês?
-- KPI: quantidade de projetos por mês.
SELECT DATE_FORMAT(data_inicio, '%Y-%m') AS mes,
       COUNT(*) AS quantidade_projetos
FROM projeto
GROUP BY DATE_FORMAT(data_inicio, '%Y-%m')
ORDER BY mes;

-- G07 — Qual o valor total contratado por mês?
-- KPI: soma dos valores contratados por período.
SELECT DATE_FORMAT(data_inicio, '%Y-%m') AS mes,
       SUM(valor_contratado) AS valor_total_contratado
FROM projeto
WHERE status_projeto <> 'CANCELADO'
GROUP BY DATE_FORMAT(data_inicio, '%Y-%m')
ORDER BY mes;

-- G08 — Quanto foi efetivamente recebido em pagamentos por mês?
-- KPI: total de pagamentos recebidos por período.
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       SUM(valor) AS total_recebido
FROM pagamento
WHERE status_pagamento = 'RECEBIDO'
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
ORDER BY mes;

-- G09 — Quantos pedidos de compra foram feitos e qual o tempo médio de recebimento?
-- KPI: quantidade de pedidos e média de dias entre pedido e recebimento.
SELECT DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
       COUNT(*) AS quantidade_pedidos,
       SUM(status_pedido = 'RECEBIDO') AS pedidos_recebidos,
       AVG(CASE WHEN data_recebimento IS NOT NULL
                THEN DATEDIFF(data_recebimento, data_pedido) END) AS media_dias_recebimento
FROM pedido_compra
GROUP BY DATE_FORMAT(data_pedido, '%Y-%m')
ORDER BY mes;

-- G10 — Quais materiais estão abaixo do estoque mínimo, contando as sobras disponíveis?
-- KPI: materiais disponíveis abaixo do nível mínimo.
SELECT m.id_material, m.nome, m.unidade_medida, m.estoque_minimo,
       em.quantidade_disponivel + COALESCE(sm.quantidade_sobra, 0) AS total_disponivel
FROM material AS m
JOIN estoque_material AS em ON em.id_material = m.id_material
LEFT JOIN (
    SELECT id_material, SUM(quantidade) AS quantidade_sobra
    FROM sobra_material
    WHERE status_sobra = 'DISPONIVEL'
    GROUP BY id_material
) AS sm ON sm.id_material = m.id_material
WHERE em.quantidade_disponivel + COALESCE(sm.quantidade_sobra, 0) < m.estoque_minimo
ORDER BY total_disponivel;

-- ================================================================
-- 7. CONSULTAS DE AUDITORIA / REGRAS DE NEGÓCIO
-- ================================================================

-- A01 — Existe projeto concluído sem nota fiscal emitida?
-- Verifica: RN04 (projeto concluído deve ter nota fiscal vinculada).
SELECT p.id_projeto, p.descricao, p.status_projeto
FROM projeto AS p
LEFT JOIN nota_fiscal AS nf
       ON nf.id_projeto = p.id_projeto AND nf.status_nota = 'EMITIDA'
WHERE p.status_projeto = 'CONCLUIDO'
  AND nf.id_nota_fiscal IS NULL;

-- A02 — Há profissional registrado em atividade incompatível com seu cargo?
-- Verifica: RN09 (fabricação deve ser atribuída a marceneiro; montagem a montador).
SELECT p.id_projeto, f.nome, f.cargo, pp.atividade
FROM participacao_projeto AS pp
JOIN funcionario AS f ON f.id_funcionario = pp.id_funcionario
JOIN projeto AS p ON p.id_projeto = pp.id_projeto
WHERE (pp.atividade = 'FABRICACAO' AND f.cargo <> 'MARCENEIRO')
   OR (pp.atividade = 'MONTAGEM' AND f.cargo <> 'MONTADOR');

-- A03 — Há sobras marcadas como disponíveis sem quantidade positiva?
-- Verifica: RN10 (sobra reaproveitável deve ter quantidade maior que zero).
-- A restrição CHECK também impede esse dado durante a inserção/atualização.
SELECT id_sobra, id_material, quantidade, status_sobra
FROM sobra_material
WHERE status_sobra = 'DISPONIVEL'
  AND quantidade <= 0;

-- A04 — Existe pedido de compra sem nenhum item de material?
-- Verifica: RN11 (pedido de compra deve conter pelo menos um item).
SELECT pc.id_pedido, pc.data_pedido, pc.status_pedido
FROM pedido_compra AS pc
LEFT JOIN item_pedido_compra AS ip ON ip.id_pedido = pc.id_pedido
WHERE ip.id_pedido IS NULL;

-- A05 — Há projetos vencidos que ainda não foram concluídos nem cancelados?
-- Verifica: RN12 (projetos em aberto com prazo vencido devem ser identificados).
SELECT id_projeto, descricao, status_projeto, prazo_previsto
FROM projeto
WHERE prazo_previsto < CURRENT_DATE
  AND status_projeto NOT IN ('CONCLUIDO', 'CANCELADO');

-- A06 — Há pagamentos recebidos acima do valor contratado do projeto?
-- Verifica: RN05 (o total recebido não deve superar o valor contratado sem revisão).
SELECT p.id_projeto, p.valor_contratado, SUM(pg.valor) AS total_recebido
FROM projeto AS p
JOIN pagamento AS pg ON pg.id_projeto = p.id_projeto
WHERE pg.status_pagamento = 'RECEBIDO'
GROUP BY p.id_projeto, p.valor_contratado
HAVING SUM(pg.valor) > p.valor_contratado;

-- Fim do script.
