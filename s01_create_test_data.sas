%let test_data_start_dt = "01jan2015"d;

/*
	Get a subset of the SASHELP.CARS data set supplied by SAS, and use it to make 24 months 
	worth of test data.
	
	With each month, the MSRP will increase.
*/

data s01a_test_data(drop=dateIncrement);
	format measure_month date9.;
	
	/* Loop for 24 months, each time loading the sashelp.cars table and increasing the MSRP */
	do dateIncrement = 0 to 23;
		/* Get the next month based on where we are in the loop */
		measure_month = intnx('month',&test_data_start_dt.,dateIncrement,'beginning');
		do i = 1 to car_count;
			set sashelp.cars(keep=make model Type drivetrain Origin MSRP Cylinders) point=i nobs=car_count;
			model = left(model);
			msrp = msrp + (100 * dateIncrement);
			output;
		end; 
	end;
	stop;
run;

/* Create some bad data that we will detect in a later step */
proc sql;
	insert into s01a_test_data

	/* Bad cylinder counts */
	values ("01dec2016"d, "Toyota", "RAV5", "SUV", "Asia", "Front", 25000, -4) 
	values ("01dec2016"d, "Toyota", "RAV8a", "SUV", "Asia", "Front", 31000, 80)
	values ("01dec2016"d, "Toyota", "RAV8b", "SUV", "Asia", "Front", 31000, 3.5)

	/* Bad prices */
	values ("01dec2016"d, "Audi", "Foo", "SUV", "Asia", "Front", 58, 6)
	values ("01dec2016"d, "Audi", "Bar", "SUV", "Asia", "Front", -25000, 6)
	values ("01dec2016"d, "Audi", "Llama", "SUV", "Asia", "Front", ., 6)

	/* Duplicate record based on measure_month, make, model, drivetrain */
	values ("01dec2016"d, "Saab", "9-5 Aero", "Wagon", "Europe", "Front", 50000, 4) 

	/* Bad Type */
	values ("01dec2016"d, "Nissan", "Who Cares", "BadValue", "USA", "Front", 40000, 4) 

	/* Bad Drive Train */
	values ("01dec2016"d, "Nissan", "Awesome", "Wagon", "USA", "Apple", 45000, 4) 
	;
quit;
	