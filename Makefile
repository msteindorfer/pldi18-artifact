.PHONY: javaversion

javaversion:
	@(java -version 2>&1 | grep "1\.8" ) || (echo "Wrong Java version: we need Java 8"; exit 1)

clean:
	(rm -f ./benchmark/data/wordpress-cfgs-as-graphs.bin)
	(cd ./benchmark && mvn clean)

update:
	(git pull)
	(cd ./code && git pull)
	(cd ./benchmark && git pull)

unpack_data:
	# unpack data for real-world evaluation
	(cd ./benchmark/data && gunzip --keep --force wordpress-cfgs-as-graphs.bin.gz)

prepare: javaversion
	# build all criterion
	(cd ./benchmark && mvn clean install)
	#(echo <password> | sudo -S Rscript ./benchmark/resources/r/install.r)


# run: javaversion unpack_data
# 	(cd ./benchmark && \
# 		mvn clean package && \
# 		mkdir -p target/results && \
# 		mkdir -p target/result-logs)
#
# 	(cd ./benchmark && ./runMicrobenchmarks.sh && ./runStaticProgramAnalysisCaseStudy.sh)

run: run_microbenchmarks run_static_analysis_case_study

run_microbenchmarks: javaversion unpack_data
	(cd ./benchmark && \
		mvn clean package && \
		mkdir -p target/results && \
		mkdir -p target/result-logs)

	(cd ./benchmark && ./runMicrobenchmarks.sh   1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608   0,1,2,3,4   10   20)


run_microbenchmarks_short: javaversion unpack_data
	(cd ./benchmark && \
		mvn clean package && \
		mkdir -p target/results && \
		mkdir -p target/result-logs)

	(cd ./benchmark && ./runMicrobenchmarks.sh   16,2048,1048576   0   3   3)	


run_static_analysis_case_study: javaversion unpack_data
	(cd ./benchmark && \
		mvn clean package && \
		mkdir -p target/results && \
		mkdir -p target/result-logs)

	(cd ./benchmark && ./runStaticProgramAnalysisCaseStudy.sh)

postprocessing: javaversion
	# run postprocessing of benchmark data (create plots, etc) as of paper submission
	(Rscript ./benchmark/resources/r/benchmarks.r `cd ./data && pwd` `cat ./benchmark/LAST_TIMESTAMP_MICROBENCHMARKS.txt`)

# run_prebuilt: javaversion unpack_data
# 	(cd ./benchmark && \
# 		rm -rf target && \
# 		mkdir -p target/results && \
# 		mkdir -p target/result-logs)
#
# 	(cd ./benchmark && \
# 		cp lib/benchmarks.jar target)
#
# 	(cd ./benchmark && ./runMicrobenchmarks.sh && ./runStaticProgramAnalysisCaseStudy.sh)

postprocessing_cached: javaversion
	# run postprocessing of benchmark data (create plots, etc) as of paper submission
	(Rscript ./benchmark/resources/r/benchmarks.r `cd ./data && pwd` 20170417_1554)
