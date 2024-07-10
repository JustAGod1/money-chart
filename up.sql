
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

