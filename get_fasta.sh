#!/bin/bash

# Este script baixa os arquivos fasta de genomas diretamento do NCBI
# Arquivos externos: Lista com os IDs dos genomas

# Caminho para este script
path=$(cd $(dirname $0) && pwd)
# Caminho para o resultado do comando wget
path_output="${path}/output"
output="${path_output}/genoma.zip"
# Caminho para salvar as pastas com os arquivos fasta
path_fasta="${path}/fasta"
# Caminho para a lista de IDs dos genomas que serão extraídos
ids="${path}/ids/ids.txt"

# Comando para baixar somente o fasta do GCA
# wget "https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/GCA_001865655.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED" -O $output

# Comando para baixar somente o fasta do GCF
# wget "https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/GCF_001865655.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED" -O $output

while read -r id; do
    #echo "Linha: $id"
    mkdir $path_output
    command="https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/${id}/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED"
    wget $command -O $output
    unzip -o -d $path_output $output
    rm $output
    new_fasta="${path_fasta}/${id}"
    mkdir $new_fasta
    fasta_file=$(find $path_output -mindepth 4 | grep fna)
    cp $fasta_file $new_fasta
    rm -R $path_output
done < $ids