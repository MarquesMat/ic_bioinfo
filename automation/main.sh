#!/bin/bash

### Caminhos
# Caminho para este diretório
path="$(cd "$(dirname "$0")" && pwd)/"

species='all_maribacter'

# strict -> Interespecies
# sensitive -> Intraespecies
clean_modes='sensitive'

# mafft -> mais eficiente, bom para lidar com grandes quantidades de amostras
# prank -> mais lento (dados pequenos)
aligners='mafft'

for sp in $species; do
    # bash "${path}get_fasta.sh" "$sp"
    # bash "${path}only_prokka.sh" "$sp"
    for cm in $clean_modes; do
        for a in $aligners; do
            # echo "$sp" "$cm" "$a" "12"
            bash "${path}analyse_panaroo.sh" "$sp" "$cm" "$a"
        done
    done
done
