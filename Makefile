.PHONY: javaversion

javaversion:
	@(java -version 2>&1 | grep "1\.8" ) || (echo "Wrong Java version: we need Java 8"; exit 1)

clean:
	(rm -f ./benchmark/data/wordpress-cfgs-as-graphs.bin)
	(cd ./benchmark && mvn clean)

unpack_data:
	# unpack data for real-world evaluation
	(cd ./benchmark/data && gunzip --keep --force wordpress-cfgs-as-graphs.bin.gz)

prepare: javaversion
	# build all criterion
	(cd ./benchmark && mvn clean install)

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

	(cd ./benchmark && ./runMicrobenchmarks.sh)

run_static_analysis_case_study: javaversion unpack_data
	(cd ./benchmark && \
		mvn clean package && \
		mkdir -p target/results && \
		mkdir -p target/result-logs)

	(cd ./benchmark && ./runStaticProgramAnalysisCaseStudy.sh)

postprocessing: javaversion
	# run postprocessing of benchmark data (create plots, etc) as of paper submission
	(Rscript ./benchmark/resources/r/benchmarks.r `cd ./data && pwd` `cat ./benchmark/LAST_TIMESTAMP_MICROBENCHMARKS.txt`)

run_prebuilt: javaversion unpack_data
	(cd ./benchmark && \
		rm -rf target && \
		mkdir -p target/results && \
		mkdir -p target/result-logs)

	(cd ./benchmark && \
		cp lib/benchmarks.jar target)

	(cd ./benchmark && ./runMicrobenchmarks.sh && ./runStaticProgramAnalysisCaseStudy.sh)

postprocessing_cached: javaversion
	# run postprocessing of benchmark data (create plots, etc) as of paper submission
	(Rscript ./benchmark/resources/r/benchmarks.r `cd ./data && pwd` 20170417_1554)
