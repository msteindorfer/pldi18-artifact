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


## Executing the Benchmarks

We wanted to make the use of our artifact as simple as possible. If the system requirements are fulfilled, the reproduction of our results require the execution of three commands in a console/terminal:

Moving into the artifacts directory:
> cd pldi18-artifact

Setting up and compiling the artifacts:
> make prepare

Running microbenchmarks and real-world benchmarks:
> make run

Running result analysis and post-processing:
> make postprocessing

The first command does not consume time. The second command should take approximately five minutes to complete and should complete without errors. The third command however will take up to two days. (E.g., in our real-world evaluation the slowest single invocation completes in 30 minutes. For statistical testing of our results we invoke every benchmarks multiple times.) Step four, the analysis and postprocessing takes around a minute or less usually.

We further included all results that we obtained form step number three. Consequently our results can be evaluated without the necessity to execute our automated benchmark suite. We provide an extra command for this purpose:
> make postprocessing_cached

To manually inspect what the **make** commands do, have a look at *pldi18-artifact/Makefile*.


## Key Data Items of our Evaluation
Our cached results are contained in the folder *data/20170417_1554*. 

The following files contain data from the microbenchmarks that are discussed in Section 6 of the paper:

* **results.all-20170417_1554.log**: comma-separated values (CSV) file containing microbenchmark results of runtimes of individual operations
* **map_sizes_heterogeneous_exponential_32bit_20170417_1554**: CSV file containing memory footprints in a 32-bit JVM setting.
* **map_sizes_heterogeneous_exponential_64bit_20170417_1554**: CSV file containing memory footprints in a 64-bit JVM setting.

These CSV files are then processed by *benchmarks.r*, a R script, and produce directly the boxplots of Figures 4, 5, and 6 of page 8 of the paper. The boxplots are named **all-benchmarks-vf_champ_multimap_hhamt_by_vf_(scala|clojure|champ_map_as_multimap-map)-boxplot-speedup.pdf**.


Unfortunately, we do not have saved the cached log files of the static program analysis case study (cf. Chapter 6 and Table 1). However, when executing the benchmark a CSV file named *results.all-real-world-$TIMESTAMP.log* will be regenerated in the result data directory.


## Key Source Items of our Artifact
Our AXIOM hash trie implementations can be found under *code/capsule-experimental/src/main/java/io/usethesource/capsule/experimental/multimap/TrieSetMultimap_HHAMT.java*, for people interested in manually inspecting the implementation.

The packages *benchmark/src/main/scala/io/usethesource/criterion/impl/persistent/scala*  and *benchmark/src/main/java/io/usethesource/criterion/impl/persistent/clojure* contain simple interface facades that enables cross-library benchmarks under a common API.

The benchmark implementations can be found in the *benchmark* project.  File *benchmark/src/main/java/dom/multimap/DominatorsSetMultimap_Default.java* implements the real-word experiment (Section 6 of the paper).

File *JmhSetMultimapBenchmarks.java* measures the runtimes of individual operations, whereas *CalculateHeterogeneousFootprints.java* performs footprint measurements (cf. page 8, Figures 4, 5, and 6).  Note that the benchmarks contain default parameters for their invocation, the actual parameters are set in *runMicrobenchmarks.sh* and *runStaticProgramAnalysisCaseStudy.sh*.
