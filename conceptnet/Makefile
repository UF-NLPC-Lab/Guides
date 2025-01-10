
data: sandbox data_commands.sh
	apptainer run --writable sandbox /data_commands.sh

sandbox: conceptnet.sif
	rm -rf sandbox/ && apptainer build --sandbox sandbox/ conceptnet.sif

conceptnet.sif: conceptnet.def
	apptainer build -F conceptnet.sif conceptnet.def

clean:
	rm -rf sandbox/ *.sif pg.log
	@echo 'You might want to "rm -rf pg_data/" too, but we don't do it automatically so you don't accidentally delete it.'
