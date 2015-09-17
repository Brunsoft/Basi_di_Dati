--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: biglietto; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE biglietto (
    codice integer NOT NULL,
    importo numeric(6,2) NOT NULL,
    tipo character(1) NOT NULL,
    datainizio date,
    datafine date,
    ingressitotali integer,
    ingressirimasti integer,
    codicecliente integer,
    CONSTRAINT biglietto_check CHECK (((((importo > (0)::numeric) AND (ingressitotali >= 0)) AND (ingressirimasti >= 0)) AND (tipo = ANY (ARRAY['s'::bpchar, 'd'::bpchar, 'c'::bpchar, 'a'::bpchar]))))
);


ALTER TABLE public.biglietto OWNER TO userlab22;

--
-- Name: biglietto_codice_seq; Type: SEQUENCE; Schema: public; Owner: userlab22
--

CREATE SEQUENCE biglietto_codice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.biglietto_codice_seq OWNER TO userlab22;

--
-- Name: biglietto_codice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: userlab22
--

ALTER SEQUENCE biglietto_codice_seq OWNED BY biglietto.codice;


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE cliente (
    codice integer NOT NULL,
    nome character varying(20) NOT NULL,
    cognome character varying(20) NOT NULL,
    tipodocumento character(1) NOT NULL,
    numerodocumento character varying(20) NOT NULL,
    CONSTRAINT cliente_tipodocumento_check CHECK ((tipodocumento = ANY (ARRAY['c'::bpchar, 'p'::bpchar])))
);


ALTER TABLE public.cliente OWNER TO userlab22;

--
-- Name: cliente_codice_seq; Type: SEQUENCE; Schema: public; Owner: userlab22
--

CREATE SEQUENCE cliente_codice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_codice_seq OWNER TO userlab22;

--
-- Name: cliente_codice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: userlab22
--

ALTER SEQUENCE cliente_codice_seq OWNED BY cliente.codice;


--
-- Name: giorno; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE giorno (
    data date NOT NULL,
    nomeimpianto character varying(30) NOT NULL,
    oraapertura time without time zone NOT NULL,
    orachiusura time without time zone NOT NULL,
    numeroingressi integer,
    CONSTRAINT giorno_numeroingressi_check CHECK ((numeroingressi >= 0))
);


ALTER TABLE public.giorno OWNER TO userlab22;

--
-- Name: impianto; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE impianto (
    nome character varying(30) NOT NULL,
    dataapertura date NOT NULL,
    datachiusura date NOT NULL,
    comune character varying(30) NOT NULL,
    indirizzo character varying(30) NOT NULL
);


ALTER TABLE public.impianto OWNER TO userlab22;

--
-- Name: ingresso; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE ingresso (
    codicebiglietto integer NOT NULL,
    nomeimpianto character varying(30) NOT NULL,
    dataentrata date NOT NULL,
    oraentrata time without time zone NOT NULL,
    orauscita time without time zone
);


ALTER TABLE public.ingresso OWNER TO userlab22;

--
-- Name: iscritto; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE iscritto (
    codicecliente integer NOT NULL,
    nomeimpianto character varying(30) NOT NULL
);


ALTER TABLE public.iscritto OWNER TO userlab22;

--
-- Name: persona; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE persona (
    matricola integer NOT NULL,
    nome character varying(20) NOT NULL,
    cognome character varying(20) NOT NULL,
    datanascita date NOT NULL,
    pw character varying(20) NOT NULL,
    lavorada date NOT NULL,
    lavoraa date,
    nomeimpianto character varying(30),
    CONSTRAINT persona_pw_check CHECK ((char_length((pw)::text) >= 5))
);


ALTER TABLE public.persona OWNER TO userlab22;

--
-- Name: persona_matricola_seq; Type: SEQUENCE; Schema: public; Owner: userlab22
--

CREATE SEQUENCE persona_matricola_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persona_matricola_seq OWNER TO userlab22;

--
-- Name: persona_matricola_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: userlab22
--

ALTER SEQUENCE persona_matricola_seq OWNED BY persona.matricola;


--
-- Name: piscina; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE piscina (
    codice integer NOT NULL,
    dataapertura date NOT NULL,
    datachiusura date NOT NULL,
    oraapertura time without time zone NOT NULL,
    orachiusura time without time zone NOT NULL,
    tipo character(1) NOT NULL,
    nomeimpianto character varying(30),
    CONSTRAINT piscina_tipo_check CHECK ((tipo = ANY (ARRAY['v'::bpchar, 'c'::bpchar, 't'::bpchar, 'b'::bpchar])))
);


ALTER TABLE public.piscina OWNER TO userlab22;

--
-- Name: piscina_codice_seq; Type: SEQUENCE; Schema: public; Owner: userlab22
--

CREATE SEQUENCE piscina_codice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.piscina_codice_seq OWNER TO userlab22;

--
-- Name: piscina_codice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: userlab22
--

ALTER SEQUENCE piscina_codice_seq OWNED BY piscina.codice;


--
-- Name: turno; Type: TABLE; Schema: public; Owner: userlab22; Tablespace: 
--

CREATE TABLE turno (
    matricolapersona integer NOT NULL,
    nomeimpianto character varying(30) NOT NULL,
    data date NOT NULL
);


ALTER TABLE public.turno OWNER TO userlab22;

--
-- Name: codice; Type: DEFAULT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY biglietto ALTER COLUMN codice SET DEFAULT nextval('biglietto_codice_seq'::regclass);


--
-- Name: codice; Type: DEFAULT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY cliente ALTER COLUMN codice SET DEFAULT nextval('cliente_codice_seq'::regclass);


--
-- Name: matricola; Type: DEFAULT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY persona ALTER COLUMN matricola SET DEFAULT nextval('persona_matricola_seq'::regclass);


--
-- Name: codice; Type: DEFAULT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY piscina ALTER COLUMN codice SET DEFAULT nextval('piscina_codice_seq'::regclass);


--
-- Data for Name: biglietto; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY biglietto (codice, importo, tipo, datainizio, datafine, ingressitotali, ingressirimasti, codicecliente) FROM stdin;
1	5.00	s	\N	\N	\N	\N	1
2	400.00	a	2015-06-15	2015-09-30	\N	\N	2
3	5.00	s	\N	\N	\N	\N	3
4	400.00	a	2015-07-15	2015-12-31	\N	\N	4
5	5.00	s	\N	\N	\N	\N	5
6	40.00	d	\N	\N	10	9	6
7	5.00	s	\N	\N	\N	\N	7
8	40.00	d	\N	\N	10	9	8
9	400.00	a	2015-06-01	2015-09-30	\N	\N	9
10	200.00	c	\N	\N	50	49	10
11	5.00	s	\N	\N	\N	\N	10
12	5.00	s	\N	\N	\N	\N	6
13	5.00	s	\N	\N	\N	\N	9
14	5.00	s	\N	\N	\N	\N	1
15	5.00	s	\N	\N	\N	\N	2
16	5.00	s	\N	\N	\N	\N	4
17	5.00	s	\N	\N	\N	\N	3
18	5.00	s	\N	\N	\N	\N	1
19	5.00	s	\N	\N	\N	\N	8
20	5.00	s	\N	\N	\N	\N	7
21	40.00	d	\N	\N	10	9	5
22	5.00	s	\N	\N	\N	\N	4
23	5.00	s	\N	\N	\N	\N	12
25	400.00	a	2015-08-18	2015-12-31	\N	\N	8
26	5.00	s	\N	\N	\N	\N	4
24	200.00	c	\N	\N	50	48	11
\.


--
-- Name: biglietto_codice_seq; Type: SEQUENCE SET; Schema: public; Owner: userlab22
--

SELECT pg_catalog.setval('biglietto_codice_seq', 26, true);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY cliente (codice, nome, cognome, tipodocumento, numerodocumento) FROM stdin;
1	Francesca	Genovesi	c	GB63836826
2	Melissa	Pisani	p	VR486295PU
3	Elia	Panicucci	p	VR219438SN
4	Michele	Marino	c	EL38957432
5	Mario	Bianchi	c	AF84265248
6	Luciano	Trevisani	p	VI638257BR
7	Luigi	Colombo	c	CT95979642
8	Giulio	Ferrari	p	VR842652BD
9	Manuel	Ferro	p	VR328145HC
10	Emma	Costa	c	BM53853177
11	Luciana	Biondi	p	2535689
12	Claudio	Panicucci	p	35659845
\.


--
-- Name: cliente_codice_seq; Type: SEQUENCE SET; Schema: public; Owner: userlab22
--

SELECT pg_catalog.setval('cliente_codice_seq', 12, true);


--
-- Data for Name: giorno; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY giorno (data, nomeimpianto, oraapertura, orachiusura, numeroingressi) FROM stdin;
2015-07-01	Free Time	09:30:00	22:30:00	125
2015-07-02	Free Time	09:30:00	22:30:00	465
2015-07-03	Free Time	09:30:00	22:30:00	378
2015-07-04	Free Time	09:30:00	22:30:00	267
2015-07-05	Free Time	09:30:00	22:30:00	846
2015-07-06	Free Time	09:30:00	22:30:00	465
2015-07-07	Free Time	09:30:00	22:30:00	135
2015-07-08	Free Time	09:30:00	22:30:00	647
2015-07-09	Free Time	09:30:00	22:30:00	378
2015-07-10	Free Time	09:30:00	22:30:00	472
2015-07-11	Free Time	09:30:00	22:30:00	258
2015-07-12	Free Time	09:30:00	22:30:00	743
2015-07-13	Free Time	09:30:00	22:30:00	379
2015-07-14	Free Time	09:30:00	22:30:00	268
2015-07-15	Free Time	09:30:00	22:30:00	521
2015-07-16	Free Time	09:30:00	22:30:00	746
2015-07-17	Free Time	09:30:00	22:30:00	264
2015-07-18	Free Time	09:30:00	22:30:00	356
2015-07-19	Free Time	09:30:00	22:30:00	276
2015-07-20	Free Time	09:30:00	22:30:00	832
2015-07-21	Free Time	09:30:00	22:30:00	145
2015-07-22	Free Time	09:30:00	22:30:00	643
2015-07-23	Free Time	09:30:00	22:30:00	287
2015-07-24	Free Time	09:30:00	22:30:00	356
2015-07-25	Free Time	09:30:00	22:30:00	436
2015-07-26	Free Time	09:30:00	22:30:00	642
2015-07-27	Free Time	09:30:00	22:30:00	482
2015-07-28	Free Time	09:30:00	22:30:00	147
2015-07-29	Free Time	09:30:00	22:30:00	165
2015-07-30	Free Time	09:30:00	22:30:00	376
2015-07-31	Free Time	09:30:00	22:30:00	265
2015-08-01	Free Time	09:30:00	22:30:00	353
2015-08-02	Free Time	09:30:00	22:30:00	743
2015-08-03	Free Time	09:30:00	22:30:00	354
2015-08-04	Free Time	09:30:00	22:30:00	486
2015-08-05	Free Time	09:30:00	22:30:00	342
2015-08-06	Free Time	09:30:00	22:30:00	853
2015-08-07	Free Time	09:30:00	22:30:00	465
2015-08-08	Free Time	09:30:00	22:30:00	632
2015-08-09	Free Time	09:30:00	22:30:00	835
2015-08-10	Free Time	09:30:00	22:30:00	648
2015-08-11	Free Time	09:30:00	22:30:00	612
2015-08-12	Free Time	09:30:00	22:30:00	542
2015-08-13	Free Time	09:30:00	22:30:00	368
2015-08-14	Free Time	09:30:00	22:30:00	980
2015-08-15	Free Time	09:30:00	22:30:00	1250
2015-08-16	Free Time	09:30:00	22:30:00	865
2015-08-17	Free Time	09:30:00	22:30:00	746
2015-08-19	Free Time	09:30:00	22:30:00	680
2015-08-20	Free Time	09:30:00	22:30:00	964
2015-08-21	Free Time	09:30:00	22:30:00	578
2015-08-22	Free Time	09:30:00	22:30:00	696
2015-08-23	Free Time	09:30:00	22:30:00	356
2015-08-24	Free Time	09:30:00	22:30:00	567
2015-08-25	Free Time	09:30:00	22:30:00	543
2015-08-26	Free Time	09:30:00	22:30:00	678
2015-08-27	Free Time	09:30:00	22:30:00	365
2015-08-28	Free Time	09:30:00	22:30:00	532
2015-08-29	Free Time	09:30:00	22:30:00	386
2015-08-30	Free Time	09:30:00	22:30:00	731
2015-08-31	Free Time	09:30:00	22:30:00	355
2015-07-01	Terme di Giunone	09:00:00	20:00:00	125
2015-07-02	Terme di Giunone	09:00:00	20:00:00	465
2015-07-03	Terme di Giunone	09:00:00	20:00:00	378
2015-07-04	Terme di Giunone	09:00:00	20:00:00	267
2015-07-05	Terme di Giunone	09:00:00	20:00:00	846
2015-07-06	Terme di Giunone	09:00:00	20:00:00	465
2015-07-07	Terme di Giunone	09:00:00	20:00:00	135
2015-07-08	Terme di Giunone	09:00:00	20:00:00	647
2015-07-09	Terme di Giunone	09:00:00	20:00:00	378
2015-07-10	Terme di Giunone	09:00:00	20:00:00	472
2015-07-11	Terme di Giunone	09:00:00	20:00:00	258
2015-07-12	Terme di Giunone	09:00:00	20:00:00	743
2015-07-13	Terme di Giunone	09:00:00	20:00:00	379
2015-07-14	Terme di Giunone	09:00:00	20:00:00	268
2015-07-15	Terme di Giunone	09:00:00	20:00:00	521
2015-07-16	Terme di Giunone	09:00:00	20:00:00	746
2015-07-17	Terme di Giunone	09:00:00	20:00:00	264
2015-07-18	Terme di Giunone	09:00:00	20:00:00	356
2015-07-19	Terme di Giunone	09:00:00	20:00:00	276
2015-07-20	Terme di Giunone	09:00:00	20:00:00	832
2015-07-21	Terme di Giunone	09:00:00	20:00:00	145
2015-07-22	Terme di Giunone	09:00:00	20:00:00	643
2015-07-23	Terme di Giunone	09:00:00	20:00:00	287
2015-07-24	Terme di Giunone	09:00:00	20:00:00	356
2015-07-25	Terme di Giunone	09:00:00	20:00:00	436
2015-07-26	Terme di Giunone	09:00:00	20:00:00	642
2015-07-27	Terme di Giunone	09:00:00	20:00:00	482
2015-07-28	Terme di Giunone	09:00:00	20:00:00	147
2015-07-29	Terme di Giunone	09:00:00	20:00:00	165
2015-07-30	Terme di Giunone	09:00:00	20:00:00	376
2015-07-31	Terme di Giunone	09:00:00	20:00:00	265
2015-08-01	Terme di Giunone	09:00:00	20:00:00	353
2015-08-02	Terme di Giunone	09:00:00	20:00:00	743
2015-08-03	Terme di Giunone	09:00:00	20:00:00	354
2015-08-04	Terme di Giunone	09:00:00	20:00:00	486
2015-08-05	Terme di Giunone	09:00:00	20:00:00	342
2015-08-06	Terme di Giunone	09:00:00	20:00:00	853
2015-08-07	Terme di Giunone	09:00:00	20:00:00	465
2015-08-08	Terme di Giunone	09:00:00	20:00:00	632
2015-08-09	Terme di Giunone	09:00:00	20:00:00	835
2015-08-10	Terme di Giunone	09:00:00	20:00:00	648
2015-08-11	Terme di Giunone	09:00:00	20:00:00	612
2015-08-12	Terme di Giunone	09:00:00	20:00:00	542
2015-08-13	Terme di Giunone	09:00:00	20:00:00	368
2015-08-14	Terme di Giunone	09:00:00	20:00:00	980
2015-08-15	Terme di Giunone	09:00:00	20:00:00	1250
2015-08-16	Terme di Giunone	09:00:00	20:00:00	865
2015-08-17	Terme di Giunone	09:00:00	20:00:00	746
2015-08-18	Terme di Giunone	09:00:00	20:00:00	896
2015-08-19	Terme di Giunone	09:00:00	20:00:00	680
2015-08-20	Terme di Giunone	09:00:00	20:00:00	964
2015-08-21	Terme di Giunone	09:00:00	20:00:00	578
2015-08-22	Terme di Giunone	09:00:00	20:00:00	696
2015-08-23	Terme di Giunone	09:00:00	20:00:00	356
2015-08-24	Terme di Giunone	09:00:00	20:00:00	567
2015-08-25	Terme di Giunone	09:00:00	20:00:00	543
2015-08-26	Terme di Giunone	09:00:00	20:00:00	678
2015-08-27	Terme di Giunone	09:00:00	20:00:00	365
2015-08-28	Terme di Giunone	09:00:00	20:00:00	532
2015-08-29	Terme di Giunone	09:00:00	20:00:00	386
2015-08-30	Terme di Giunone	09:00:00	20:00:00	731
2015-08-31	Terme di Giunone	09:00:00	20:00:00	355
2015-07-01	Le Grazie	10:00:00	18:00:00	125
2015-07-02	Le Grazie	10:00:00	18:00:00	465
2015-07-03	Le Grazie	10:00:00	18:00:00	378
2015-07-04	Le Grazie	10:00:00	18:00:00	267
2015-07-05	Le Grazie	10:00:00	18:00:00	846
2015-07-06	Le Grazie	10:00:00	18:00:00	465
2015-07-07	Le Grazie	10:00:00	18:00:00	135
2015-07-08	Le Grazie	10:00:00	18:00:00	647
2015-07-09	Le Grazie	10:00:00	18:00:00	378
2015-07-10	Le Grazie	10:00:00	18:00:00	472
2015-07-11	Le Grazie	10:00:00	18:00:00	258
2015-07-12	Le Grazie	10:00:00	18:00:00	743
2015-07-13	Le Grazie	10:00:00	18:00:00	379
2015-07-14	Le Grazie	10:00:00	18:00:00	268
2015-07-15	Le Grazie	10:00:00	18:00:00	521
2015-07-16	Le Grazie	10:00:00	18:00:00	746
2015-07-17	Le Grazie	10:00:00	18:00:00	264
2015-07-18	Le Grazie	10:00:00	18:00:00	356
2015-07-19	Le Grazie	10:00:00	18:00:00	276
2015-07-20	Le Grazie	10:00:00	18:00:00	832
2015-07-21	Le Grazie	10:00:00	18:00:00	145
2015-07-22	Le Grazie	10:00:00	18:00:00	643
2015-07-23	Le Grazie	10:00:00	18:00:00	287
2015-07-24	Le Grazie	10:00:00	18:00:00	356
2015-07-25	Le Grazie	10:00:00	18:00:00	436
2015-07-26	Le Grazie	10:00:00	18:00:00	642
2015-07-27	Le Grazie	10:00:00	18:00:00	482
2015-07-28	Le Grazie	10:00:00	18:00:00	147
2015-07-29	Le Grazie	10:00:00	18:00:00	165
2015-07-30	Le Grazie	10:00:00	18:00:00	376
2015-07-31	Le Grazie	10:00:00	18:00:00	265
2015-08-01	Le Grazie	10:00:00	18:00:00	353
2015-08-02	Le Grazie	10:00:00	18:00:00	743
2015-08-03	Le Grazie	10:00:00	18:00:00	354
2015-08-04	Le Grazie	10:00:00	18:00:00	486
2015-08-05	Le Grazie	10:00:00	18:00:00	342
2015-08-06	Le Grazie	10:00:00	18:00:00	853
2015-08-07	Le Grazie	10:00:00	18:00:00	465
2015-08-08	Le Grazie	10:00:00	18:00:00	632
2015-08-09	Le Grazie	10:00:00	18:00:00	835
2015-08-10	Le Grazie	10:00:00	18:00:00	648
2015-08-11	Le Grazie	10:00:00	18:00:00	612
2015-08-12	Le Grazie	10:00:00	18:00:00	542
2015-08-13	Le Grazie	10:00:00	18:00:00	368
2015-08-14	Le Grazie	10:00:00	18:00:00	980
2015-08-15	Le Grazie	10:00:00	18:00:00	1250
2015-08-16	Le Grazie	10:00:00	18:00:00	865
2015-08-17	Le Grazie	10:00:00	18:00:00	746
2015-08-18	Le Grazie	10:00:00	18:00:00	896
2015-08-19	Le Grazie	10:00:00	18:00:00	680
2015-08-20	Le Grazie	10:00:00	18:00:00	964
2015-08-21	Le Grazie	10:00:00	18:00:00	578
2015-08-22	Le Grazie	10:00:00	18:00:00	696
2015-08-23	Le Grazie	10:00:00	18:00:00	356
2015-08-24	Le Grazie	10:00:00	18:00:00	567
2015-08-25	Le Grazie	10:00:00	18:00:00	543
2015-08-26	Le Grazie	10:00:00	18:00:00	678
2015-08-27	Le Grazie	10:00:00	18:00:00	365
2015-08-28	Le Grazie	10:00:00	18:00:00	532
2015-08-29	Le Grazie	10:00:00	18:00:00	386
2015-08-30	Le Grazie	10:00:00	18:00:00	731
2015-08-31	Le Grazie	10:00:00	18:00:00	355
2015-07-01	Sporting Club	08:00:00	21:00:00	125
2015-07-02	Sporting Club	08:00:00	21:00:00	465
2015-07-03	Sporting Club	08:00:00	21:00:00	378
2015-07-04	Sporting Club	08:00:00	21:00:00	267
2015-07-05	Sporting Club	08:00:00	21:00:00	846
2015-07-06	Sporting Club	08:00:00	21:00:00	465
2015-07-07	Sporting Club	08:00:00	21:00:00	135
2015-07-08	Sporting Club	08:00:00	21:00:00	647
2015-07-09	Sporting Club	08:00:00	21:00:00	378
2015-07-10	Sporting Club	08:00:00	21:00:00	472
2015-07-11	Sporting Club	08:00:00	21:00:00	258
2015-07-12	Sporting Club	08:00:00	21:00:00	743
2015-07-13	Sporting Club	08:00:00	21:00:00	379
2015-07-14	Sporting Club	08:00:00	21:00:00	268
2015-07-15	Sporting Club	08:00:00	21:00:00	521
2015-07-16	Sporting Club	08:00:00	21:00:00	746
2015-07-17	Sporting Club	08:00:00	21:00:00	264
2015-07-18	Sporting Club	08:00:00	21:00:00	356
2015-07-19	Sporting Club	08:00:00	21:00:00	276
2015-07-20	Sporting Club	08:00:00	21:00:00	832
2015-07-21	Sporting Club	08:00:00	21:00:00	145
2015-07-22	Sporting Club	08:00:00	21:00:00	643
2015-07-23	Sporting Club	08:00:00	21:00:00	287
2015-07-24	Sporting Club	08:00:00	21:00:00	356
2015-07-25	Sporting Club	08:00:00	21:00:00	436
2015-07-26	Sporting Club	08:00:00	21:00:00	642
2015-07-27	Sporting Club	08:00:00	21:00:00	482
2015-07-28	Sporting Club	08:00:00	21:00:00	147
2015-07-29	Sporting Club	08:00:00	21:00:00	165
2015-07-30	Sporting Club	08:00:00	21:00:00	376
2015-07-31	Sporting Club	08:00:00	21:00:00	265
2015-08-01	Sporting Club	08:00:00	21:00:00	353
2015-08-02	Sporting Club	08:00:00	21:00:00	743
2015-08-03	Sporting Club	08:00:00	21:00:00	354
2015-08-04	Sporting Club	08:00:00	21:00:00	486
2015-08-05	Sporting Club	08:00:00	21:00:00	342
2015-08-06	Sporting Club	08:00:00	21:00:00	853
2015-08-07	Sporting Club	08:00:00	21:00:00	465
2015-08-08	Sporting Club	08:00:00	21:00:00	632
2015-08-09	Sporting Club	08:00:00	21:00:00	835
2015-08-10	Sporting Club	08:00:00	21:00:00	648
2015-08-11	Sporting Club	08:00:00	21:00:00	612
2015-08-12	Sporting Club	08:00:00	21:00:00	542
2015-08-13	Sporting Club	08:00:00	21:00:00	368
2015-08-14	Sporting Club	08:00:00	21:00:00	980
2015-08-15	Sporting Club	08:00:00	21:00:00	1250
2015-08-16	Sporting Club	08:00:00	21:00:00	865
2015-08-17	Sporting Club	08:00:00	21:00:00	746
2015-08-18	Sporting Club	08:00:00	21:00:00	896
2015-08-19	Sporting Club	08:00:00	21:00:00	680
2015-08-20	Sporting Club	08:00:00	21:00:00	964
2015-08-21	Sporting Club	08:00:00	21:00:00	578
2015-08-22	Sporting Club	08:00:00	21:00:00	696
2015-08-23	Sporting Club	08:00:00	21:00:00	356
2015-08-24	Sporting Club	08:00:00	21:00:00	567
2015-08-25	Sporting Club	08:00:00	21:00:00	543
2015-08-26	Sporting Club	08:00:00	21:00:00	678
2015-08-27	Sporting Club	08:00:00	21:00:00	365
2015-08-28	Sporting Club	08:00:00	21:00:00	532
2015-08-29	Sporting Club	08:00:00	21:00:00	386
2015-08-30	Sporting Club	08:00:00	21:00:00	731
2015-08-31	Sporting Club	08:00:00	21:00:00	355
2015-07-01	In Sport	08:00:00	21:00:00	125
2015-07-02	In Sport	08:00:00	21:00:00	465
2015-07-03	In Sport	08:00:00	21:00:00	378
2015-07-04	In Sport	08:00:00	21:00:00	267
2015-07-05	In Sport	08:00:00	21:00:00	846
2015-07-06	In Sport	08:00:00	21:00:00	465
2015-07-07	In Sport	08:00:00	21:00:00	135
2015-07-08	In Sport	08:00:00	21:00:00	647
2015-07-09	In Sport	08:00:00	21:00:00	378
2015-07-10	In Sport	08:00:00	21:00:00	472
2015-07-11	In Sport	08:00:00	21:00:00	258
2015-07-12	In Sport	08:00:00	21:00:00	743
2015-07-13	In Sport	08:00:00	21:00:00	379
2015-07-14	In Sport	08:00:00	21:00:00	268
2015-07-15	In Sport	08:00:00	21:00:00	521
2015-07-16	In Sport	08:00:00	21:00:00	746
2015-07-17	In Sport	08:00:00	21:00:00	264
2015-07-18	In Sport	08:00:00	21:00:00	356
2015-07-19	In Sport	08:00:00	21:00:00	276
2015-07-20	In Sport	08:00:00	21:00:00	832
2015-07-21	In Sport	08:00:00	21:00:00	145
2015-07-22	In Sport	08:00:00	21:00:00	643
2015-07-23	In Sport	08:00:00	21:00:00	287
2015-07-24	In Sport	08:00:00	21:00:00	356
2015-07-25	In Sport	08:00:00	21:00:00	436
2015-07-26	In Sport	08:00:00	21:00:00	642
2015-07-27	In Sport	08:00:00	21:00:00	482
2015-07-28	In Sport	08:00:00	21:00:00	147
2015-07-29	In Sport	08:00:00	21:00:00	165
2015-07-30	In Sport	08:00:00	21:00:00	376
2015-07-31	In Sport	08:00:00	21:00:00	265
2015-08-01	In Sport	08:00:00	21:00:00	353
2015-08-02	In Sport	08:00:00	21:00:00	743
2015-08-03	In Sport	08:00:00	21:00:00	354
2015-08-04	In Sport	08:00:00	21:00:00	486
2015-08-05	In Sport	08:00:00	21:00:00	342
2015-08-06	In Sport	08:00:00	21:00:00	853
2015-08-07	In Sport	08:00:00	21:00:00	465
2015-08-08	In Sport	08:00:00	21:00:00	632
2015-08-09	In Sport	08:00:00	21:00:00	835
2015-08-10	In Sport	08:00:00	21:00:00	648
2015-08-11	In Sport	08:00:00	21:00:00	612
2015-08-12	In Sport	08:00:00	21:00:00	542
2015-08-13	In Sport	08:00:00	21:00:00	368
2015-08-14	In Sport	08:00:00	21:00:00	980
2015-08-15	In Sport	08:00:00	21:00:00	1250
2015-08-16	In Sport	08:00:00	21:00:00	865
2015-08-17	In Sport	08:00:00	21:00:00	746
2015-08-18	In Sport	08:00:00	21:00:00	896
2015-08-19	In Sport	08:00:00	21:00:00	680
2015-08-20	In Sport	08:00:00	21:00:00	964
2015-08-21	In Sport	08:00:00	21:00:00	578
2015-08-22	In Sport	08:00:00	21:00:00	696
2015-08-23	In Sport	08:00:00	21:00:00	356
2015-08-24	In Sport	08:00:00	21:00:00	567
2015-08-25	In Sport	08:00:00	21:00:00	543
2015-08-26	In Sport	08:00:00	21:00:00	678
2015-08-27	In Sport	08:00:00	21:00:00	365
2015-08-28	In Sport	08:00:00	21:00:00	532
2015-08-29	In Sport	08:00:00	21:00:00	386
2015-08-30	In Sport	08:00:00	21:00:00	731
2015-08-31	In Sport	08:00:00	21:00:00	355
2015-07-01	Monte Bianco	08:30:00	20:30:00	125
2015-07-02	Monte Bianco	08:30:00	20:30:00	465
2015-07-03	Monte Bianco	08:30:00	20:30:00	378
2015-07-04	Monte Bianco	08:30:00	20:30:00	267
2015-07-05	Monte Bianco	08:30:00	20:30:00	846
2015-07-06	Monte Bianco	08:30:00	20:30:00	465
2015-07-07	Monte Bianco	08:30:00	20:30:00	135
2015-07-08	Monte Bianco	08:30:00	20:30:00	647
2015-07-09	Monte Bianco	08:30:00	20:30:00	378
2015-07-10	Monte Bianco	08:30:00	20:30:00	472
2015-07-11	Monte Bianco	08:30:00	20:30:00	258
2015-07-12	Monte Bianco	08:30:00	20:30:00	743
2015-07-13	Monte Bianco	08:30:00	20:30:00	379
2015-07-14	Monte Bianco	08:30:00	20:30:00	268
2015-07-15	Monte Bianco	08:30:00	20:30:00	521
2015-07-16	Monte Bianco	08:30:00	20:30:00	746
2015-07-17	Monte Bianco	08:30:00	20:30:00	264
2015-07-18	Monte Bianco	08:30:00	20:30:00	356
2015-07-19	Monte Bianco	08:30:00	20:30:00	276
2015-07-20	Monte Bianco	08:30:00	20:30:00	832
2015-07-21	Monte Bianco	08:30:00	20:30:00	145
2015-07-22	Monte Bianco	08:30:00	20:30:00	643
2015-07-23	Monte Bianco	08:30:00	20:30:00	287
2015-07-24	Monte Bianco	08:30:00	20:30:00	356
2015-07-25	Monte Bianco	08:30:00	20:30:00	436
2015-07-26	Monte Bianco	08:30:00	20:30:00	642
2015-07-27	Monte Bianco	08:30:00	20:30:00	482
2015-07-28	Monte Bianco	08:30:00	20:30:00	147
2015-07-29	Monte Bianco	08:30:00	20:30:00	165
2015-07-30	Monte Bianco	08:30:00	20:30:00	376
2015-07-31	Monte Bianco	08:30:00	20:30:00	265
2015-08-01	Monte Bianco	08:30:00	20:30:00	353
2015-08-02	Monte Bianco	08:30:00	20:30:00	743
2015-08-03	Monte Bianco	08:30:00	20:30:00	354
2015-08-04	Monte Bianco	08:30:00	20:30:00	486
2015-08-05	Monte Bianco	08:30:00	20:30:00	342
2015-08-06	Monte Bianco	08:30:00	20:30:00	853
2015-08-07	Monte Bianco	08:30:00	20:30:00	465
2015-08-08	Monte Bianco	08:30:00	20:30:00	632
2015-08-09	Monte Bianco	08:30:00	20:30:00	835
2015-08-10	Monte Bianco	08:30:00	20:30:00	648
2015-08-11	Monte Bianco	08:30:00	20:30:00	612
2015-08-12	Monte Bianco	08:30:00	20:30:00	542
2015-08-13	Monte Bianco	08:30:00	20:30:00	368
2015-08-14	Monte Bianco	08:30:00	20:30:00	980
2015-08-15	Monte Bianco	08:30:00	20:30:00	1250
2015-08-16	Monte Bianco	08:30:00	20:30:00	865
2015-08-17	Monte Bianco	08:30:00	20:30:00	746
2015-08-18	Monte Bianco	08:30:00	20:30:00	896
2015-08-19	Monte Bianco	08:30:00	20:30:00	680
2015-08-20	Monte Bianco	08:30:00	20:30:00	964
2015-08-21	Monte Bianco	08:30:00	20:30:00	578
2015-08-22	Monte Bianco	08:30:00	20:30:00	696
2015-08-23	Monte Bianco	08:30:00	20:30:00	356
2015-08-24	Monte Bianco	08:30:00	20:30:00	567
2015-08-25	Monte Bianco	08:30:00	20:30:00	543
2015-08-26	Monte Bianco	08:30:00	20:30:00	678
2015-08-27	Monte Bianco	08:30:00	20:30:00	365
2015-08-28	Monte Bianco	08:30:00	20:30:00	532
2015-08-29	Monte Bianco	08:30:00	20:30:00	386
2015-08-30	Monte Bianco	08:30:00	20:30:00	731
2015-08-31	Monte Bianco	08:30:00	20:30:00	355
2015-07-01	Santini	10:00:00	18:00:00	125
2015-07-02	Santini	10:00:00	18:00:00	465
2015-07-03	Santini	10:00:00	18:00:00	378
2015-07-04	Santini	10:00:00	18:00:00	267
2015-07-05	Santini	10:00:00	18:00:00	846
2015-07-06	Santini	10:00:00	18:00:00	465
2015-07-07	Santini	10:00:00	18:00:00	135
2015-07-08	Santini	10:00:00	18:00:00	647
2015-07-09	Santini	10:00:00	18:00:00	378
2015-07-10	Santini	10:00:00	18:00:00	472
2015-07-11	Santini	10:00:00	18:00:00	258
2015-07-12	Santini	10:00:00	18:00:00	743
2015-07-13	Santini	10:00:00	18:00:00	379
2015-07-14	Santini	10:00:00	18:00:00	268
2015-07-15	Santini	10:00:00	18:00:00	521
2015-07-16	Santini	10:00:00	18:00:00	746
2015-07-17	Santini	10:00:00	18:00:00	264
2015-07-18	Santini	10:00:00	18:00:00	356
2015-07-19	Santini	10:00:00	18:00:00	276
2015-07-20	Santini	10:00:00	18:00:00	832
2015-07-21	Santini	10:00:00	18:00:00	145
2015-07-22	Santini	10:00:00	18:00:00	643
2015-07-23	Santini	10:00:00	18:00:00	287
2015-07-24	Santini	10:00:00	18:00:00	356
2015-07-25	Santini	10:00:00	18:00:00	436
2015-07-26	Santini	10:00:00	18:00:00	642
2015-07-27	Santini	10:00:00	18:00:00	482
2015-07-28	Santini	10:00:00	18:00:00	147
2015-07-29	Santini	10:00:00	18:00:00	165
2015-07-30	Santini	10:00:00	18:00:00	376
2015-07-31	Santini	10:00:00	18:00:00	265
2015-08-01	Santini	10:00:00	18:00:00	353
2015-08-02	Santini	10:00:00	18:00:00	743
2015-08-03	Santini	10:00:00	18:00:00	354
2015-08-04	Santini	10:00:00	18:00:00	486
2015-08-05	Santini	10:00:00	18:00:00	342
2015-08-06	Santini	10:00:00	18:00:00	853
2015-08-07	Santini	10:00:00	18:00:00	465
2015-08-08	Santini	10:00:00	18:00:00	632
2015-08-09	Santini	10:00:00	18:00:00	835
2015-08-10	Santini	10:00:00	18:00:00	648
2015-08-11	Santini	10:00:00	18:00:00	612
2015-08-12	Santini	10:00:00	18:00:00	542
2015-08-13	Santini	10:00:00	18:00:00	368
2015-08-14	Santini	10:00:00	18:00:00	980
2015-08-15	Santini	10:00:00	18:00:00	1250
2015-08-16	Santini	10:00:00	18:00:00	865
2015-08-17	Santini	10:00:00	18:00:00	746
2015-08-18	Santini	10:00:00	18:00:00	896
2015-08-19	Santini	10:00:00	18:00:00	680
2015-08-20	Santini	10:00:00	18:00:00	964
2015-08-21	Santini	10:00:00	18:00:00	578
2015-08-22	Santini	10:00:00	18:00:00	696
2015-08-23	Santini	10:00:00	18:00:00	356
2015-08-24	Santini	10:00:00	18:00:00	567
2015-08-25	Santini	10:00:00	18:00:00	543
2015-08-26	Santini	10:00:00	18:00:00	678
2015-08-27	Santini	10:00:00	18:00:00	365
2015-08-28	Santini	10:00:00	18:00:00	532
2015-08-29	Santini	10:00:00	18:00:00	386
2015-08-30	Santini	10:00:00	18:00:00	731
2015-08-31	Santini	10:00:00	18:00:00	355
2015-07-01	Belvedere	09:00:00	21:00:00	125
2015-07-02	Belvedere	09:00:00	21:00:00	465
2015-07-03	Belvedere	09:00:00	21:00:00	378
2015-07-04	Belvedere	09:00:00	21:00:00	267
2015-07-05	Belvedere	09:00:00	21:00:00	846
2015-07-06	Belvedere	09:00:00	21:00:00	465
2015-07-07	Belvedere	09:00:00	21:00:00	135
2015-07-08	Belvedere	09:00:00	21:00:00	647
2015-07-09	Belvedere	09:00:00	21:00:00	378
2015-07-10	Belvedere	09:00:00	21:00:00	472
2015-07-11	Belvedere	09:00:00	21:00:00	258
2015-07-12	Belvedere	09:00:00	21:00:00	743
2015-07-13	Belvedere	09:00:00	21:00:00	379
2015-07-14	Belvedere	09:00:00	21:00:00	268
2015-07-15	Belvedere	09:00:00	21:00:00	521
2015-07-16	Belvedere	09:00:00	21:00:00	746
2015-07-17	Belvedere	09:00:00	21:00:00	264
2015-07-18	Belvedere	09:00:00	21:00:00	356
2015-07-19	Belvedere	09:00:00	21:00:00	276
2015-07-20	Belvedere	09:00:00	21:00:00	832
2015-07-21	Belvedere	09:00:00	21:00:00	145
2015-07-22	Belvedere	09:00:00	21:00:00	643
2015-07-23	Belvedere	09:00:00	21:00:00	287
2015-07-24	Belvedere	09:00:00	21:00:00	356
2015-07-25	Belvedere	09:00:00	21:00:00	436
2015-07-26	Belvedere	09:00:00	21:00:00	642
2015-07-27	Belvedere	09:00:00	21:00:00	482
2015-07-28	Belvedere	09:00:00	21:00:00	147
2015-07-29	Belvedere	09:00:00	21:00:00	165
2015-07-30	Belvedere	09:00:00	21:00:00	376
2015-07-31	Belvedere	09:00:00	21:00:00	265
2015-08-01	Belvedere	09:00:00	21:00:00	353
2015-08-02	Belvedere	09:00:00	21:00:00	743
2015-08-03	Belvedere	09:00:00	21:00:00	354
2015-08-04	Belvedere	09:00:00	21:00:00	486
2015-08-05	Belvedere	09:00:00	21:00:00	342
2015-08-06	Belvedere	09:00:00	21:00:00	853
2015-08-07	Belvedere	09:00:00	21:00:00	465
2015-08-08	Belvedere	09:00:00	21:00:00	632
2015-08-09	Belvedere	09:00:00	21:00:00	835
2015-08-10	Belvedere	09:00:00	21:00:00	648
2015-08-11	Belvedere	09:00:00	21:00:00	612
2015-08-12	Belvedere	09:00:00	21:00:00	542
2015-08-13	Belvedere	09:00:00	21:00:00	368
2015-08-14	Belvedere	09:00:00	21:00:00	980
2015-08-15	Belvedere	09:00:00	21:00:00	1250
2015-08-16	Belvedere	09:00:00	21:00:00	865
2015-08-17	Belvedere	09:00:00	21:00:00	746
2015-08-18	Belvedere	09:00:00	21:00:00	896
2015-08-19	Belvedere	09:00:00	21:00:00	680
2015-08-20	Belvedere	09:00:00	21:00:00	964
2015-08-21	Belvedere	09:00:00	21:00:00	578
2015-08-22	Belvedere	09:00:00	21:00:00	696
2015-08-23	Belvedere	09:00:00	21:00:00	356
2015-08-24	Belvedere	09:00:00	21:00:00	567
2015-08-25	Belvedere	09:00:00	21:00:00	543
2015-08-26	Belvedere	09:00:00	21:00:00	678
2015-08-27	Belvedere	09:00:00	21:00:00	365
2015-08-28	Belvedere	09:00:00	21:00:00	532
2015-08-29	Belvedere	09:00:00	21:00:00	386
2015-08-30	Belvedere	09:00:00	21:00:00	731
2015-08-31	Belvedere	09:00:00	21:00:00	355
2015-07-01	Leosport	09:00:00	21:00:00	125
2015-07-02	Leosport	09:00:00	21:00:00	465
2015-07-03	Leosport	09:00:00	21:00:00	378
2015-07-04	Leosport	09:00:00	21:00:00	267
2015-07-05	Leosport	09:00:00	21:00:00	846
2015-07-06	Leosport	09:00:00	21:00:00	465
2015-07-07	Leosport	09:00:00	21:00:00	135
2015-07-08	Leosport	09:00:00	21:00:00	647
2015-07-09	Leosport	09:00:00	21:00:00	378
2015-07-10	Leosport	09:00:00	21:00:00	472
2015-07-11	Leosport	09:00:00	21:00:00	258
2015-07-12	Leosport	09:00:00	21:00:00	743
2015-07-13	Leosport	09:00:00	21:00:00	379
2015-07-14	Leosport	09:00:00	21:00:00	268
2015-07-15	Leosport	09:00:00	21:00:00	521
2015-07-16	Leosport	09:00:00	21:00:00	746
2015-07-17	Leosport	09:00:00	21:00:00	264
2015-07-18	Leosport	09:00:00	21:00:00	356
2015-07-19	Leosport	09:00:00	21:00:00	276
2015-07-20	Leosport	09:00:00	21:00:00	832
2015-07-21	Leosport	09:00:00	21:00:00	145
2015-07-22	Leosport	09:00:00	21:00:00	643
2015-07-23	Leosport	09:00:00	21:00:00	287
2015-07-24	Leosport	09:00:00	21:00:00	356
2015-07-25	Leosport	09:00:00	21:00:00	436
2015-07-26	Leosport	09:00:00	21:00:00	642
2015-07-27	Leosport	09:00:00	21:00:00	482
2015-07-28	Leosport	09:00:00	21:00:00	147
2015-07-29	Leosport	09:00:00	21:00:00	165
2015-07-30	Leosport	09:00:00	21:00:00	376
2015-07-31	Leosport	09:00:00	21:00:00	265
2015-08-01	Leosport	09:00:00	21:00:00	353
2015-08-02	Leosport	09:00:00	21:00:00	743
2015-08-03	Leosport	09:00:00	21:00:00	354
2015-08-04	Leosport	09:00:00	21:00:00	486
2015-08-05	Leosport	09:00:00	21:00:00	342
2015-08-06	Leosport	09:00:00	21:00:00	853
2015-08-07	Leosport	09:00:00	21:00:00	465
2015-08-08	Leosport	09:00:00	21:00:00	632
2015-08-09	Leosport	09:00:00	21:00:00	835
2015-08-10	Leosport	09:00:00	21:00:00	648
2015-08-11	Leosport	09:00:00	21:00:00	612
2015-08-12	Leosport	09:00:00	21:00:00	542
2015-08-13	Leosport	09:00:00	21:00:00	368
2015-08-14	Leosport	09:00:00	21:00:00	980
2015-08-15	Leosport	09:00:00	21:00:00	1250
2015-08-16	Leosport	09:00:00	21:00:00	865
2015-08-17	Leosport	09:00:00	21:00:00	746
2015-08-18	Leosport	09:00:00	21:00:00	896
2015-08-19	Leosport	09:00:00	21:00:00	680
2015-08-20	Leosport	09:00:00	21:00:00	964
2015-08-21	Leosport	09:00:00	21:00:00	578
2015-08-22	Leosport	09:00:00	21:00:00	696
2015-08-23	Leosport	09:00:00	21:00:00	356
2015-08-24	Leosport	09:00:00	21:00:00	567
2015-08-25	Leosport	09:00:00	21:00:00	543
2015-08-26	Leosport	09:00:00	21:00:00	678
2015-08-27	Leosport	09:00:00	21:00:00	365
2015-08-28	Leosport	09:00:00	21:00:00	532
2015-08-29	Leosport	09:00:00	21:00:00	386
2015-08-30	Leosport	09:00:00	21:00:00	731
2015-08-31	Leosport	09:00:00	21:00:00	355
2015-07-01	Gio Club	09:00:00	21:00:00	125
2015-07-02	Gio Club	09:00:00	21:00:00	465
2015-07-03	Gio Club	09:00:00	21:00:00	378
2015-07-04	Gio Club	09:00:00	21:00:00	267
2015-07-05	Gio Club	09:00:00	21:00:00	846
2015-07-06	Gio Club	09:00:00	21:00:00	465
2015-07-07	Gio Club	09:00:00	21:00:00	135
2015-07-08	Gio Club	09:00:00	21:00:00	647
2015-07-09	Gio Club	09:00:00	21:00:00	378
2015-07-10	Gio Club	09:00:00	21:00:00	472
2015-07-11	Gio Club	09:00:00	21:00:00	258
2015-07-12	Gio Club	09:00:00	21:00:00	743
2015-07-13	Gio Club	09:00:00	21:00:00	379
2015-07-14	Gio Club	09:00:00	21:00:00	268
2015-07-15	Gio Club	09:00:00	21:00:00	521
2015-07-16	Gio Club	09:00:00	21:00:00	746
2015-07-17	Gio Club	09:00:00	21:00:00	264
2015-07-18	Gio Club	09:00:00	21:00:00	356
2015-07-19	Gio Club	09:00:00	21:00:00	276
2015-07-20	Gio Club	09:00:00	21:00:00	832
2015-07-21	Gio Club	09:00:00	21:00:00	145
2015-07-22	Gio Club	09:00:00	21:00:00	643
2015-07-23	Gio Club	09:00:00	21:00:00	287
2015-07-24	Gio Club	09:00:00	21:00:00	356
2015-07-25	Gio Club	09:00:00	21:00:00	436
2015-07-26	Gio Club	09:00:00	21:00:00	642
2015-07-27	Gio Club	09:00:00	21:00:00	482
2015-07-28	Gio Club	09:00:00	21:00:00	147
2015-07-29	Gio Club	09:00:00	21:00:00	165
2015-07-30	Gio Club	09:00:00	21:00:00	376
2015-07-31	Gio Club	09:00:00	21:00:00	265
2015-08-01	Gio Club	09:00:00	21:00:00	353
2015-08-02	Gio Club	09:00:00	21:00:00	743
2015-08-03	Gio Club	09:00:00	21:00:00	354
2015-08-04	Gio Club	09:00:00	21:00:00	486
2015-08-05	Gio Club	09:00:00	21:00:00	342
2015-08-06	Gio Club	09:00:00	21:00:00	853
2015-08-07	Gio Club	09:00:00	21:00:00	465
2015-08-08	Gio Club	09:00:00	21:00:00	632
2015-08-09	Gio Club	09:00:00	21:00:00	835
2015-08-10	Gio Club	09:00:00	21:00:00	648
2015-08-11	Gio Club	09:00:00	21:00:00	612
2015-08-12	Gio Club	09:00:00	21:00:00	542
2015-08-13	Gio Club	09:00:00	21:00:00	368
2015-08-14	Gio Club	09:00:00	21:00:00	980
2015-08-15	Gio Club	09:00:00	21:00:00	1250
2015-08-16	Gio Club	09:00:00	21:00:00	865
2015-08-17	Gio Club	09:00:00	21:00:00	746
2015-08-18	Gio Club	09:00:00	21:00:00	896
2015-08-19	Gio Club	09:00:00	21:00:00	680
2015-08-20	Gio Club	09:00:00	21:00:00	964
2015-08-21	Gio Club	09:00:00	21:00:00	578
2015-08-22	Gio Club	09:00:00	21:00:00	696
2015-08-23	Gio Club	09:00:00	21:00:00	356
2015-08-24	Gio Club	09:00:00	21:00:00	567
2015-08-25	Gio Club	09:00:00	21:00:00	543
2015-08-26	Gio Club	09:00:00	21:00:00	678
2015-08-27	Gio Club	09:00:00	21:00:00	365
2015-08-28	Gio Club	09:00:00	21:00:00	532
2015-08-29	Gio Club	09:00:00	21:00:00	386
2015-08-30	Gio Club	09:00:00	21:00:00	731
2015-08-31	Gio Club	09:00:00	21:00:00	355
2015-08-18	Free Time	09:30:00	22:30:00	5
\.


--
-- Data for Name: impianto; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY impianto (nome, dataapertura, datachiusura, comune, indirizzo) FROM stdin;
Free Time	2015-01-01	2015-12-31	San Bonifacio	Via Camporosolo, 190
Terme di Giunone	2015-06-01	2015-09-30	Caldiero	Via delle Terme, 1
Le Grazie	2015-01-01	2015-12-31	Verona	Strada Le Grazie
Sporting Club	2015-01-01	2015-12-31	Verona	Via Corsini, 5
In Sport	2015-01-01	2015-12-31	Verona	Via Tanaro, 28
Monte Bianco	2015-01-01	2015-12-31	Verona	Via Monte Bianco, 16
Santini	2015-06-01	2015-09-30	Verona	Via Santini, 15
Belvedere	2015-01-01	2015-12-31	Verona	Via Montelungo, 5
Leosport	2015-01-01	2015-12-31	Villafranca	Viale Olimpia
Gio Club	2015-01-01	2015-12-31	San Giovanni Lupatoto	Viale Olimpia, 10
\.


--
-- Data for Name: ingresso; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY ingresso (codicebiglietto, nomeimpianto, dataentrata, oraentrata, orauscita) FROM stdin;
1	Free Time	2015-06-15	18:00:00	20:00:00
2	Terme di Giunone	2015-06-15	15:00:00	18:00:00
3	Le Grazie	2015-06-15	10:00:00	12:00:00
4	Sporting Club	2015-06-15	09:00:00	12:00:00
5	In Sport	2015-06-15	16:00:00	20:00:00
6	Monte Bianco	2015-06-15	12:00:00	16:00:00
7	Santini	2015-06-15	12:00:00	15:00:00
8	Belvedere	2015-06-15	10:00:00	14:00:00
9	Leosport	2015-06-15	12:00:00	18:00:00
10	Gio Club	2015-06-15	10:00:00	16:00:00
11	Free Time	2015-06-20	16:00:00	18:00:00
12	Terme di Giunone	2015-06-25	10:00:00	18:00:00
13	Le Grazie	2015-07-05	14:00:00	17:00:00
14	Sporting Club	2015-07-15	09:00:00	11:00:00
15	In Sport	2015-07-18	16:00:00	20:00:00
16	Monte Bianco	2015-07-20	12:00:00	16:00:00
17	Santini	2015-07-25	13:00:00	16:00:00
18	Belvedere	2015-08-02	15:00:00	18:00:00
19	Leosport	2015-08-10	11:00:00	17:00:00
20	Gio Club	2015-08-15	12:00:00	16:00:00
21	Free Time	2015-08-18	12:03:00	\N
22	Free Time	2015-08-18	12:03:00	\N
23	Free Time	2015-08-18	12:03:00	\N
24	Free Time	2015-08-18	12:03:00	\N
25	Free Time	2015-08-18	12:03:00	\N
26	Free Time	2015-08-18	12:16:00	\N
24	Free Time	2015-08-18	12:16:00	\N
\.


--
-- Data for Name: iscritto; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY iscritto (codicecliente, nomeimpianto) FROM stdin;
1	Free Time
1	Terme di Giunone
1	Le Grazie
1	Monte Bianco
1	Belvedere
2	Terme di Giunone
2	Sporting Club
2	In Sport
2	Leosport
3	Le Grazie
3	Santini
4	Sporting Club
4	In Sport
4	Monte Bianco
4	Free Time
5	In Sport
5	Sporting Club
5	Le Grazie
6	Monte Bianco
6	Terme di Giunone
7	Santini
7	Belvedere
7	Gio Club
8	Belvedere
8	Terme di Giunone
8	Leosport
8	Free Time
9	Leosport
9	Le Grazie
10	Gio Club
10	Free Time
5	Free Time
11	Free Time
12	Free Time
\.


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY persona (matricola, nome, cognome, datanascita, pw, lavorada, lavoraa, nomeimpianto) FROM stdin;
1	Valentino	Calabrese	1950-04-05	ciaociao	2010-03-01	\N	Free Time
2	Anna	Trevisano	1980-06-12	password	2012-05-10	\N	Le Grazie
3	Luigi	Mancini	1978-02-24	123456	2014-06-01	2014-09-30	Terme di Giunone
4	Antonella	Ricci	1965-12-10	verona	2008-10-15	\N	In Sport
5	Luca	Russo	1992-10-18	qwerty	2005-01-01	\N	Sporting Club
6	Lorenzo	Pisani	1988-01-09	asdfg	2013-06-01	\N	Monte Bianco
7	Mariano	Costa	1961-11-05	54321	2012-02-05	2014-10-20	Gio Club
8	Davide	Milani	1974-10-04	pippo	2011-05-25	\N	Leosport
9	Vincenzo	Napolitano	1956-05-10	pluto	2015-01-01	\N	Belvedere
10	Pietro	Mazzi	1990-12-06	apple	2009-06-20	2013-09-10	Santini
11	Franca	Sagese	1991-01-30	gina24	2013-08-05	\N	Free Time
12	Maria	Milano	1993-11-21	maryvm	2008-06-12	\N	Le Grazie
13	Isa	Lombardi	1965-01-19	isa136	2012-07-06	\N	Terme di Giunone
14	Monica	Derosi	1989-07-11	monella	2014-09-02	\N	In Sport
15	Fabio	Toscani	1991-08-18	leo124	2010-04-15	\N	Sporting Club
16	Amaranto	Baresi	1971-11-16	rosso	2015-01-22	\N	Monte Bianco
17	Oreste	Palermo	1965-02-15	bruno	2011-03-02	\N	Gio Club
18	Pia	Fiorentino	1984-07-30	126170	2012-12-09	\N	Leosport
19	Lorenzo	Pugliesi	1973-02-02	ciccio	2013-05-12	\N	Belvedere
20	Rita	Schiavone	1962-10-14	worm52	2010-06-28	\N	Santini
21	Ubaldo	Endrizzi	1972-09-10	troll	2012-07-15	\N	Terme di Giunone
22	Federica	Ricci	1992-05-25	acre92	2013-06-10	\N	Gio Club
23	Adolfo	Buzzo	1968-10-02	buz03	2012-08-15	\N	Santini
24	Stefano	Sterchele	1979-06-29	sterchy	2011-04-05	\N	Free Time
25	Alice	Malizia	1982-12-16	maliz82	2008-10-01	\N	Le Grazie
26	Elia	Fochesato	1988-11-01	elia88	2013-06-12	\N	Terme di Giunone
27	Elisa	Zoppi	1981-06-22	81zoppi	2012-11-25	\N	In Sport
28	Federico	Masini	1980-02-22	ciano80	2011-04-24	\N	Sporting Club
29	Emanuele	Pozza	1974-03-08	emapozza	2012-06-08	\N	Monte Bianco
30	Francesco	Bellaria	1986-10-25	cyborg	2011-05-02	\N	Gio Club
31	Giulia	Gallina	1979-11-14	giuly79	2010-02-14	\N	Leosport
32	Linda	Lunardi	1980-01-29	lindalu	2014-03-05	\N	Belvedere
33	Lucia	Confente	1990-07-05	ifconfig	2012-07-22	\N	Santini
34	Matteo	Dal Zovo	1978-05-24	dzteo	2012-05-15	\N	Free Time
35	Mirco	Zamperini	1975-05-10	zmirco75	2010-09-03	\N	Le Grazie
36	Nicola	Fortunati	1984-11-04	fortunico	2010-08-05	\N	Terme di Giunone
37	Renata	Pegoraro	1968-04-07	pecora	2011-03-18	\N	In Sport
38	Stefania	Pozza	1986-03-21	stepoz	2006-11-25	\N	Sporting Club
39	Franco	Filipozzi	1986-06-18	fipoz	2014-07-02	\N	Monte Bianco
40	Lucio	Zandona	1978-01-02	zando	2013-06-28	\N	Gio Club
41	Marta	Dalla Verde	1992-12-09	verde	2015-05-03	\N	Leosport
42	Mattia	Panarotto	1982-05-18	iraid	2012-09-02	\N	Belvedere
43	Cetto	La Qualunque	1982-10-08	concetto	2014-08-10	\N	Santini
\.


--
-- Name: persona_matricola_seq; Type: SEQUENCE SET; Schema: public; Owner: userlab22
--

SELECT pg_catalog.setval('persona_matricola_seq', 43, true);


--
-- Data for Name: piscina; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY piscina (codice, dataapertura, datachiusura, oraapertura, orachiusura, tipo, nomeimpianto) FROM stdin;
1	2015-01-01	2015-12-31	10:00:00	22:00:00	v	Free Time
2	2015-01-01	2015-12-31	10:00:00	18:00:00	b	Free Time
3	2015-06-01	2015-09-30	10:00:00	18:00:00	c	Terme di Giunone
4	2015-06-01	2015-09-30	10:00:00	18:00:00	b	Terme di Giunone
5	2015-01-01	2015-12-31	10:00:00	18:00:00	v	Le Grazie
6	2015-06-01	2015-09-30	10:00:00	18:00:00	c	Le Grazie
7	2015-01-01	2015-12-31	09:00:00	20:00:00	c	Sporting Club
8	2015-01-01	2015-12-31	10:00:00	18:00:00	t	Sporting Club
9	2015-01-01	2015-12-31	09:00:00	20:00:00	v	Sporting Club
10	2015-06-01	2015-09-30	10:00:00	18:00:00	b	Sporting Club
11	2015-01-01	2015-12-31	09:00:00	20:00:00	v	In Sport
12	2015-01-01	2015-12-31	09:00:00	20:00:00	c	In Sport
13	2015-06-01	2015-09-30	10:00:00	18:00:00	t	In Sport
14	2015-06-01	2015-09-30	10:00:00	18:00:00	c	Monte Bianco
15	2015-01-01	2015-12-31	09:00:00	20:00:00	v	Monte Bianco
16	2015-06-01	2015-09-30	10:00:00	18:00:00	b	Santini
17	2015-06-01	2015-09-30	10:00:00	18:00:00	c	Santini
18	2015-01-01	2015-12-31	09:00:00	20:00:00	v	Belvedere
19	2015-06-01	2015-09-30	12:00:00	18:00:00	t	Belvedere
20	2015-01-01	2015-12-31	09:00:00	20:00:00	v	Leosport
21	2015-06-01	2015-09-30	10:00:00	18:00:00	c	Leosport
22	2015-01-01	2015-12-31	09:00:00	20:00:00	v	Gio Club
23	2015-01-01	2015-12-31	09:00:00	20:00:00	b	Gio Club
\.


--
-- Name: piscina_codice_seq; Type: SEQUENCE SET; Schema: public; Owner: userlab22
--

SELECT pg_catalog.setval('piscina_codice_seq', 23, true);


--
-- Data for Name: turno; Type: TABLE DATA; Schema: public; Owner: userlab22
--

COPY turno (matricolapersona, nomeimpianto, data) FROM stdin;
24	Free Time	2015-08-18
34	Free Time	2015-08-18
1	Free Time	2015-08-18
11	Free Time	2015-08-18
\.


--
-- Name: biglietto_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY biglietto
    ADD CONSTRAINT biglietto_pkey PRIMARY KEY (codice);


--
-- Name: cliente_numerodocumento_key; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_numerodocumento_key UNIQUE (numerodocumento);


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (codice);


--
-- Name: giorno_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY giorno
    ADD CONSTRAINT giorno_pkey PRIMARY KEY (data, nomeimpianto);


--
-- Name: impianto_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY impianto
    ADD CONSTRAINT impianto_pkey PRIMARY KEY (nome);


--
-- Name: ingresso_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY ingresso
    ADD CONSTRAINT ingresso_pkey PRIMARY KEY (codicebiglietto, nomeimpianto, dataentrata, oraentrata);


--
-- Name: iscritto_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY iscritto
    ADD CONSTRAINT iscritto_pkey PRIMARY KEY (codicecliente, nomeimpianto);


--
-- Name: persona_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (matricola);


--
-- Name: piscina_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY piscina
    ADD CONSTRAINT piscina_pkey PRIMARY KEY (codice, dataapertura, datachiusura);


--
-- Name: turno_pkey; Type: CONSTRAINT; Schema: public; Owner: userlab22; Tablespace: 
--

ALTER TABLE ONLY turno
    ADD CONSTRAINT turno_pkey PRIMARY KEY (matricolapersona, nomeimpianto, data);


--
-- Name: biglietto_codicecliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY biglietto
    ADD CONSTRAINT biglietto_codicecliente_fkey FOREIGN KEY (codicecliente) REFERENCES cliente(codice) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: giorno_nomeimpianto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY giorno
    ADD CONSTRAINT giorno_nomeimpianto_fkey FOREIGN KEY (nomeimpianto) REFERENCES impianto(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingresso_codicebiglietto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY ingresso
    ADD CONSTRAINT ingresso_codicebiglietto_fkey FOREIGN KEY (codicebiglietto) REFERENCES biglietto(codice) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingresso_nomeimpianto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY ingresso
    ADD CONSTRAINT ingresso_nomeimpianto_fkey FOREIGN KEY (nomeimpianto) REFERENCES impianto(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: iscritto_codicecliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY iscritto
    ADD CONSTRAINT iscritto_codicecliente_fkey FOREIGN KEY (codicecliente) REFERENCES cliente(codice) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: iscritto_nomeimpianto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY iscritto
    ADD CONSTRAINT iscritto_nomeimpianto_fkey FOREIGN KEY (nomeimpianto) REFERENCES impianto(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_nomeimpianto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_nomeimpianto_fkey FOREIGN KEY (nomeimpianto) REFERENCES impianto(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: piscina_nomeimpianto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY piscina
    ADD CONSTRAINT piscina_nomeimpianto_fkey FOREIGN KEY (nomeimpianto) REFERENCES impianto(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: turno_data_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY turno
    ADD CONSTRAINT turno_data_fkey FOREIGN KEY (data, nomeimpianto) REFERENCES giorno(data, nomeimpianto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: turno_matricolapersona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: userlab22
--

ALTER TABLE ONLY turno
    ADD CONSTRAINT turno_matricolapersona_fkey FOREIGN KEY (matricolapersona) REFERENCES persona(matricola) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

