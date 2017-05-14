/*
	Macro: proceed_if_flag_ge1

	Example usage:

	%macro do_stuff();
		*Stuff;
	%mend do_stuff;

	%let some_flag = 0;

	* This will print an error to the log and not execute %do_stuff();
	%proceed_if_flag_ge1(
		flag = &some_flag.
		, macro_to_run = do_stuff()
		, fail_level = E
	);
*/
%macro proceed_if_flag_ge1(
	flag /* A number to test */
	, macro_to_run /* The macro name to run. Do not prefix with "%". */
	, fail_level /* N, W or E, for NOTE:, WARNING:, or ERROR*/
);
	%if &fail_level. = N %then %let msg_prefix = NOTE:;
	%else %if &fail_level. = W %then %let msg_prefix = WARNING:;
	%else %if &fail_level. = E %then %let msg_prefix = ERROR:;
	%else %put ERROR: Must enter N, W, or E for fail_level parameter;

	%if %eval(&flag. ge 1) %then %do; 
		%put NOTE: Flag is &flag., proceeding with %nrstr(%%)&macro_to_run.;
		%&macro_to_run.;
	%end; 
	%else
		%put &msg_prefix. Flag not GE 1, not running macro: %nrstr(%%)&macro_to_run.;
%mend proceed_if_flag_ge1;


/*
	Macro: proceed_if_flag_is_zero
 
	Example usage:

	%macro do_stuff();
		*Stuff;
	%mend do_stuff;

	%let some_flag = 0;

	* This will print an error to the log and not execute %do_stuff();
	%proceed_if_flag_is_zero(
		flag = &some_flag.
		, macro_to_run = do_stuff()
		, fail_level = W
	);
*/
%macro proceed_if_flag_is_zero(
	flag
	, macro_to_run
	, fail_level /* N, W or E, for NOTE:, WARNING:, or ERROR*/
);

	%if &fail_level. = N %then %let msg_prefix = NOTE:;
	%else %if &fail_level. = W %then %let msg_prefix = WARNING:;
	%else %if &fail_level. = E %then %let msg_prefix = ERROR:;
	%else %put ERROR: Must enter N, W, or E for fail_level parameter;

	%if &flag = 0 %then %do; 
		%put NOTE: Flag is &flag., proceeding with %nrstr(%%)&macro_to_run.;
		%&macro_to_run.;
	%end;
	%else %do;
		%put ERROR: Flag not equal to 0, not running macro: %nrstr(%%)&macro_to_run.;
	%end;
%mend proceed_if_flag_is_zero;