CREATE SCHEMA IF NOT EXISTS `miaudocao` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `miaudocao`;

CREATE TABLE usuario (
	id VARCHAR(20) NOT NULL,
	nome VARCHAR(50),
    foto MEDIUMBLOB,
    email VARCHAR(100),
    telefone VARCHAR(11),
    passwd varchar(100),
    data_cadastro long,
    pref_especie ENUM('cachorro', 'gato', 'coelho'),
    pref_porte ENUM('pequeno', 'médio', 'grande'),
    pref_sexo ENUM('macho', 'fêmea'),
    pref_faixa_etaria ENUM('filhote', 'jovem', 'adulto', 'idoso'),
    pref_raio_buca INT,
    PRIMARY KEY (id)
);

CREATE TABLE animal (
	id VARCHAR(20) NOT NULL,
    user_id VARCHAR(20) NOT NULL,
    nome VARCHAR(50),
    descricao VARCHAR(300),
    especie ENUM('cachorro', 'gato', 'coelho'),
    porte ENUM('pequeno', 'médio', 'grande'),
    sexo ENUM('macho', 'fêmea'),
    faixa_etaria ENUM('filhote', 'jovem', 'adulto', 'idoso'),
    endereco VARCHAR(100),
    latitude FLOAT(10, 8) NOT NULL,
    longitude FLOAT(11, 8) NOT NULL,
    data_cadastro long,
    foto MEDIUMBLOB,
	adotado BOOL,
    FOREIGN KEY (user_id) REFERENCES usuario(id)
);

CREATE TABLE interesse_animal (
    user_id VARCHAR(20) NOT NULL,
    animal_id VARCHAR(20) NOT NULL
);