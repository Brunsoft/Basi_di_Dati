/* create_tables.sql */

/* elimino le tabelle se sono già state create */
DROP TABLE persona;
DROP TABLE impianto;
DROP TABLE piscina;
DROP TABLE cliente;
DROP TABLE biglietto;
DROP TABLE giorno;
DROP TABLE iscritto;
DROP TABLE turno;
DROP TABLE ingresso;

/* creo le tabelle */
CREATE TABLE Impianto (
  nome VARCHAR(30) PRIMARY KEY,
  dataApertura DATE NOT NULL,
  dataChiusura DATE NOT NULL,
  comune VARCHAR(30) NOT NULL,
  indirizzo VARCHAR(30) NOT NULL
);

CREATE TABLE Giorno (
  data DATE,
  nomeImpianto VARCHAR(30) REFERENCES Impianto(nome) ON DELETE CASCADE ON UPDATE CASCADE,
  oraApertura TIME NOT NULL,
  oraChiusura TIME NOT NULL,
  numeroIngressi INTEGER,
  PRIMARY KEY(data, nomeImpianto),
  CHECK(numeroIngressi >= 0)
);

CREATE TABLE Piscina (
  codice SERIAL,
  dataApertura DATE,
  dataChiusura DATE,
  oraApertura TIME NOT NULL,
  oraChiusura TIME NOT NULL,
  tipo CHAR NOT NULL,
  /* Il tipo di piscina puo essere:
	v = 25m
	c = 50m
	t = tuffi
	b = bambini
  */
  nomeImpianto VARCHAR(30) REFERENCES Impianto(nome) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY(codice, dataApertura, dataChiusura),
  CHECK(tipo IN ('v', 'c', 't', 'b'))
);

CREATE TABLE Persona (
  matricola SERIAL PRIMARY KEY,
  nome VARCHAR(20) NOT NULL,
  cognome VARCHAR(20) NOT NULL,
  dataNascita DATE NOT NULL,
  PW VARCHAR(20) NOT NULL,
  LavoraDa DATE NOT NULL,
  LavoraA DATE,
  nomeImpianto VARCHAR(30) REFERENCES Impianto(nome) ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK(char_length(PW) >= 5)
);

CREATE TABLE Turno (
  matricolaPersona INTEGER REFERENCES Persona(matricola) ON DELETE CASCADE ON UPDATE CASCADE,
  nomeImpianto VARCHAR(30),
  data DATE,
  PRIMARY KEY (matricolaPersona, nomeImpianto, data),
  FOREIGN KEY(data, nomeImpianto) REFERENCES Giorno(data, nomeImpianto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cliente (
  codice SERIAL PRIMARY KEY,
  nome VARCHAR(20) NOT NULL,
  cognome VARCHAR(20) NOT NULL,
  tipoDocumento CHAR NOT NULL,
  /* Il tipo di documento puo essere:
	c = carta di identita
	p = patente
  */
  numeroDocumento VARCHAR(20) NOT NULL UNIQUE,
  CHECK(tipoDocumento IN ('c', 'p'))
);

CREATE TABLE Biglietto (
  codice SERIAL PRIMARY KEY,
  importo NUMERIC(6,2) NOT NULL,
  tipo CHAR NOT NULL,
  /* Il tipo di biglietto puo essere:
	s = singolo
	d = 10 ingressi
	c = 50 ingressi
	a = abbonamento
  */
  dataInizio DATE,
  dataFine DATE,
  ingressiTotali INTEGER,
  ingressiRimasti INTEGER,
  codiceCliente INTEGER REFERENCES Cliente(codice) ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK(importo > 0 AND ingressiTotali >= 0 AND ingressiRimasti >= 0 AND tipo IN ('s', 'd', 'c', 'a'))
);

CREATE TABLE Ingresso (
  codiceBiglietto INTEGER REFERENCES Biglietto(codice) ON DELETE CASCADE ON UPDATE CASCADE,
  nomeImpianto VARCHAR(30) REFERENCES Impianto(nome) ON DELETE CASCADE ON UPDATE CASCADE,
  dataEntrata DATE,
  oraEntrata TIME,
  oraUscita TIME,
  PRIMARY KEY(codiceBiglietto, nomeImpianto, dataEntrata, oraEntrata)
);

CREATE TABLE Iscritto (
  codiceCliente INTEGER REFERENCES Cliente(codice) ON DELETE CASCADE ON UPDATE CASCADE,
  nomeImpianto VARCHAR(30) REFERENCES Impianto(nome) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY(codiceCliente, nomeImpianto)
);
