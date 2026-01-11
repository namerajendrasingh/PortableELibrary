--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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
-- Name: set_book_category_updated_on(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_book_category_updated_on() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_on = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: book_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_category (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: book_category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.book_category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.book_category_category_id_seq OWNED BY public.book_category.category_id;


--
-- Name: book_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_issues (
    id integer NOT NULL,
    user_id integer,
    book_id integer,
    issue_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    due_date timestamp without time zone,
    return_date timestamp without time zone,
    status character varying(20) DEFAULT 'ISSUED'::character varying,
    CONSTRAINT book_issues_status_check CHECK (((status)::text = ANY (ARRAY[('ISSUED'::character varying)::text, ('RETURNED'::character varying)::text, ('OVERDUE'::character varying)::text])))
);


--
-- Name: book_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.book_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.book_issues_id_seq OWNED BY public.book_issues.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    isbn character varying(20),
    total_copies integer DEFAULT 1,
    available_copies integer DEFAULT 1,
    file_path character varying(500),
    added_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    category_id integer
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    firstname character varying(50) DEFAULT ''::character varying NOT NULL,
    lastname character varying(50),
    CONSTRAINT username_length CHECK (((length((username)::text) >= 8) AND (length((username)::text) <= 40))),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY (ARRAY[('ADMIN'::character varying)::text, ('STAFF'::character varying)::text, ('GUEST'::character varying)::text])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: book_category category_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_category ALTER COLUMN category_id SET DEFAULT nextval('public.book_category_category_id_seq'::regclass);


--
-- Name: book_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_issues ALTER COLUMN id SET DEFAULT nextval('public.book_issues_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: book_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.book_category (category_id, category_name, status, created_on, updated_on) FROM stdin;
2	Novel	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
3	Engineering	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
5	Science	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
6	History	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
8	Medical	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
9	Biography	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
10	Self Help	t	2025-12-25 13:34:30.822222	2025-12-25 13:34:30.822222
1	English	t	2025-12-25 13:34:30.822222	2025-12-25 14:04:14.51235
7	Computer Science	t	2025-12-25 13:34:30.822222	2025-12-25 14:44:32.48197
4	Mathematics	t	2025-12-25 13:34:30.822222	2025-12-25 14:46:52.196038
13	Mechanical Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
14	Civil Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
15	Electrical Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
16	Chemical Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
17	Computer Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
18	Software Engineering	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
19	Information Technology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
20	Electronics	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
22	Physics	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
23	Chemistry	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
24	Biology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
26	Environmental Science	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
27	Astronomy	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
28	Geology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
29	Biotechnology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
30	English Literature	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
32	Geography	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
33	Political Science	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
34	Economics	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
35	Sociology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
36	Psychology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
37	Philosophy	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
40	Fiction	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
41	Science Fiction	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
42	Fantasy	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
43	Mystery	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
44	Thriller	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
45	Romance	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
46	Horror	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
47	Adventure	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
48	Historical Fiction	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
50	Autobiography	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
52	Business	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
53	Management	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
54	Finance	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
55	Marketing	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
56	Entrepreneurship	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
57	Cooking	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
58	Health	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
59	Programming	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
60	Java	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
61	Python	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
62	Data Science	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
63	Machine Learning	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
64	Artificial Intelligence	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
65	Cybersecurity	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
66	Web Development	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
67	Mobile Development	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
68	Cloud Computing	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
70	Anatomy	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
71	Pharmacology	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
72	Nursing	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
73	Dentistry	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
74	Ayurveda	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
75	Homeopathy	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
76	Law	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
77	Constitution	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
78	Education	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
79	Teaching	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
80	Competitive Exams	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
81	Religion	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
82	Hinduism	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
83	Islam	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
84	Christianity	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
85	Buddhism	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
86	Spirituality	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
87	Children	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
88	Teen	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
89	Young Adult	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
90	Picture Books	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
91	Hindi	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
92	Sanskrit	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
93	Tamil	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
94	Telugu	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
95	Kannada	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
96	Malayalam	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
97	Magazines	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
98	Newspapers	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
99	Journals	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
100	Reference	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
101	Encyclopedia	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
102	Dictionary	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
103	Travel	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
104	Sports	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
105	Music	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
106	Art	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
107	Photography	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
108	Gardening	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
109	Automobile	t	2025-12-25 14:49:05.036736	2025-12-25 14:49:05.036736
\.


--
-- Data for Name: book_issues; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.book_issues (id, user_id, book_id, issue_date, due_date, return_date, status) FROM stdin;
13	18	5	2025-12-21 00:00:00	2026-01-04 00:00:00	\N	ISSUED
14	18	7	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
15	3	7	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
16	3	6	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
17	3	2	2025-12-22 00:00:00	2025-12-27 00:00:00	\N	ISSUED
18	2	8	2025-12-22 00:00:00	2026-01-11 00:00:00	\N	ISSUED
12	18	1	2025-12-21 00:00:00	2026-01-04 00:00:00	2025-12-22 01:55:36.987754	RETURNED
19	2	14	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
20	2	13	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
21	4	12	2025-12-22 00:00:00	2026-01-05 00:00:00	\N	ISSUED
24	18	4	2025-12-25 00:00:00	2026-01-08 00:00:00	2025-12-25 01:44:12.784557	RETURNED
22	13	\N	2025-12-22 00:00:00	2026-01-05 00:00:00	2025-12-27 21:00:12.316028	RETURNED
25	18	\N	2025-12-25 00:00:00	2026-01-08 00:00:00	2025-12-27 21:00:18.743871	RETURNED
27	27	9	2025-12-30 00:00:00	2026-01-13 00:00:00	\N	ISSUED
28	25	19	2025-12-30 00:00:00	2026-01-13 00:00:00	\N	ISSUED
29	1	4	2025-12-30 00:00:00	2026-01-13 00:00:00	\N	ISSUED
30	13	28	2025-12-30 00:00:00	2026-01-13 00:00:00	\N	ISSUED
31	3	19	2025-12-30 00:00:00	2026-01-13 00:00:00	\N	ISSUED
26	3	27	2025-12-30 00:00:00	2026-01-13 00:00:00	2025-12-30 22:43:21.060175	RETURNED
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.books (id, title, author, isbn, total_copies, available_copies, file_path, added_date, category_id) FROM stdin;
9	Advanced Java Programming	Herbert Schildt	9780071808552	3	2	D:\\Books\\Core Java\\AdvancedJava\\advanced_java.pdf	2025-12-20 11:00:00	8
14	Spring in Action	Craig Walls	9781617294945	3	2	D:\\Books\\Spring\\spring_in_action.pdf	2025-12-15 09:45:22	1
4	Advanced Java Programming	Herbert Schildt	978007180JKSS	2	1	D:\\Books\\Core Java\\AdvancedJava\\advanced_java.pdf	2025-12-20 11:00:00	3
19	Agile Software Development	Robert C. Martin	9780135974445	3	1	D:\\Books\\Software Engineering\\Agile\\agile_software_dev.pdf	2025-12-21 10:20:00	1
15	Java Concurrency in Practice	Brian Goetz	9780321349606	2	2	D:\\Books\\Core Java\\Concurrency\\java_concurrency.pdf	2025-12-21 10:00:00	1
25	English Book	Raj Singh	43214432IUXY	1	1	D:\\LibraryPDF\\English\\English_fdsalf.pdf	2025-12-22 23:35:07.738288	1
6	Test	Raj	2289886	1	0	D:\\Books\\Spring\\SpringMVC\\Spring MVC, A Tutorial, second edition - Paul Deck.pdf	2025-12-21 23:13:41.37221	3
1	Java 8 In Action	Raoul-Gabriel Urma Mario Fusco Alan MyCroft	9781617291999	1	1	D:\\Books\\Core Java\\Java8\\1. java8inaction.pdf	2025-12-20 09:12:33.678205	1
2	Head First Desgin Pattern	Eric Freeman	0-596-00	1	0	D:\\Books\\Design Patterns\\1 HeadFirstDesign.pdf	2025-12-20 13:37:16.230082	2
3	Object Oriented Programming with Java	E. Balagurusamy	9780070262157	5	5	D:\\Books\\Core Java\\OOP\\oop_with_java.pdf	2025-12-18 10:30:00	3
5	Spring	Rajendra Singh	12345678H	1	0	D:\\Books\\Spring\\SpringMVC\\Spring 5.0 Craig-Walls-Spring-in-Action-Manning-Publications-2018.pdf	2025-12-21 20:39:32.039554	2
7	Temp	fafasd	7854fd	2	0	D:\\Books\\Core Java\\Java17\\Core Java Vol 12 - I.pdf	2025-12-21 23:29:32.329361	4
8	Ram	RAM	4545F	1	0	D:\\Books\\DataStructure\\1. Algorithms 4th Edition(Data Structure).pdf	2025-12-22 00:47:44.373916	6
12	Design Patterns	Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides	9780201633610	2	1	D:\\Books\\Design Patterns\\design_patterns.pdf	2025-12-17 14:05:10	5
13	Head First Java	Kathy Sierra, Bert Bates	9780596009205	4	2	D:\\Books\\Core Java\\HeadFirstJava\\hf_java.pdf	2025-12-16 16:30:00	5
17	Core Java Volume II	Cay S. Horstmann	9780135166314	3	3	D:\\Books\\Core Java\\CoreJava\\core_java_vol2.pdf	2025-12-21 10:10:00	3
18	Refactoring	Martin Fowler	9780201485677	2	2	D:\\Books\\Software Engineering\\Refactoring\\refactoring.pdf	2025-12-21 10:15:00	2
20	Software Engineering	Ian Sommerville	9780133943030	5	5	D:\\Books\\Software Engineering\\Sommerville\\software_engineering.pdf	2025-12-21 10:25:00	4
21	Computer Organization and Architecture	William Stallings	9780134101613	4	4	D:\\Books\\Computer Architecture\\coa.pdf	2025-12-21 10:30:00	6
22	Digital Logic and Computer Design	M. Morris Mano	9780131989269	3	3	D:\\Books\\Digital Logic\\mano_digital_logic.pdf	2025-12-21 10:35:00	7
23	Web Technologies	Uttam K. Roy	9780199454598	4	4	D:\\Books\\Web\\web_technologies.pdf	2025-12-21 10:40:00	7
24	Data Mining Concepts and Techniques	Jiawei Han, Micheline Kamber	9780123814791	2	2	D:\\Books\\Data Mining\\data_mining.pdf	2025-12-21 10:45:00	8
26	Fighting For Survival	Van Hussain	3873289IU	1	1	D:\\LibraryPDF\\Engineering\\Engineering_Spring_In_Action.pdf	2025-12-22 23:40:05.557078	6
29	Java and Ray	Ben	122132XYFSA	1	1	D:\\LibraryPDF\\Anatomy\\Anatomy_TestAnatomy.pdf	2025-12-29 00:22:22.164699	70
28	ram bharose	ram ji	ABCDEX776378IN	1	0	D:\\LibraryPDF\\Computer\\Computer_1_headfirstdesign.pdf	2025-12-25 14:31:16.335981	7
27	ram ji ki sawari	ram joi	3492873284328794i	1	1	D:\\LibraryPDF\\Maths\\Maths_core_java_vol_12_i.pdf	2025-12-23 12:49:06.520057	6
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, password, email, role, created_at, firstname, lastname) FROM stdin;
13	Aniket_user13	e7aba49b47b34ddfe3d9d4fe00af9b490612859faa2194b0ab8058825d7aad27	kumar.aniket900@gmail.com	GUEST	2025-12-20 17:20:24.996789	Aniket	Kumar
18	r_user18_user18	454349e422f05297191ead13e21d3db520e5abef52055e4964b82fb213f593a1	rajendra.singh068@gmail.com	GUEST	2025-12-21 01:38:02.745076	Test	User
2	staff_user2	1562206543da764123c21bd524674f0a8aaf49c8a89744c97352fe677f7e4006	staff@gmail.com	STAFF	2025-12-20 09:16:35.788951	Test	User
1	admin_user1	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918	admin@elibrary.com	GUEST	2025-12-19 12:03:45.696724	Test	User
4	ram_user4_user4	a631f4488a457da27b4a64dc8f2d85085b50ff568be99125cf6f8f45c759878e	ramji@gmail.com	STAFF	2025-12-20 10:22:45.535956	Test	User
3	rajsingh	9365f2383be76a4d64226de956a2de40e099b6810b576aab5c4837befe6afd35	raj@gmail.com	ADMIN	2025-12-20 09:16:54.266723	Raj	Singh
29	SSingh_95	a869363bade32a92f137b308b93c362cc18d88ae51b938769f52c3e8fcead150	sandeepkhawas858@gmail.com	GUEST	2025-12-28 10:56:44.122293	sandeep	singh
25	rajsinghji	9365f2383be76a4d64226de956a2de40e099b6810b576aab5c4837befe6afd35	rajsinghji@gmmail.com	GUEST	2025-12-28 01:23:39.815494	a	b
27	rajendra	9365f2383be76a4d64226de956a2de40e099b6810b576aab5c4837befe6afd35	rajsinghjavadeveloper@gmmail.com	GUEST	2025-12-28 01:51:47.452441	Rajendra	Singh
30	rajsinghjava	e673a0cf2236f2b3b97887eff904e851079c7eba4c586a2c5de61840af4223d6	rajsinghjavadeveloper@gmail.com	GUEST	2025-12-31 00:25:07.387174	raj	singh
\.


--
-- Name: book_category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.book_category_category_id_seq', 109, true);


--
-- Name: book_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.book_issues_id_seq', 31, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.books_id_seq', 30, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 30, true);


--
-- Name: book_category book_category_category_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_category
    ADD CONSTRAINT book_category_category_name_key UNIQUE (category_name);


--
-- Name: book_category book_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_category
    ADD CONSTRAINT book_category_pkey PRIMARY KEY (category_id);


--
-- Name: book_issues book_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_issues
    ADD CONSTRAINT book_issues_pkey PRIMARY KEY (id);


--
-- Name: books books_isbn_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_book_category_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_book_category_name ON public.book_category USING btree (category_name);


--
-- Name: idx_book_category_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_book_category_status ON public.book_category USING btree (status);


--
-- Name: book_category trg_book_category_updated_on; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_book_category_updated_on BEFORE UPDATE ON public.book_category FOR EACH ROW EXECUTE FUNCTION public.set_book_category_updated_on();


--
-- Name: book_issues book_issues_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_issues
    ADD CONSTRAINT book_issues_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: book_issues book_issues_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_issues
    ADD CONSTRAINT book_issues_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: books books_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.book_category(category_id);


--
-- PostgreSQL database dump complete
--

