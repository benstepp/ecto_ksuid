--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Debian 14.5-1.pgdg110+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: test_associations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_associations (
    id character(27) NOT NULL,
    public_id character(27),
    association_id character(27)
);


--
-- Name: test_schemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_schemas (
    id character(27) NOT NULL,
    public_id character(27)
);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: test_associations test_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_associations
    ADD CONSTRAINT test_associations_pkey PRIMARY KEY (id);


--
-- Name: test_schemas test_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_schemas
    ADD CONSTRAINT test_schemas_pkey PRIMARY KEY (id);


--
-- Name: test_associations id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_associations
    ADD CONSTRAINT id FOREIGN KEY (association_id) REFERENCES public.test_schemas(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (0);
