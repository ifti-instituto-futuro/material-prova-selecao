-- =========================================================================
-- Script de Populacao do Banco de Dados CineVista
-- Objetivo: massa de dados ficticia para as aulas e exercicios do modulo
-- Observacao: os dados foram calibrados para que os exercicios de consulta
--             retornem resultados nao vazios (ha cliente sem ingresso,
--             filme sem sessao, precos variados e generos com volumes
--             distintos de publico).
-- =========================================================================

USE CineVista;
GO

-- 1. Clientes (os dois ultimos nunca compraram ingresso)
INSERT INTO [dbo].[Cliente] (Nome, Email, Cidade, DataCadastro) VALUES
('Ana Souza', 'ana.souza@email.com', 'Natal', '2025-11-10'),
('Bruno Lima', 'bruno.lima@email.com', 'Natal', '2025-12-02'),
('Carla Mendes', 'carla.mendes@email.com', 'Parnamirim', '2026-01-15'),
('Diego Rocha', 'diego.rocha@email.com', 'Natal', '2026-02-20'),
('Elisa Martins', 'elisa.martins@email.com', 'Mossoro', '2026-03-08'),
('Felipe Andrade', 'felipe.andrade@email.com', 'Natal', '2026-04-12'),
('Gabriela Nunes', 'gabriela.nunes@email.com', 'Parnamirim', '2026-05-25'),
('Henrique Prado', 'henrique.prado@email.com', 'Natal', '2026-06-18');
GO

-- 2. Filmes (os dois ultimos ainda nao possuem sessao programada)
INSERT INTO [dbo].[Filme] (Titulo, Genero, DuracaoMinutos, Classificacao) VALUES
('A Fortaleza de Areia', 'Aventura', 124, '12'),
('Circuito Fechado', 'Suspense', 108, '14'),
('Riso Franco', 'Comedia', 96, 'Livre'),
('Estrelas de Ferro', 'Ficcao Cientifica', 142, '12'),
('O Ultimo Vagao', 'Drama', 115, '16'),
('Operacao Meia-Noite', 'Acao', 130, '14'),
('Do Outro Lado do Rio', 'Drama', 102, '10'),
('Pequenos Gigantes', 'Animacao', 89, 'Livre');
GO

-- 3. Salas
INSERT INTO [dbo].[Sala] (Nome, Capacidade, Tipo) VALUES
('Sala 1', 120, '2D'),
('Sala 2', 100, '2D'),
('Sala 3', 80, '3D'),
('Sala IMAX', 60, 'IMAX');
GO

-- 4. Sessoes
INSERT INTO [dbo].[Sessao] (IdFilme, IdSala, DataHora, PrecoIngresso) VALUES
(1, 1, '2026-06-26 19:00', 28.00),  -- Sessao 1
(1, 4, '2026-06-26 21:30', 52.00),  -- Sessao 2
(2, 2, '2026-06-26 20:00', 26.00),  -- Sessao 3
(3, 1, '2026-06-27 15:00', 24.00),  -- Sessao 4
(3, 2, '2026-06-27 17:00', 24.00),  -- Sessao 5
(4, 3, '2026-06-27 19:30', 38.00),  -- Sessao 6
(4, 4, '2026-06-27 21:00', 55.00),  -- Sessao 7
(5, 2, '2026-06-28 18:00', 26.00),  -- Sessao 8
(6, 1, '2026-06-28 20:30', 30.00),  -- Sessao 9
(6, 3, '2026-06-28 21:00', 40.00),  -- Sessao 10
(1, 2, '2026-07-03 19:00', 28.00),  -- Sessao 11
(2, 1, '2026-07-03 21:00', 26.00),  -- Sessao 12
(4, 4, '2026-07-04 20:00', 55.00),  -- Sessao 13
(6, 4, '2026-07-04 22:00', 52.00),  -- Sessao 14
(3, 1, '2026-07-05 16:00', 24.00);  -- Sessao 15
GO

-- 5. Ingressos (ValorPago = PrecoIngresso, ou metade quando MeiaEntrada = 1)
INSERT INTO [dbo].[Ingresso] (IdSessao, IdCliente, DataCompra, ValorPago, MeiaEntrada) VALUES
-- Sessao 1 (28.00)
(1, 1, '2026-06-25 10:12', 28.00, 0),
(1, 2, '2026-06-25 11:40', 28.00, 0),
(1, 3, '2026-06-25 14:05', 14.00, 1),
(1, 4, '2026-06-26 09:30', 28.00, 0),
-- Sessao 2 (52.00)
(2, 1, '2026-06-25 10:15', 52.00, 0),
(2, 5, '2026-06-26 08:22', 26.00, 1),
(2, 6, '2026-06-26 12:47', 52.00, 0),
-- Sessao 3 (26.00)
(3, 2, '2026-06-25 16:00', 26.00, 0),
(3, 3, '2026-06-26 10:10', 26.00, 0),
-- Sessao 4 (24.00)
(4, 1, '2026-06-26 15:33', 12.00, 1),
(4, 2, '2026-06-26 15:35', 24.00, 0),
(4, 4, '2026-06-27 09:01', 24.00, 0),
(4, 5, '2026-06-27 10:20', 24.00, 0),
(4, 6, '2026-06-27 11:11', 12.00, 1),
-- Sessao 5 (24.00)
(5, 3, '2026-06-27 12:00', 24.00, 0),
(5, 4, '2026-06-27 13:45', 24.00, 0),
-- Sessao 6 (38.00)
(6, 1, '2026-06-27 08:50', 38.00, 0),
(6, 2, '2026-06-27 09:15', 19.00, 1),
(6, 5, '2026-06-27 14:30', 38.00, 0),
-- Sessao 7 (55.00)
(7, 4, '2026-06-27 16:05', 55.00, 0),
(7, 6, '2026-06-27 17:40', 55.00, 0),
-- Sessao 8 (26.00)
(8, 5, '2026-06-28 10:00', 26.00, 0),
-- Sessao 9 (30.00)
(9, 1, '2026-06-28 11:25', 30.00, 0),
(9, 2, '2026-06-28 12:30', 30.00, 0),
(9, 3, '2026-06-28 13:00', 15.00, 1),
(9, 6, '2026-06-28 14:10', 30.00, 0),
-- Sessao 10 (40.00)
(10, 4, '2026-06-28 15:55', 40.00, 0),
(10, 5, '2026-06-28 16:20', 40.00, 0),
-- Sessao 11 (28.00)
(11, 2, '2026-07-01 09:00', 28.00, 0),
(11, 3, '2026-07-01 09:45', 28.00, 0),
(11, 6, '2026-07-02 18:30', 28.00, 0),
-- Sessao 12 (26.00)
(12, 1, '2026-07-02 10:05', 26.00, 0),
(12, 4, '2026-07-02 11:50', 13.00, 1),
-- Sessao 13 (55.00)
(13, 2, '2026-07-03 08:40', 55.00, 0),
(13, 5, '2026-07-03 10:15', 55.00, 0),
(13, 6, '2026-07-03 19:00', 27.50, 1),
-- Sessao 14 (52.00)
(14, 1, '2026-07-04 09:30', 52.00, 0),
(14, 3, '2026-07-04 10:00', 52.00, 0),
-- Sessao 15 (24.00)
(15, 4, '2026-07-04 20:45', 24.00, 0),
(15, 5, '2026-07-05 08:10', 12.00, 1);
GO
