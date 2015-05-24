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
-- Name: matches; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE matches (
    match_id integer NOT NULL,
    p1 integer,
    p2 integer,
    winner integer
);


ALTER TABLE public.matches OWNER TO vagrant;

--
-- Name: matches_match_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE matches_match_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matches_match_id_seq OWNER TO vagrant;

--
-- Name: matches_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE matches_match_id_seq OWNED BY matches.match_id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.players OWNER TO vagrant;

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.players_id_seq OWNER TO vagrant;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;


--
-- Name: totalmatches; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE totalmatches (
    id integer,
    name character varying(255),
    matches bigint
);


ALTER TABLE public.totalmatches OWNER TO vagrant;

--
-- Name: totalwins; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE totalwins (
    id integer,
    name character varying(255),
    wins bigint
);


ALTER TABLE public.totalwins OWNER TO vagrant;

--
-- Name: tournamentstandings; Type: VIEW; Schema: public; Owner: vagrant
--

CREATE VIEW tournamentstandings AS
 SELECT players.id,
    players.name,
    totalwins.wins,
    totalmatches.matches
   FROM ((players
     JOIN totalwins ON ((players.id = totalwins.id)))
     LEFT JOIN totalmatches ON ((players.id = totalmatches.id)))
  ORDER BY totalwins.wins DESC;


ALTER TABLE public.tournamentstandings OWNER TO vagrant;

--
-- Name: match_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY matches ALTER COLUMN match_id SET DEFAULT nextval('matches_match_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY players ALTER COLUMN id SET DEFAULT nextval('players_id_seq'::regclass);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY matches (match_id, p1, p2, winner) FROM stdin;
35	142	141	142
36	144	143	144
\.


--
-- Name: matches_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('matches_match_id_seq', 36, true);


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY players (id, name) FROM stdin;
141	Twilight Sparkle
142	Fluttershy
143	Applejack
144	Pinkie Pie
\.


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('players_id_seq', 144, true);


--
-- Name: matches_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: vagrant
--

CREATE RULE "_RETURN" AS
    ON SELECT TO totalwins DO INSTEAD  SELECT players.id,
    players.name,
    count(matches.winner) AS wins
   FROM (players
     LEFT JOIN matches ON ((players.id = matches.winner)))
  GROUP BY players.id
  ORDER BY count(matches.winner) DESC;


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: vagrant
--

CREATE RULE "_RETURN" AS
    ON SELECT TO totalmatches DO INSTEAD  SELECT players.id,
    players.name,
    count(matches.match_id) AS matches
   FROM (players
     LEFT JOIN matches ON (((players.id = matches.p1) OR (players.id = matches.p2))))
  GROUP BY players.id
  ORDER BY players.id;


--
-- Name: matches_p1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT matches_p1_fkey FOREIGN KEY (p1) REFERENCES players(id);


--
-- Name: matches_p2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT matches_p2_fkey FOREIGN KEY (p2) REFERENCES players(id);


--
-- Name: matches_winner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT matches_winner_fkey FOREIGN KEY (winner) REFERENCES players(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

