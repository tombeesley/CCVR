# CCVR experiment details
A repository containing a series of contextual cuing experiments run in VR (Oculus Rift)

CCVR01 and CCVR02 were intial pilot work establishing the procedure. Currently not written up in any form

CCVR03 built on this pilot work with a basic design to establish contextual cuing with distractors at different depths.

CCVR04 manipulated the position of repeating distractors, either on the same surface as the target, or the alternative surface

CCVR05 manipulated the depth of already learnt distractor patterns in a final phase, in an attempt to ascertain further whether depth plays a role in the performance of CC. This experiment lacked sufficient power and is not reported. It is being written up for psyarxiv.

CCVR_ms_1 is the manuscript which presents the data from CCVR03 and CCVR04, currently under review at JEP:HPP

# To run the analyses

Analyses performed exclusively in R. 

CCVR03 and CCVR04 each have two analysis files. One is a .R file that is used to assemble the raw data and perform initial processing steps to tidy the data. The second is a .Rmd file that will perform the bulk of the analysis, produce figures and stats, etc. The output of this second stage is sent to the CCVR_ms_1 folder as (e.g.) "CCVR03_export.RData". The manuscript is generated with a .Rmd file, which performs further analyses and plotting.

# To run the experiments

There is a program which can be run with Unity and Oculus Rift in the top level folder (.zip file). 

The program generates stimuli on the basis of input files (.txt). These are generated in Matlab, and each experiment has its own set of files for generating the input files. In each case "CreatePats" is the main file that needs to be run to generate the files. You need an empty "Order" and "Patterns" folder next to these matlab files. 

Please contact t.beesley@lancaster.ac.uk with any queries about the analysis or experiments.

