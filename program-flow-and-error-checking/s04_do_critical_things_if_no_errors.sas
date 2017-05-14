%macro do_critical_things();
	%put Do some emailing and super cool high 
		stakes things that require clean data.
	;
%mend do_critical_things;

/*
	Proceed if flag is zero, otherwise print an error
	to the log
*/
%proceed_if_flag_is_zero(
	flag = &failed_total_rows.
	, macro_to_run = do_critical_things
	, fail_level = E
);
