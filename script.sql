CREATE OR REPLACE FUNCTION clear_black_phones() RETURNS char AS $$
DECLARE
    mviews RECORD;
    col RECORD;
    res INTEGER;
BEGIN

    FOR mviews IN SELECT table_schema,table_name
			FROM information_schema.tables
			WHERE table_schema='public'
			ORDER BY table_schema,table_name LOOP
	RAISE NOTICE 'Processing table % ...', mviews.table_name;

	FOR col IN SELECT *
			FROM information_schema.columns
			WHERE table_schema = 'public'
			  AND table_name   = 'A_Version' LOOP
		RAISE NOTICE 'column %', col.column_name;
	END LOOP;
        
        EXECUTE 'SELECT count(*) FROM ' || quote_ident(mviews.table_name) INTO res;
        RAISE NOTICE 'res %', res;
        --EXECUTE 'INSERT INTO '
        --           || quote_ident(mviews.mv_name) || ' '
        --           || mviews.mv_query;
    END LOOP;

    RAISE NOTICE 'Done updating views.';
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

SELECT clear_black_phones();