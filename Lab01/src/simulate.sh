rm -r work
mkdir work
ghdl -i -g -O3 --std=08 --workdir=work *.vhd
ghdl -m -g -O3 --std=08 --workdir=work $1
ghdl -r -g -O3 --std=08 --workdir=work $1 --wave=$1.ghw