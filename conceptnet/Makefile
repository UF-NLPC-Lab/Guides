
data: sandbox data_commands.sh
	apptainer run --writable sandbox /data_commands.sh

sandbox: conceptnet.sif
	apptainer build -F --sandbox sandbox/ conceptnet.sif

conceptnet.sif: conceptnet.def
	APPTAINERENV_TMPDIR=/tmp apptainer build -F conceptnet.sif conceptnet.def

clean:
	rm -rf sandbox/ *.sif
