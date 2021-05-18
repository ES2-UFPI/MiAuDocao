CREATE SCHEMA IF NOT EXISTS `miaudocao` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `miaudocao`;

CREATE TABLE animal (
	id VARCHAR(20) NOT NULL,
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
    foto BLOB
);