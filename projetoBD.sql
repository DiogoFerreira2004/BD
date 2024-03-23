DROP TABLE IF EXISTS Organizacao;
CREATE TABLE Organizacao(
    idOrganizacao numeric,
    nome varchar NOT NULL,
    regiao varchar,
    localizacao varchar,
    PRIMARY KEY (idOrganizacao)
);

DROP TABLE IF EXISTS Equipa;
CREATE TABLE Equipa(
    idEquipa numeric,
    nome varchar NOT NULL,
    organizacao numeric,
    PRIMARY KEY (idEquipa),
    FOREIGN KEY (organizacao) REFERENCES Organizacao(idOrganizacao)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Jogador;
CREATE TABLE Jogador(
    idJogador numeric,
    nome varchar NOT NULL,
    position varchar,
    nick varchar,
    dataNascimento varchar,
    nacionalidade varchar,
    residencia varchar,
    equipa numeric,
    PRIMARY KEY(idJogador),
    FOREIGN KEY (equipa) REFERENCES Equipa(idEquipa)
);

DROP TABLE IF EXISTS PeriodoContratacao;
CREATE TABLE PeriodoContratacao(
    idPeriodoContratacao numeric,
    dataInicio varchar,
    dataFim varchar check (julianday(dataFim) - julianday(dataInicio) > 0),
    PRIMARY KEY (idPeriodoContratacao)
);

DROP TABLE IF EXISTS Contrato;
CREATE TABLE Contrato(
    jogador numeric,
    periodoContratacao numeric,
    equipa numeric,
    inicio varchar,
    fim varchar check (julianday(fim) - julianday(inicio) > 0),
    PRIMARY KEY (jogador, periodoContratacao),
    FOREIGN KEY (jogador) REFERENCES Jogador(idJogador),
    FOREIGN KEY (periodoContratacao) REFERENCES PeriodoContratacao(idPeriodoContratacao)
    ON UPDATE CASCADE,
    FOREIGN KEY (equipa) REFERENCES Equipa(idEquipa)
);

DROP TABLE IF EXISTS Epoca;
CREATE TABLE Epoca(
    idEpoca numeric,
    ano numeric NOT NULL,
    periodoDeContratacao numeric,
    PRIMARY KEY (idEpoca),
    FOREIGN KEY (periodoDeContratacao) REFERENCES PeriodoContratacao(idPeriodoContratacao)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Competicao;
CREATE TABLE Competicao(
    idCompeticao numeric,
    nome varchar NOT NULL,
    tipo varchar,
    numJogos numeric,
    PRIMARY KEY (idCompeticao)
);

DROP TABLE IF EXISTS EquipaEpocaCompeticao;
CREATE TABLE EquipaEpocaCompeticao(
    equipa numeric,
    epoca numeric,
    competicao numeric,
    PRIMARY KEY (equipa, epoca, competicao),
    FOREIGN KEY (equipa) REFERENCES Equipa(idEquipa),
    FOREIGN KEY (epoca) REFERENCES Epoca(idEpoca),
    FOREIGN KEY (competicao) REFERENCES Competicao(idCompeticao)
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Arena;
CREATE TABLE Arena(
    idArena numeric,
    nome varchar NOT NULL,
    localizacao varchar,
    capacidade numeric,
    PRIMARY KEY (idArena)
);

DROP TABLE IF EXISTS Jogo;
CREATE TABLE Jogo(
    idJogo numeric,
    dataRealizacao varchar,
    tipo varchar(1) CHECK (tipo in ('1', '3', '5')) DEFAULT '1',
    resultadoFinal varchar,
    competicao numeric,
    arena numeric,
    blue numeric,
    red numeric,
    PRIMARY KEY (idJogo),
    FOREIGN KEY (competicao) REFERENCES Competicao(idCompeticao),
    FOREIGN KEY (arena) REFERENCES Arena(idArena),
    FOREIGN KEY (blue) REFERENCES Equipa(idEquipa),
    FOREIGN KEY (red) REFERENCES Equipa(idEquipa)
);

DROP TABLE IF EXISTS Partida;
CREATE TABLE Partida(
    idPartida numeric,
    resultado varchar,
    jogo numeric,
    PRIMARY KEY (idPartida),
    FOREIGN KEY (jogo) REFERENCES Jogo(idJogo)
);

DROP TABLE IF EXISTS ChampSelect;
CREATE TABLE ChampSelect(
    partida numeric,
    equipa numeric,
    pick varchar,
    ban varchar,
    runas varchar,
    PRIMARY KEY (partida, equipa),
    FOREIGN KEY (partida) REFERENCES Partida(idPartida),
    FOREIGN KEY (equipa) REFERENCES Equipa(idEquipa)
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Objetivo;
CREATE TABLE Objetivo(
    idObjetivo numeric,
    minuto numeric,
    partida numeric,
    destroi numeric,
    PRIMARY KEY (idObjetivo),
    FOREIGN KEY (partida) REFERENCES Partida(idPartida),
    FOREIGN KEY (destroi) REFERENCES Equipa(idEquipa)
);

DROP TABLE IF EXISTS Objetivo;
CREATE TABLE Objetivo(
    idObjetivo numeric,
    minuto numeric,
    partida numeric,
    mata numeric,
    morre numeric,
    assiste numeric,
    PRIMARY KEY (idObjetivo, assiste),
    FOREIGN KEY (assiste) REFERENCES Jogador(idJogador)
    FOREIGN KEY (partida) REFERENCES Partida(idPartida)
    FOREIGN KEY (mata) REFERENCES Jogador(idJogador),
    FOREIGN KEY (morre) REFERENCES Jogador(idJogador)
);