# source.cshrc can be used to source a .cshrc file without leaving bash
source.cshrc()
{
   [ ! -f "$1" ] && echo "\"$1\" does not exist" 1>&2 && return
   exec csh -f -c "source $1 ; exec bash"
}

declare -xf source.cshrc 2>/dev/null
