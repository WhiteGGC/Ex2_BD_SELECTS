CREATE DATABASE ex2selects
GO
USE ex2selects

CREATE TABLE filme(
	id			INT			NOT NULL,
	titulo		VARCHAR(40)	NOT NULL,
	ano			INT	NULL		CHECK(ano < 2021),
	PRIMARY KEY(id)
)

CREATE TABLE estrela(
	id			INT			NOT NULL,
	nome		VARCHAR(50)	NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE filme_estrela(
	filmeid		INT			NOT NULL,
	estrelaid	INT			NOT NULL,
	PRIMARY KEY (filmeid, estrelaid),
	FOREIGN KEY (filmeid)		REFERENCES filme(id),
	FOREIGN KEY (estrelaid)		REFERENCES estrela(id)
)

CREATE TABLE dvd(
	num			INT			NOT NULL,
	data_fabricacao	DATETIME	NOT NULL	CHECK(data_fabricacao <	GETDATE()),
	filmeid		INT			NOT NULL,
	PRIMARY KEY (num),
	FOREIGN KEY (filmeid) REFERENCES filme(id)
)

CREATE TABLE cliente(
	num_cadastro		INT			NOT NULL,
	nome	VARCHAR(70)	NOT NULL,
	logradouro	VARCHAR(150)	NOT NULL,
	num		INT		NOT NULL	CHECK(num > 0),
	cep		VARCHAR(8)	NULL	CHECK(LEN(cep) = 8),
	PRIMARY KEY (num_cadastro)
)

CREATE TABLE locacao(
	dvdnum		INT		NOT NULL,
	clientenum_cadastro		INT		NOT NULL,
	data_locacao	DATETIME	NOT NULL	DEFAULT(GETDATE()),
	data_devolucao		DATETIME	NOT NULL,
	valor	DECIMAL(7, 2)	NOT NULL	CHECK(valor > 0),
	PRIMARY	KEY (data_locacao, dvdnum, clientenum_cadastro),
	FOREIGN KEY (dvdnum) REFERENCES dvd(num),
	FOREIGN KEY (clientenum_cadastro) REFERENCES cliente(num_cadastro),
	CONSTRAINT chk_dt CHECK (data_devolucao > data_locacao)
)

ALTER TABLE estrela
ADD nome_real VARCHAR(50) NULL

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL 

INSERT INTO filme (id, titulo, ano) VALUES
	(1001, 'Whiplash', 2015),
	(1002, 'Birdman', 2015),
	(1003, 'Interestelar', 2014),
	(1004, 'A Culpa é das estrelas', 2014),
	(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
	(1006, 'Sing', 2016)

INSERT INTO estrela (id, nome, nome_real) VALUES
	(9901, 'Michael Keaton', 'Michael John Douglas'),
	(9902, 'Emma Stone Emily', 'Jean Stone'),
	(9903, 'Miles Teller', NULL),
	(9904, 'Steve Carell', 'Steven John Carell'),
	(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela (filmeid, estrelaid) VALUES
	(1002, 9901),
	(1002, 9902),
	(1001, 9903),
	(1005, 9904),
	(1005, 9905)

INSERT INTO	dvd VALUES
	(10001, '2020-02-12', 1001),
	(10002, '2019-18-10', 1002),
	(10003, '2020-03-04', 1003),
	(10004, '2020-02-12', 1001),
	(10005, '2019-18-10', 1004),
	(10006, '2020-03-04', 1002),
	(10007, '2020-02-12', 1005),
	(10008, '2019-18-10', 1002),
	(10009, '2020-03-04', 1003)

INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
	(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
	(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
	(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
	(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
	(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO locacao VALUES
	(10001, 5502, '2021-18-02', '2021-21-02', 3.50),
	(10009, 5502, '2021-18-02', '2021-21-02', 3.50),
	(10002, 5503, '2021-18-02', '2021-19-02', 3.50),
	(10002, 5505, '2021-20-02', '2021-23-02', 3.00),
	(10004, 5505, '2021-20-02', '2021-23-02', 3.00),
	(10005, 5505, '2021-20-02', '2021-23-02', 3.00),
	(10001, 5501, '2021-24-02', '2021-26-02', 3.50),
	(10008, 5501, '2021-24-02', '2021-26-02', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-18-02' AND clientenum_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-24-02' AND clientenum_cadastro = 5501

UPDATE dvd
SET data_fabricacao = '2019-14-07'
WHERE num = 10005

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'

/*1*/
SELECT titulo FROM filme WHERE ano = 2014

/*2*/
SELECT id, ano FROM filme WHERE titulo = 'Birdman'

/*3*/
SELECT id, ano FROM filme WHERE titulo LIKE '%plash%'

/*4*/
SELECT id, nome, nome_real FROM estrela
WHERE nome LIKE '%Steve%'

/*5*/
SELECT filmeid, CONVERT(VARCHAR(11), data_fabricacao, 103) AS 'fab' FROM dvd
WHERE data_fabricacao > '01-01-2020'

/*6*/
SELECT dvdnum, CONVERT(VARCHAR(11), data_locacao, 103) as 'Data Locação', CONVERT(VARCHAR(11), data_devolucao, 103) AS 'Data Devolução', valor, (valor+2.00) AS 'com multa'
FROM locacao WHERE clientenum_cadastro = 5505

/*7*/
SELECT logradouro, num, cep FROM cliente
WHERE nome = 'Matilde Luz'

/*8*/
SELECT nome_real FROM estrela
WHERE nome = 'Michael Keaton'

/*9*/
SELECT num_cadastro, nome, (logradouro + ' ' + CAST(num as VARCHAR(3)) +', '+cep) AS end_comp
FROM cliente WHERE num_cadastro >= 5503