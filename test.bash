# Tests aspects & behaviours about pwd-list-gen.
# Copyright (C) 2017  Elliott Sobek
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

#!/bin/bash

test_file_state () {

	# BEGIN TEST FILE STATE

	if [ ! -x ./test.exe ]; then
		echo "Fail file executable"
		return 1
	fi
	echo "Pass file exe"

	# END TEST FILE STATE

}

test_fs_calculation () {

	# BEGIN TEST FILESIZE AND TOTAL ENTRY SIZE PRINT CALCULATION

	local perm=$(./test.exe -g | grep -E "(: )([0-9]+)(\.?)([0-9])([BKMGTP]?)" -o | cut -d " " -f 2 | tr '\n' ' ' | cut -d " " -f 1)
	local bytes=$(./test.exe -g | grep -E "(: )([0-9]+)(\.?)([0-9])([BKMGTP]?)" -o | cut -d " " -f 2 | tr '\n' ' ' | cut -d " " -f 2)

	# Nums of length 8 total permutations
	if [ $perm -ne 100000000 ] ; then
		echo "Fail permutation calc"
		return 1
	fi
	echo "Pass permutation calc"

	# Nums of length 8 total fs
	if [ $bytes != "858.3M" ] ; then
		echo "Fail fs calc"
		return 1
	fi
	echo "Pass fs calc"

	perm=$(./test.exe -ag | grep -E "(: )([0-9]+)(\.?)([0-9])([BKMGTP]?)" -o | cut -d " " -f 2 | tr '\n' ' ' | cut -d " " -f 1)
	bytes=$(./test.exe -ag | grep -E "(: )([0-9]+)(\.?)([0-9])([BKMGTP]?)" -o | cut -d " " -f 2 | tr '\n' ' ' | cut -d " " -f 2)

	# Nums of all length to 8 total permutations
	if [ $perm -ne 111111110 ] ; then
		echo "Fail all permutations calc"
		return 1
	fi
	echo "Pass all permutations calc"

	# Nums of all length to 8 total fs
	if [ $bytes != "941.9M" ] ; then
		echo "Fail all fs calc"
		return 1
	fi
	echo "Pass all fs calc"

	# END TEST FILESIZE AND TOTAL ENTRY SIZE PRINT CALCULATION
}

test_permutation_logic () {

	# BEGIN TEST FILESIZE CALCULATION

	# Single letter
	./test.exe -q -l 1 -ft1.txt

	local byte_size=$(du -b t1.txt | cut -f1)
	local entries=$(wc -l t1.txt | cut -d " " -f1)

	if [ "$entries" != 10 -a "$byte_size" != 20 ]; then
		echo "Fail single character"
		return 1
	fi
	echo "Pass single character"

	# Multicharacter
	./test.exe -q -l 4 -ft2.txt

	byte_size=$(du -b t2.txt | cut -f1)
	entries=$(wc -l t2.txt | cut -d " " -f1)

	if [ "$entries" -ne 10000 -a "$byte_size" -ne 50000 ]; then
		echo "Fail multicharacter"
		return 1
	fi
	echo "Pass multicharacter"

	# All multicharacter
	./test.exe -aq -l 4 -ft3.txt

	byte_size=$(du -b t3.txt | cut -f1)
	entries=$(wc -l t3.txt | cut -d " " -f1)

	if [ "$entries" -ne 11110 -a "$byte_size" -ne 55550 ]; then
		echo "Fail all multicharacter"
		return 1
	fi
	echo "Pass all multicharacter"

	# Set min (len: 2-4 NUMS)
	./test.exe -q -L 2 -l 4 -ft4.txt

	byte_size=$(du -b t4.txt | cut -f1)
	entries=$(wc -l t4.txt | cut -d " " -f1)

	if [ "$entries" -ne 11100 -a "$byte_size" -ne 54300 ]; then
		echo "Fail set min"
		return 1
	fi
	echo "Pass set min"

	# Lower
	./test.exe -q -l 4 -c l -ft6.txt

	byte_size=$(du -b t6.txt | cut -f1)
	entries=$(wc -l t6.txt | cut -d " " -f1)

	if [ "$entries" -ne 456976 -a "$byte_size" -ne 2284880 ]; then
		echo "Fail lower"
		return 1
	fi
	echo "Pass lower"

	# Upper
	./test.exe -q -l 4 -c u -ft7.txt

	byte_size=$(du -b t7.txt | cut -f1)
	entries=$(wc -l t7.txt | cut -d " " -f1)

	if [ "$entries" -ne 456976 -a "$byte_size" -ne 2284880 ]; then
		echo "Fail upper"
		return 1
	fi
	echo "Pass upper"

	# ALPHA
	./test.exe -q -l 3 -c p -ft8.txt

	byte_size=$(du -b t8.txt | cut -f1)
	entries=$(wc -l t8.txt | cut -d " " -f1)

	if [ "$entries" -ne 140608 -a "$byte_size" -ne 562432 ]; then
		echo "Fail alpha"
		return 1
	fi
	echo "Pass alpha"

	# ALNUM
	./test.exe -q -l 3 -c a -ft9.txt

	byte_size=$(du -b t9.txt | cut -f1)
	entries=$(wc -l t9.txt | cut -d " " -f1)

	if [ "$entries" -ne 238328 -a "$byte_size" -ne 953312 ]; then
		echo "Fail alnum"
		return 1
	fi
	echo "Pass alnum"

	# ALL
	./test.exe -q -l 3 -c s -ft10.txt

	byte_size=$(du -b t10.txt | cut -f1)
	entries=$(wc -l t10.txt | cut -d " " -f1)

	if [ "$entries" -ne 857375 -a "$byte_size" -ne 3429500 ]; then
		echo "Fail all choice set"
		return 1
	fi
	echo "Pass all choice set"

	# Redirection
	./test.exe -q -l 4 > t11.txt

	byte_size=$(du -b t11.txt | cut -f1)
	entries=$(wc -l t11.txt | cut -d " " -f1)

	if [ "$entries" -ne 10000 -a "$byte_size" -ne 50000 ]; then
		echo "Fail redirection"
		return 1
	fi
	echo "Pass redirection"

	# END TEST FILESIZE CALCULATION

}

test () {

	make test

	test_file_state
	test_fs_calculation
	test_permutation_logic

	echo "ALL TESTS PASSED"

	rm *.o *.txt ./test.exe

	return 0
}

test
