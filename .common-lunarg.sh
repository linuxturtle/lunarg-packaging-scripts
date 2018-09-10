# Common variables used by multiple packaging scripts
LunarGDistros=("bionic" "xenial")
LunarGGPGKey="linux-packages@lunarg.com"
declare -A DistroVendor=( 
    [bionic]="Ubuntu"
    [xenial]="Ubuntu"
    [stretch]="Debian"
  )
declare -A DistroLocalSuffix=( 
    [bionic]="bionic~lunarg"
    [xenial]="xenial~lunarg"
    [stretch]="~lunarg"
  )
declare -A DistroPbuilderOpts=(
    [xenial]="--extrapackages pkg-create-dbgsym"
  )
