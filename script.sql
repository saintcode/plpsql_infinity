-- Function: public.clear_black_phones()

-- DROP FUNCTION public.clear_black_phones();

CREATE OR REPLACE FUNCTION public.clear_black_phones()
  RETURNS character AS
$BODY$
DECLARE
    mviews RECORD;
    nums RECORD;
    col RECORD;
    col_str TEXT;
    t_name TEXT;
    res INTEGER;
BEGIN

	FOR nums IN SELECT *
			FROM "AA_remove"
			WHERE is_removed is NULL
			ORDER BY id LOOP

		col_str := '';
		t_name := '';
		
		FOR col IN SELECT *
				FROM information_schema.columns
				WHERE table_schema = 'public'
				  AND table_name   != 'AA_remove'
				ORDER BY table_name LOOP
			
			--RAISE NOTICE 'column %', col.column_name;
			--RAISE NOTICE 'Processing table % ...', col.table_name;
			IF col.table_name != t_name THEN
				t_name := col.table_name;
				col_str := 'SELECT count(*) FROM ' || quote_ident(col.table_name) || ' WHERE ';
				col_str := col_str || quote_ident(col.column_name) || '::TEXT ilike ''%' || nums.phone_1::TEXT || '%'' ';
			ELSE
				col_str := col_str || ' OR ' || quote_ident(col.column_name) || '::TEXT ilike ''*' || nums.phone_1::TEXT || '*'' ';
			END IF;
			
			
		END LOOP;
		
		EXECUTE col_str INTO res;
		RAISE NOTICE 'res=% % %', res, nums.name, col_str;
		
		--EXECUTE 'INSERT INTO '
		--           || quote_ident(mviews.mv_name) || ' '
		--           || mviews.mv_query;
		--FOR mviews IN SELECT table_schema,table_name
		--		FROM information_schema.tables
		--		WHERE table_schema='public'
		--		ORDER BY table_schema,table_name LOOP
		--END LOOP;
	    
	END LOOP;
	

	RAISE NOTICE 'Done updating views.';
	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.clear_black_phones()
  OWNER TO postgres;


--SELECT * FROM public.clear_black_phones();

