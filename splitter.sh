#!/bin/bash

help() {
	echo -e "splitter.sh quebra arquivo CSV em vários pedaços.\n"
	echo -e "\t--linhas=n\t\tEspecifica número de linhas em cada arquivo."
	echo -e "\t<arquivo>\t\tnome do arquivo .CSV"
	echo -e "\n"
	exit
}


findfile() {
	echo $1
}


countargs() {
	echo $#
}


contains() {
	local e match="$1"
	shift
	let pos=0;
	for e; do
		[[ "$e" == "$match" ]] && echo $pos && return $pos
		let pos=pos+1
       	done
	echo -1
	return -1
}


containssub() {
	local e match="$1"
	shift
	let pos=0;
	for e; do
		[[ ${e%=*} == "$match" ]] && echo $pos && return $pos
		let pos=pos+1
       	done
	echo -1
	return -1
}


args=( "$@" )

# Exibe mensagem de ajuda.
if [[ $(contains "--help" ${args[@]}) -ge 0 ]]; then
	help
fi

# Obtem número de linhas 
LINHAS_ARG=$(containssub "--linhas" ${args[@]})

if [[ $LINHAS_ARG -ge 0 ]]; then
	LINHA=${args[$LINHAS_ARG]}
	NUM_LINHAS=${LINHA#*=}

	# Remove elemento da lista.
	args=( "${args[@]/--linhas=${NUM_LINHAS}}" )
else
	NUM_LINHAS=20000
fi

# Remove '\r' do Windows se necessário.
DOS2UNIX=$(contains "--dos2unix" ${args[@]})

if [[ $DOS2UNIX -ge 0 ]]; then
	args=( "${args[@]/--dos2unix}" )
fi

# Faltando arquivo?
if [[ $(countargs ${args[@]}) -ne 1 ]]; then
	help
else
	fullpath=$(findfile ${args[@]})
fi

# Passa arquivo por dos2unix para limpar.
if [[ $DOS2UNIX -ge 0 ]]; then
	echo "Passando arquivo por dos2unix..."
	dos2unix $fullpath
fi

# Pega pedaços do nome do arquivo.
filepath=$(dirname -- "$fullpath")
filename=$(basename -- "$fullpath")
extension="${filename##*.}"
filename="${filename%.*}"

# Divide arquivo com 20000 linhas em cada arquivo.
split -l $NUM_LINHAS "$fullpath" "${filepath}/${filename}_"

# Pega o cabeçalho do arquivo csv.
echo "Criando arquivo de cabeçalho: $filepath/${filename}_title.tmp..."
head -n 1 $1 > "$filepath/${filename}_title.tmp$"
sed s/\"//g "$filepath/${filename}_title.tmp$" > "$filepath/${filename}_title.tmp"
rm "$filepath/${filename}_title.tmp$"

FILES="${filepath}/${filename}_[a-z][a-z]"

for file in $FILES; do
	echo "Processando $file..."
	# Remove aspas do pedaço de arquivo.
	sed s/\"//g $file > "$file.tmp"

	# Coloca cabeçalho em cada arquivo csv gerado, menos o primeiro que já tem cabeçalho.
	if [[ "$file" != "$1_aa" ]]
	then
		cat "$filepath/${filename}_title.tmp" "$file.tmp" > "$file.$extension"
		rm "$file" "$file.tmp"
	else
		mv "$file.tmp" "$file.$entension"
		rm "$file"
	fi
done

# Apaga arquivo só com o cabeçalho.
rm "$filepath/${filename}_title.tmp"
