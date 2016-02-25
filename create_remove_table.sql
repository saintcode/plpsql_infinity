
DROP TABLE IF EXISTS public."AA_remove";
DROP SEQUENCE IF EXISTS public."AA_remove_id_seq";

--CREATE SEQUENCE public."AA_remove_id_seq"
--	INCREMENT 1
--	MINVALUE 1
--	MAXVALUE 9223372036854775807
--	START 1
--	CACHE 1;

CREATE TABLE public."AA_remove"
(
	id bigserial NOT NULL,
	name text,
	phone_1 text,
	phone_2 text,
	email text,
	is_found text
)
WITH (
	OIDS=FALSE
);
ALTER TABLE public."AA_remove"
		OWNER TO postgres;
