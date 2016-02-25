
DROP TABLE IF EXISTS public."AA_remove";
DROP SEQUENCE IF EXISTS public."AA_remove_id_seq";

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
