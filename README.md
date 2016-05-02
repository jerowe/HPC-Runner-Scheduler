# NAME

HPC::Runner::Scheduler - Base Library for HPC::Runner::Slurm and HPC::Runner::PBS

# SYNOPSIS

    pbsrunner.pl/slurmrunner.pl/mcerunner.pl --infile list_of_commands

# DESCRIPTION

HPC::Runner::Scheduler is a base library for creating templates of HPC Scheduler (Slurm, PBS, etc) submission scripts.

All the scheduler variables: memory, cpus, nodes, partitions/queues, are abstracted to a template. Instead of writing an entire submission template

    slurmrunner.pl --infile list_of_commands #with list of optional parameters

Please see the indepth usage guide at [HPC::Runner::Usage](https://metacpan.org/pod/HPC::Runner::Usage)

# User Options

User options can be passed to the script with script --opt1 or in a configfile. It uses MooseX::SimpleConfig for the commands

## configfile

Config file to pass to command line as --configfile /path/to/file. It should be a yaml or xml (untested)
This is optional. Paramaters can be passed straight to the command line

### example.yml

    ---
    infile: "/path/to/commands/testcommand.in"
    outdir: "path/to/testdir"
    module:
        - "R2"
        - "shared"

## infile

infile of commands separated by newline

### example.in

    cmd1
    cmd2 --input --input \
    --someotherinput
    wait
    #Wait tells slurm to make sure previous commands have exited with exit status 0.
    cmd3  ##very heavy job
    newnode
    #cmd3 is a very heavy job so lets start the next job on a new node

## module

modules to load with slurm
Should use the same names used in 'module load'

Example. R2 becomes 'module load R2'

## afterok

The afterok switch in slurm. --afterok 123 will tell slurm to start this job after job 123 has completed successfully.

## cpus\_per\_task

slurm item --cpus\_per\_task defaults to 4, which is probably fine

## commands\_per\_node

\--commands\_per\_node defaults to 8, which is probably fine

## nodes\_count

Number of nodes to use on a job. This is only useful for mpi jobs.

PBS:
\#PBS -l nodes=nodes\_count:ppn=16 this

Slurm:
\#SBATCH --nodes nodes\_count

## partition

\#Should probably have something at some point that you can specify multiple partitions....

Specify the partition. Defaults to the partition that has the most nodes.

## nodelist

Defaults to the nodes on the defq queue

## submit\_slurm

Bool value whether or not to submit to slurm. If you are looking to debug your files, or this script you will want to set this to zero.
Don't submit to slurm with --nosubmit\_to\_slurm from the command line or
$self->submit\_to\_slurm(0); within your code

## first\_pass

Do a first pass of the file to get all the stats

## template\_file

actual template file

One is generated here for you, but you can always supply your own with --template\_file /path/to/template

## serial

Option to run all jobs serially, one after the other, no parallelism
The default is to use 4 procs

## user

user running the script. Passed to slurm for mail information

## use\_threads

Bool value to indicate whether or not to use threads. Default is uses processes

If using threads your perl must be compiled to use threads!

## use\_processes

Bool value to indicate whether or not to use processes. Default is uses processes

## use\_gnuparallel

Bool value to indicate whether or not to use processes. Default is uses processes

## use\_custom

Supply your own command instead of mcerunner/threadsrunner/etc

# Internal Variables

You should not need to mess with any of these.

## template

template object for writing slurm batch submission script

## cmd\_counter

keep track of the number of commands - when we get to more than commands\_per\_node restart so we get submit to a new node.
This is the number of commands within a batch. Each new batch resets it.

## node\_counter

Keep track of which node we are on

## batch\_counter

Keep track of how many batches we have submited to slurm

## node

Node we are running on

## batch

List of commands to submit to slurm

## cmdfile

File of commands for mcerunner/parallelrunner
Is cleared at the end of each slurm submission

## slurmfile

File generated from slurm template

## slurm\_decides

Do not specify a node or partition in your sbatch file. Let Slurm decide which nodes/partition to submit jobs.

## job\_stats

HashRef of job stats - total jobs submitted, total processes, etc

# SUBROUTINES/METHODS

## run()

First sub called
Calling system module load \* does not work within a screen session!

## do\_stats

Do some stats on our job stats
Foreach job name get the number of batches, and have a put that in batches->batch->job\_batches

## check\_files()

Check to make sure the outdir exists.
If it doesn't exist the entire path will be created

## parse\_file\_slurm

Parse the file looking for the following conditions

lines ending in \`\\\`
wait
nextnode

Batch commands in groups of $self->cpus\_per\_task, or smaller as wait and nextnode indicate

## check\_meta

allow for changing parameters mid through the script

\#Job1
echo "this is job one" && \\
    bin/dostuff bblahblahblah

\#HPC cpu\_per\_task=12

echo "This is my new job with new HPC params!"

## work

Get the node #may be removed but we'll try it out
Process the batch
Submit to slurm
Take care of the counters

## collect\_stats

Collect job stats

## process\_batch()

Create the slurm submission script from the slurm template
Write out template, submission job, and infile for parallel runner

## process\_batch\_command

splitting this off from the main command

# AUTHOR

Jillian Rowe &lt;jillian.e.rowe@gmail.com>

# COPYRIGHT

Copyright 2016- Jillian Rowe

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[HPC::Runner::Slurm](https://metacpan.org/pod/HPC::Runner::Slurm)
[HPC::Runner::PBS](https://metacpan.org/pod/HPC::Runner::PBS)
[HPC::Runner::MCE](https://metacpan.org/pod/HPC::Runner::MCE)
