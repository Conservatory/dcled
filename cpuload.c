/* cpuload - a demo program for feeding data into dcled's tachometer mode.
 * Copyright 2014 Jeff Jahr <malakai@jeffrika.com> */

/* This is free software.  G'head, use it all you want. This program reads the
 * first line out of Linux's /proc/stat file to get stats on the different cpu
 * utilization states.  It tallys up the data to come up with a CPU load-
 * percentage of time spent out of idle mode.  It prints the percentage as an
 * integer, one sample per line.  This program probably won't work on anything
 * but Linux, and may not even parse all /proc/stat formats correctly.  Its
 * meant to be a demo of what dcled's tach mode can be used for.  
 * Sat Feb  8 18:04:06 PST 2014 -jsj */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

float cpuload(int user, int nice, int sys, int idle) {
	
	float t;
	t=(user+nice+sys);
	return( 100*t/(t+idle) );
}

int main(int argc, char **argv) {

	FILE *in;
	char filename[] = "/proc/stat";
	unsigned long int stat[2][4];
	char *tag=NULL;
	int count;
	int phase=0;
	int i;
	float load=0;
	struct timespec snooze;
	char line[8192];
	float defperiod = 1.0;
	float period;

	period = defperiod;

	if(argc == 2) {
		period = atof(argv[1]);
		if(period <= 0) {
			fprintf(stderr,"%s takes one argument, the polling frequency in seconds.\n",argv[0]);
			fprintf(stderr,"Default is %f\n",defperiod);
			exit(EXIT_FAILURE);
		}
	}

	snooze.tv_sec=(int)period;
	snooze.tv_nsec=(1000000000*(period-(int)period));

	/* init */
	for(i=0;i<4;i++) {
		stat[0][i]=0;
		stat[1][i]=0;
	}

	/* main loop */

	while (1) {
		if(!(in=fopen(filename,"r"))) {
			perror("Couldn't open stats file.");
			exit(EXIT_FAILURE);
		}

		tag=NULL;
		if(!fgets(line,8192,in)) {
			continue;
		}
		count = sscanf(line,"%ms %lu %lu %lu %lu",
			&tag, 
			&(stat[phase][0]),
			&(stat[phase][1]),
			&(stat[phase][2]),
			&(stat[phase][3])
		);

		if(count!=5) {
			fprintf(stderr,"Didn't read the right number of values, got %d out of\n%s\n",
				count,line);
			exit(EXIT_FAILURE);
		}

		if(!strcmp(tag,"cpu ")) {
			fprintf(stderr,"Didn't read the right tag...\n");
			exit(EXIT_FAILURE);
		} else {
			free(tag);
		}

		load = cpuload(
			stat[phase][0] - stat[phase^1][0],
			stat[phase][1] - stat[phase^1][1],
			stat[phase][2] - stat[phase^1][2],
			stat[phase][3] - stat[phase^1][3]
		);

		fprintf(stdout,"%d\n",(int)load);
		fflush(stdout);

		fclose(in);
		nanosleep(&snooze,NULL);
		phase = phase^1;
	}

}

