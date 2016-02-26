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
			WHERE is_found is NULL
			ORDER BY id
			LIMIT 5000 --SELECT * FROM public.clear_black_phones();
		LOOP

		col_str := '';
		t_name := '';
		found_in := '';
		
		FOR col IN SELECT table_name, column_name, table_schema
				FROM information_schema.columns
				WHERE table_schema = 'public'
				  AND table_name != 'AA_remove'
				  AND table_name != 'W_Files'
				  AND table_name NOT ILIKE 'CRM_%'
				ORDER BY table_name LOOP

			--phone_1
			IF col.table_name != t_name THEN
				IF t_name != '' THEN
					--RAISE NOTICE 'Processing table % ...', t_name;
					EXECUTE ('SELECT count(*) FROM ' || col_str) INTO res;
					--RAISE NOTICE 'res=% %', res, nums.name;
					IF res>0 THEN
						found_in := found_in || t_name || ', ';
						EXECUTE 'DELETE FROM ' || col_str;
					END IF;
				END IF;
				t_name := col.table_name;
				col_str := quote_ident(col.table_name) || ' WHERE ';
				col_str := col_str || 'TRIM(REPLACE(' || quote_ident(col.column_name) || '::TEXT,''+'',''''))' || 
						'::TEXT ILIKE ''%' || TRIM(REPLACE(nums.phone_1::TEXT,'+','')) || '%'' ';
			ELSE
				col_str := col_str || ' OR ' || 'TRIM(REPLACE(' || quote_ident(col.column_name) || '::TEXT,''+'',''''))' ||
						'::TEXT ILIKE ''%' || TRIM(REPLACE(nums.phone_1::TEXT,'+','')) || '%'' ';
			END IF;

			--phone_2
			IF nums.phone_2 != '0' THEN
				col_str := col_str || ' OR ' || 'TRIM(REPLACE(' || quote_ident(col.column_name) || '::TEXT,''+'',''''))' ||
						'::TEXT ILIKE ''%' || TRIM(REPLACE(nums.phone_2::TEXT,'+','')) || '%'' ';
			END IF;
			
			--SELECT * FROM public.clear_black_phones();
		END LOOP;

		RAISE NOTICE '%    % found_in=%', nums.id, nums.name, found_in;
		UPDATE "AA_remove" 
		SET is_found = found_in 
		WHERE id = nums.id;
		
	END LOOP;
	

	RAISE NOTICE 'Done updating views.';
	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.clear_black_phones()
  OWNER TO postgres;




