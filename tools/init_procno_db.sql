CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v4();

------- CLEAN UP ---------
drop table if exists public.user_role cascade;
drop table if exists public.users cascade;
drop table if exists public.roles cascade;
drop table if exists public.records cascade;
drop table if exists public.commentars cascade;
drop table if exists public.read_texts cascade;
drop table if exists public.tag_topic cascade;
drop table if exists public.topic_question cascade;
drop table if exists public.topic_answer cascade;
drop table if exists public.topic_answers cascade;
drop table if exists public.topics cascade;
drop table if exists public.tags cascade;
drop table if exists public.questions cascade;
drop table if exists public.answers cascade;

drop function if exists update_updated_at_column cascade;
--------------------------
--------------------------

CREATE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

----------------------------------------------
----------- CREATE table users
----------------------------------------------

CREATE TABLE public.users (
	id serial NOT NULL,
	username text NOT NULL,
	email text NOT NULL,
	salt text NOT NULL,
	hashed_password text not NULL,
	bio text NOT NULL DEFAULT ''::text,
	is_active BOOLEAN NOT NULL DEFAULT TRUE,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);
CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);
CREATE UNIQUE INDEX ix_users_uniq_id ON public.users USING btree (uniq_id);
-- Table Triggers
create trigger update_user_modtime before
update
    on
    public.users for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table roles
----------------------------------------------
CREATE TABLE public.roles (
	id serial NOT NULL,
	role_name text NOT NULL,
	description text default '',
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX ix_roles_rolename ON public.roles USING btree (role_name);
CREATE UNIQUE INDEX ix_roles_uniq_id ON public.roles USING btree (uniq_id);
-- Table Triggers
create trigger update_role_modtime before
update
    on
    public.roles for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table tags for topic
----------------------------------------------
CREATE TABLE public.user_role (
	user_id int4 NOT NULL,
	role_id int4 NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE cascade,
	FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE cascade
);
-- Table Triggers
create trigger update_user_role_modtime before
update
    on
    public.user_role for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table records
----------------------------------------------
CREATE TABLE public.records (
	id serial NOT NULL,
	owner_id int4 not null,
	filename text NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT records_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_records_filename ON public.records USING btree (filename);
CREATE UNIQUE INDEX ix_records_uniq_id ON public.records USING btree (uniq_id);
-- Table Triggers
create trigger update_record_modtime before
update
    on
    public.records for each row execute function update_updated_at_column();


----------------------------------------------
----------- CREATE table commentars
----------------------------------------------
CREATE TABLE public.commentars (
	id serial NOT NULL,
	owner_id int4 not null,
	commentar text NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT commentars_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_commentars_uniq_id ON public.commentars USING btree (uniq_id);
-- Table Triggers
create trigger update_commentar_modtime before
update
    on
    public.commentars for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table read_texts
----------------------------------------------
CREATE TABLE public.read_texts (
	id serial NOT NULL,
	owner_id int4 not null,
	read_text text NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT texts_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_read_texts_uniq_id ON public.read_texts USING btree (uniq_id);
-- Table Triggers
create trigger update_text_modtime before
update
    on
    public.read_texts for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table questions
----------------------------------------------

CREATE TABLE public.questions (
	id serial NOT NULL,
	owner_id int4 not null,
	commentar_id int4 not null,
	record_id int4 not null,
	text_id int4 not null,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT questions_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade,
	FOREIGN KEY (commentar_id) REFERENCES public.commentars(id) ON DELETE cascade,
	FOREIGN KEY (record_id) REFERENCES public.records(id) ON DELETE cascade,
	FOREIGN KEY (text_id) REFERENCES public.read_texts(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_questions_uniq_id ON public.questions USING btree (uniq_id);
-- Table Triggers
create trigger update_question_modtime before
update
    on
    public.questions for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table answers
----------------------------------------------

CREATE TABLE public.answers (
	id serial NOT NULL,
	owner_id int4 not null,
	commentar_id int4 not null,
	record_id int4 not null,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT answers_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade,
	FOREIGN KEY (commentar_id) REFERENCES public.commentars(id) ON DELETE cascade,
	FOREIGN KEY (record_id) REFERENCES public.records(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_answers_uniq_id ON public.answers USING btree (uniq_id);
-- Table Triggers
create trigger update_answer_modtime before
update
    on
    public.answers for each row execute function update_updated_at_column();


----------------------------------------------
----------- CREATE table topics
----------------------------------------------
CREATE TABLE public.topics (
	id serial NOT NULL,
	owner_id int4 not null,
	title text NOT NULL,
	source_language text not null,
	source_level text not null,
	wish_correct_languages text[],
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT topics_pkey PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE cascade
);
CREATE UNIQUE INDEX ix_topics_title ON public.topics USING btree (title);
CREATE UNIQUE INDEX ix_topics_uniq_id ON public.topics USING btree (uniq_id);
-- Table Triggers
create trigger update_topic_modtime before
update
    on
    public.topics for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table topic_answers
----------------------------------------------

CREATE TABLE public.topic_answer (
	topic_id int4 not null,
	answer_id int4 not null,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE cascade,
	FOREIGN KEY (answer_id) REFERENCES public.answers(id) ON DELETE cascade
);
-- Table Triggers
create trigger update_topic_answer_modtime before
update
    on
    public.topic_answer for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table topic_answers
----------------------------------------------

CREATE TABLE public.topic_question (
	topic_id int4 not null,
	question_id int4 not null,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE cascade,
	FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE cascade
);
-- Table Triggers
create trigger update_topic_answer_modtime before
update
    on
    public.topic_question for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table tags
----------------------------------------------
CREATE TABLE public.tags (
	id serial NOT NULL,
	tag_name text NOT NULL,
	description text default '',
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	uniq_id uuid DEFAULT uuid_generate_v4 (),
	CONSTRAINT tags_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX ix_tags_tname ON public.tags USING btree (tag_name);
CREATE UNIQUE INDEX ix_tags_uniq_id ON public.tags USING btree (uniq_id);
-- Table Triggers
create trigger update_tag_modtime before
update
    on
    public.tags for each row execute function update_updated_at_column();

----------------------------------------------
----------- CREATE table tags for topic
----------------------------------------------
CREATE TABLE public.tag_topic (
	topic_id int4 NOT NULL,
	tag_id int4 NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE cascade,
	FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE cascade
);
-- Table Triggers
create trigger update_tag_topic_modtime before
update
    on
    public.tag_topic for each row execute function update_updated_at_column();
