%macro select_rows_from_checks(
	fuzzy_match /* The PROC SQL "LIKE" pattern to match on. Wrap in %nrstr() and escape underscores using "^". "%" is wildcare match */
	, libref_of_checks /* The libref to search for the checks */
	, result_tbl /* The table to store the resulting rows. Libref is optional */
);
		
	proc sql;
		select Memname

		INTO :select_checks_like_tbls SEPARATED BY ' '

		from dictionary.tables 

		where libname= upcase("&libref_of_checks.")
		and
		memname like upcase(%tslit(&fuzzy_match.))
		escape '^'
		;
	quit;

	data &result_tbl.;
		set &select_checks_like_tbls;
	run;

%mend select_rows_from_checks;

