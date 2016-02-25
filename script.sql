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
    found_in TEXT;
    t_name TEXT;
    res INTEGER;
BEGIN

	FOR nums IN SELECT *
			FROM "AA_remove"
			WHERE is_removed is NULL
			ORDER BY id LOOP

		col_str := '';
		t_name := '';
		found_in := '';
		
		FOR col IN SELECT *
				FROM information_schema.columns
				WHERE table_schema = 'public'
				  AND table_name != 'AA_remove'
				  AND table_name != 'W_Files'
				ORDER BY table_name LOOP
			
			IF col.table_name != t_name THEN

				IF t_name != '' THEN
					--RAISE NOTICE 'Processing table % ...', t_name;
					EXECUTE col_str INTO res;
					--RAISE NOTICE 'res=% %', res, nums.name;
					IF res>0 THEN
						found_in := found_in || t_name || ', ';
					END IF;
				END IF;
			
				t_name := col.table_name;
				
				col_str := 'SELECT count(*) FROM ' || quote_ident(col.table_name) || ' WHERE ';
				col_str := col_str || 'TRIM(REPLACE(' || quote_ident(col.column_name) || '::TEXT,''+'',''''))' || 
						'::TEXT ILIKE ''%' || nums.phone_1::TEXT || '%'' ';
			ELSE
				col_str := col_str || ' OR ' || 'TRIM(REPLACE(' || quote_ident(col.column_name) || '::TEXT,''+'',''''))' ||
						'::TEXT ILIKE ''%' || nums.phone_1::TEXT || '%'' ';
			END IF;
			--SELECT * FROM public.clear_black_phones();
			
			
		END LOOP;

		RAISE NOTICE '% found_in=%', nums.name, found_in;
		UPDATE "AA_remove" SET is_found=found_in;
		
		
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

