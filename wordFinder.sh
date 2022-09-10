#!/bin/bash
param=($@)
counter=0
if (( "$#" < 3 ))
	then
	echo "Number of parameters received : "$#"" 1>&2 
	echo "Usage : wordFinder.sh <valid file name> [More Files]... <char> <length>"
else
	beforelast="${param[${#param[@]}-2]}"
	
	if  [[ $beforelast != [0-9A-Za-z] ]] ; then
		let "counter += 1"
		echo "Only one char needed : "${param[${#param[@]}-2]}"" 			1>&2
		
	fi
	
	last="${param[${#param[@]}-1]}"
	if ! [[ $last =~ ^[0-9]+$ ]] ; then
		let "counter += 1"
		echo "Not a positive number : "${param[${#param[@]}-1]}"" 			1>&2
	fi
	
	if [[ $beforelast == [0-9A-Za-z] ]] && [[ $last =~ ^[0-9]+$ ]] ; then
		for path in ${param[@]:0:${#param[@]}-2}
		do
			if ! [ -e "$path" ] || [ -d "$path" ] ; then
				let "counter += 1"
				echo "File does not exist : "$path"" 1>&2
				
			fi
		done
	fi  
	
	if (( $counter > 0 )) ; then
		echo "Usage : wordFinder.sh <valid file name> [More Files]... <char> <length>"
		
	else
		touch copy.txt
		
		for path in ${param[@]:0:${#param[@]}-2}
		do
			cat $path >> copy.txt
		done 	
	
		tr [:upper:] [:lower:] < copy.txt > output.txt
		cat output.txt | sed -e 's/[^[:alnum:]]/ /g'  | tr '\n' " " | tr -s " " | tr " " '\n' | grep -i ^[${param[${#param[@]}-2]}] | 
		grep "^.\{${param[${#param[@]}-1]},\}$" | sort | uniq -c | sort -k1n -k2,2 | sed -e 's/^[ \t]*//'
		
	
	rm copy.txt output.txt
	fi
		 
	
fi
	
		 	
		
	


