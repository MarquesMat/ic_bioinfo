#!/bin/bash

# Este script realiza as análises dos genomas de bactérias da mesma espécie
# A montagem do pangenoma é feita utilizando as ferramentas Prokka e Roary
# Ao final da execução, é gerado um relatório com o tempo e demais informações relevantes
# OBS: Execute o seguinte comando antes e depois de usar o ambiente conda: export PATH="/usr/bin:$PATH"

### Caminhos
# Caminho para este diretório
path="$(cd "$(dirname "$0")" && pwd)/"
# Caminho para os genomas de uma espécie de bactéria do gênero Maribacter
path_fasta="${path}fasta/"
# Caminho para salvar os resultados que serão analisados pelo Roary
path_roary="${path}roary/"
# Caminho para salvar os resultados do Roary
path_results="${path_roary}results/"

# Gerar um relatório com o tempo de execução
report="${path}report.txt"
touch $report

# PROKKA
echo "Iniciando programa Prokka" > $report 
echo "$(date "+%Y-%m-%d %H:%M:%S")" >> $report

# Ativar o ambinete conda
source /root/miniconda3/bin/activate

# Diretórios contendo os genomas
dir=$(find $path_fasta -mindepth 1 -maxdepth 1 -type d -not -name ".")

# id="0" # Só utilizar se for numerar os diretórios

# Percorrer cada diretório
for d in $dir; do
	# (( id++ ))
	id=$(basename $d)
	# Obter o nome do arquivo *fna
	fna=$(ls "${d}" | grep fna)
	path_fna="${d}/${fna}"

	# Executar o Prokka
	prokka --cpus 12 --kingdom Bacteria --outdir "${path_roary}data_${id}" --genus Maribacter --locustag "Data_${id}" "${path_fna}" >> $report
done

# Gravar o horário em que o programa terminou
echo -e "Fim do programa\n$(date "+%Y-%m-%d %H:%M:%S")\n" >> $report 


# ROARY
echo -e "Iniciando programa Roary\n$(date "+%Y-%m-%d %H:%M:%S")\n" >> $report 

# Diretórios contendo os genomas os resultados do Prokka
dir=$(find $path_roary -mindepth 1 -maxdepth 1 -type d -not -name ".")

# Percorrer cada diretório
for d in $dir; do
	id=$(basename $d)
	# Obter o nome do arquivo  gff
	gff=$(ls "${d}" | grep gff)
	path_gff="${d}/${gff}"

	# Copiar para outro diretório e renomear
	cp "${path_gff}" "${path_roary}data_${id}.gff"
done

# Usar o Roary
roary -f ${path_results} -e --mafft -p 12 -n -v ${path_roary}*.gff >> $report

# Desativar o ambiente conda
conda deactivate

# Gravar o horário em que o programa terminou
echo -e "Fim do programa\n$(date "+%Y-%m-%d %H:%M:%S")\n" >> $report
