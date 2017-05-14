/* This matches any data set with _CHK_ in the name */
%count_rows_in_check_tables(
	fuzzy_match = %nrstr(%^_CHK^_%%) 
	, libref_of_checks = WORK
	, result_tbl = work.s03_check_summary
);

proc sql noprint;
	select sum(bcount) into: failed_total_rows
	from work.s03_check_summary
	;
quit;

%put &=failed_total_rows.;

%macro do_something_with_bad_rows();
	%select_rows_from_checks(
		fuzzy_match = %nrstr(%^_CHK^_%%)
		, libref_of_checks = WORK
		, result_tbl = s03_check_bad_rows
	);

	/* More steps: Maybe a proc export and an email here */

%mend do_something_with_bad_rows;

%proceed_if_flag_ge1(
	flag = &failed_total_rows.
	, macro_to_run =  do_something_with_bad_rows
	, fail_level = N
);

