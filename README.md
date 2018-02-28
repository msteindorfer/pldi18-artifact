# Getting Started Guide

The evaluation of our PLDI'18 paper entitled _To-many or To-one? All-in-one! --- Efficient Purely Functional Multi-Maps with Type-Heterogeneous Hash-Tries_ consists of microbenchmarks and a case study in program analysis, both benchmarks execute fully automated. 


## Requirements

We assume basic familiarity with UNIX terminals and command line tools. The artifact was tested under UNIX operating systems (i.e., Ubuntu Linux 16.04.3.LTS and Apple macOS). The artifact requires the following resources to run:

* Command line tools:
	* java (version 8),
	* maven,
	* make,
	* ant, 
	* R and RScript
* Internet connection (for automatically downloading dependencies).

The execution time benchmarks are configured to use heap sizes of 8GB, whereas the memory measurments use 16GB. Thus computers or virtual machiens with at least 8GB RAM are recommended.


For ease of use, we created a virtual machine with tools, benchmarks, and data setup. As basis we used the **Ubuntu Linux 16.04.3.LTS** distribution, installed in a [**VirtualBox**](https://www.virtualbox.org) virtual machine (version 5.2.6) with the **Oracle VM VirtualBox Extension Pack** installed. Go to [www.virtualbox.org](www.virtualbox.org) for downloading the software and installation instructions.

The virtual machine has the following packages installed in order to satisfy our requirements:

* `sudo apt install git`
* `sudo apt install default-jdk`
* `sudo apt install maven`
* `sudo apt install openssh-server`
* `sudo apt install r-base r-base-dev`


## SSH access to Virtual Machine

For more convenient usage of the artifact, the authors are asked to setup remote access via terminal according to the stackoverflow answer [How to SSH to a VirtualBox guest externally through a host?](https://stackoverflow.com/questions/5906441/how-to-ssh-to-a-virtualbox-guest-externally-through-a-host). Afterwards, users of the artifact can log into the virtual machine with the following command line:

> ssh -p 3022 axiom@localhost

When prompted for a password, use the password "axiom" (i.e., the same as the username that is already provided in the commannd line).


## Executing the Benchmarks and Data Post-Processing Pipeline

Thh execution of benchmark referred to in the evaluation Sections 4, 5, and 6 of the paper, are entriely automated. The data post-processing of the data used in Sections 4 and 5 (cf. Figures 4, 5 and 6) are automated as well. 

Getting started with reproducing our resutls requires the execution of following commands in a console/terminal after being logged into our virtual machine:

Moving into the artifacts directory:
> cd pldi18-artifact

Setting up and compiling the artifacts:
> make prepare

(To manually inspect what the **make** commands do, have a look at *pldi18-artifact/Makefile*.)


### (Quickly) Evaluating Archived Data concerning Sections 4 and 5

Next, one can re-generate the boxplots of the Figures 4, 5 and 6 (page 8 of the paper) based the logs that we obtained when executing the benchmarks ourselves.

Our cached results are contained in the folder *data/20170417_1554*. The folder contains the following files:

* **results.all-20170417_1554.log**: comma-separated values (CSV) file containing microbenchmark results of runtimes of individual operations
* **map_sizes_heterogeneous_exponential_32bit_20170417_1554**: CSV file containing memory footprints in a 32-bit JVM setting.
* **map_sizes_heterogeneous_exponential_64bit_20170417_1554**: CSV file containing memory footprints in a 64-bit JVM setting.
* **hamt-benchmark-results-20170417_1554.tgz**: an archieve containing the files mentioned above verbose console output from running the benchmarks.

The folder addionally contains three PDFs that were generated from the data files referenced above. The files correspond directly to the boxplots of Figures 4, 5, and 6 of page 8 of the paper. The boxplots are named **all-benchmarks-vf_champ_multimap_hhamt_by_vf_(scala|clojure|champ_map_as_multimap-map)-boxplot-speedup.pdf** and were generated with the following command, which should finish in a few seconds:

> make postprocessing_cached

The reviewer may delete the three PDFs and re-generate them by with the command. An R script that is located under *benchmark/resources/r/benchmarks.r* performs the data post-processing and generation of the plots.


### (Relatively Quickly) Re-executing the whole Pipeline with a Reduced Dataset concerning Sections 4 and 5

The following commands re-execute the benchmarks for a reduced data set (with not statistically significant results) for the data structure sizes 16, 2048 and 1048576:

Running reduced set of microbenchmarks:
> make run_microbenchmarks_short

Benchmarking should approximately be finished in 15 to 30 minutes. After the benchmarks finished, the *data* directory should contain a new timestamped sub-folder with the benchmark results. After executing the following post-processing command, the folder should once again contain three PDFs / figures with boxplots:

Running result analysis and post-processing:
> make postprocessing

Note, that the results are neither statistically significant, nor do the cover a representative set of data structures size or data points in general. Nevertheless, the shape the boxplots may be similar to the figures in the paper.


### (Extremely Long) Re-executing the whole Pipeline with the Full Dataset concerning Sections 4 and 5

Running reduced set of microbenchmarks:
> make run_microbenchmarks

Running result analysis and post-processing:
> make postprocessing

Benchmarking the full data set can take up to two days of processing and should be performed on a dedicated machine without load or extraneous processes running in order to yield reliable results (see paper section about experimental setup and related work).


### (Relatively Quickly) Re-executing the Static Analysis Case Study concerning Section 6

Running case study benchmarks:
> make run_static_analysis_case_study

Executing the case study benchmark I guess takes approximatley 1 to 2 hours. The benchmark results should be shown in tabular form in the terminal at the end of the benchmark run, and also serialized to disk (to a CSV file named *results.all-real-world-$TIMESTAMP.log*).

Post-processing the data of this benchmark was not automated, and instead done by hand. However, it should be observable that the benchmark results for CHAMP and AXIOM are roughly the same. Note that abbreviations used in the benchmark setup do not match the names in the paper, i.e., CHART is used for CHAMP, and VF_CHAMP_MULTIMAP_HHAMT is used for AXIOM. The results cover the first three columns of Table 1.

Colums 3-6 of Table 1 were also extracted manually with an instrumented version of the benchmark (cf. file *benchmark/src/main/java/dom/multimap/DominatorsSetMultimap_Default_Instrumented.java*).


## Other Relevant Items of our Artifact

Our AXIOM hash trie implementations can be found under *code/capsule-experimental/src/main/java/io/usethesource/capsule/experimental/multimap/TrieSetMultimap_HHAMT.java*, for people interested in manually inspecting the implementation.

The packages *benchmark/src/main/scala/io/usethesource/criterion/impl/persistent/scala* and *benchmark/src/main/java/io/usethesource/criterion/impl/persistent/clojure* contain simple interface facades that enables cross-library benchmarks under a common API.

The benchmark implementations can be found in the *benchmark* project.  File *benchmark/src/main/java/dom/multimap/DominatorsSetMultimap_Default.java* implements the real-word experiment (Section 6 of the paper), and file *benchmark/src/main/java/dom/multimap/DominatorsSetMultimap_Default_Instrumented.java* was used to extracting further statistics (colums 4-6 of Table 1).

File *JmhSetMultimapBenchmarks.java* measures the runtimes of individual operations, whereas *CalculateHeterogeneousFootprints.java* performs footprint measurements (cf. page 8, Figures 4, 5, and 6). Note that the Java benchmark classes contain default parameters for their invocation, however the actual parameters are set in *runMicrobenchmarks.sh* and *runStaticProgramAnalysisCaseStudy.sh*.
