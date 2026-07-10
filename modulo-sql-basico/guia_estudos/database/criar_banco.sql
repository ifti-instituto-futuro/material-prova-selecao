-- =========================================================================
-- Script de Criacao do Banco de Dados CineVista
-- Objetivo: DDL completo das tabelas da Rede de Cinemas CineVista
-- =========================================================================

CREATE DATABASE CineVista;
GO

USE CineVista;
GO

-- 1. Tabela de Clientes
CREATE TABLE [dbo].[Cliente] (
    Id INT IDENTITY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Cidade VARCHAR(60) NOT NULL,
    DataCadastro DATE NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (Id)
);
GO

-- 2. Tabela de Catalogo de Filmes
CREATE TABLE [dbo].[Filme] (
    Id INT IDENTITY,
    Titulo VARCHAR(100) NOT NULL UNIQUE,
    Genero VARCHAR(40) NOT NULL,
    DuracaoMinutos INT NOT NULL,
    Classificacao VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Filme PRIMARY KEY (Id)
);
GO

-- 3. Tabela de Salas de Exibicao
CREATE TABLE [dbo].[Sala] (
    Id INT IDENTITY,
    Nome VARCHAR(30) NOT NULL UNIQUE,
    Capacidade INT NOT NULL,
    Tipo VARCHAR(10) NOT NULL, -- '2D', '3D' ou 'IMAX'
    CONSTRAINT PK_Sala PRIMARY KEY (Id)
);
GO

-- 4. Tabela de Sessoes (um filme exibido em uma sala, com data/hora e preco)
CREATE TABLE [dbo].[Sessao] (
    Id INT IDENTITY,
    IdFilme INT NOT NULL,
    IdSala INT NOT NULL,
    DataHora DATETIME NOT NULL,
    PrecoIngresso DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Sessao PRIMARY KEY (Id),
    CONSTRAINT FK_IdFilme_Sessao FOREIGN KEY (IdFilme) REFERENCES [dbo].[Filme] (Id),
    CONSTRAINT FK_IdSala_Sessao FOREIGN KEY (IdSala) REFERENCES [dbo].[Sala] (Id)
);
GO

-- 5. Tabela de Ingressos (venda de um lugar de uma sessao para um cliente)
CREATE TABLE [dbo].[Ingresso] (
    Id INT IDENTITY,
    IdSessao INT NOT NULL,
    IdCliente INT NOT NULL,
    DataCompra DATETIME NOT NULL,
    ValorPago DECIMAL(10,2) NOT NULL,
    MeiaEntrada BIT NOT NULL,
    CONSTRAINT PK_Ingresso PRIMARY KEY (Id),
    CONSTRAINT FK_IdSessao_Ingresso FOREIGN KEY (IdSessao) REFERENCES [dbo].[Sessao] (Id),
    CONSTRAINT FK_IdCliente_Ingresso FOREIGN KEY (IdCliente) REFERENCES [dbo].[Cliente] (Id)
);
GO
