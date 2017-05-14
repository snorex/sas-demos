/*
	Get the number of observations in datasets that match the fuzzy parameter
*/
%macro count_rows_in_check_tables(
	fuzzy_match /* The PROC SQL "LIKE" pattern to match on. Wrap in %nrstr() and escape underscores using "^". "%" is wildcare match */
	, libref_of_checks /* The libref to search for the checks */
	, result_tbl /* The table to store the resulting rows. Libref is optional */
);

	proc sql;
		create table &result_tbl.
			(
			blabel char(256),
			btbl  char(32),
			bcount num
			);
	quit;

	proc sql noprint;
		insert into &result_tbl.

		select memlabel, memname, nobs 

		from dictionary.tables 

		where libname =upcase("&libref_of_checks.")
		and
		memname like  upcase(%tslit(&fuzzy_match))
		escape '^'
		;
	quit;

%mend count_rows_in_check_tables;

/*%count_rows_in_check_tables(*/

