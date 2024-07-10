--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: diesel_manage_updated_at(regclass); Type: FUNCTION; Schema: public; Owner: charts
--

CREATE FUNCTION public.diesel_manage_updated_at(_tbl regclass) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$;


ALTER FUNCTION public.diesel_manage_updated_at(_tbl regclass) OWNER TO charts;

--
-- Name: diesel_set_updated_at(); Type: FUNCTION; Schema: public; Owner: charts
--

CREATE FUNCTION public.diesel_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.diesel_set_updated_at() OWNER TO charts;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __diesel_schema_migrations; Type: TABLE; Schema: public; Owner: charts
--

CREATE TABLE public.__diesel_schema_migrations (
    version character varying(50) NOT NULL,
    run_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.__diesel_schema_migrations OWNER TO charts;

--
-- Name: s_names; Type: TABLE; Schema: public; Owner: charts
--

CREATE TABLE public.s_names (
    name text NOT NULL
);


ALTER TABLE public.s_names OWNER TO charts;

--
-- Name: s_transactions; Type: TABLE; Schema: public; Owner: charts
--

CREATE TABLE public.s_transactions (
    name text NOT NULL,
    amount double precision NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.s_transactions OWNER TO charts;

--
-- Name: s_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: charts
--

CREATE SEQUENCE public.s_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.s_transactions_id_seq OWNER TO charts;

--
-- Name: s_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: charts
--

ALTER SEQUENCE public.s_transactions_id_seq OWNED BY public.s_transactions.id;


--
-- Name: s_transactions id; Type: DEFAULT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.s_transactions ALTER COLUMN id SET DEFAULT nextval('public.s_transactions_id_seq'::regclass);


--
-- Name: s_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: charts
--

SELECT pg_catalog.setval('public.s_transactions_id_seq', 1, false);


--
-- Name: __diesel_schema_migrations __diesel_schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.__diesel_schema_migrations
    ADD CONSTRAINT __diesel_schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: s_names key_name; Type: CONSTRAINT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.s_names
    ADD CONSTRAINT key_name PRIMARY KEY (name);


--
-- Name: s_names s_names_pk; Type: CONSTRAINT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.s_names
    ADD CONSTRAINT s_names_pk UNIQUE (name);


--
-- Name: s_transactions s_transactions_pk; Type: CONSTRAINT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.s_transactions
    ADD CONSTRAINT s_transactions_pk PRIMARY KEY (id);


--
-- Name: s_transactions s_transactions_s_names_null_fk; Type: FK CONSTRAINT; Schema: public; Owner: charts
--

ALTER TABLE ONLY public.s_transactions
    ADD CONSTRAINT s_transactions_s_names_null_fk FOREIGN KEY (name) REFERENCES public.s_names(name);


--
-- PostgreSQL database dump complete
--

