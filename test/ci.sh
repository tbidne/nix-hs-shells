#!/usr/bin/env bash

set -e

export LANG="C.UTF-8"

# NOTE: [CI exclusions]
#
# Used for CI. Runs the given version and each tool individually, so we can
# see how long each tool takes to load. Note that some ghc+tool combinations
# are skipped due to e.g. poor caching or lack of support.
#
# In general, this should be consistent with the table in the README and
# ghc_map.nix.
declare -A tool_map
tool_map[default,bare]="bare"
tool_map[default,apply-refact]="true"
tool_map[default,fourmolu]="true"
tool_map[default,hlint]="true"
tool_map[default,hls]="true"
tool_map[default,ormolu]="true"

tool_map[ghc9101,apply-refact]="false" # unsupported
tool_map[ghc9101,hlint]="false" # unsupported

tool_map[ghc9102,apply-refact]="false" # unsupported
tool_map[ghc9102,fourmolu]="false" # poor caching
tool_map[ghc9102,hlint]="false" # unsupported
tool_map[ghc9102,hls]="false" # poor caching
tool_map[ghc9102,ormolu]="false" # poor caching

tool_map[ghc9103,apply-refact]="false" # unsupported
tool_map[ghc9103,hlint]="false" # unsupported

# NOTE: ALIAS: ghc910 -> ghc9103
tool_map[ghc910,apply-refact]=${tool_map[ghc9103,apply-refact]}
tool_map[ghc910,fourmolu]=${tool_map[ghc9103,fourmolu]}
tool_map[ghc910,hlint]=${tool_map[ghc9103,hlint]}
tool_map[ghc910,hls]=${tool_map[ghc9103,hls]}
tool_map[ghc910,ormolu]=${tool_map[ghc9103,ormolu]}

tool_map[ghc9121,apply-refact]="false" # unsupported
tool_map[ghc9121,fourmolu]="false" # unsupported
tool_map[ghc9121,hlint]="false" # unsupported
tool_map[ghc9121,hls]="false" # unsupported
tool_map[ghc9121,ormolu]="false" # unsupported

tool_map[ghc9123,apply-refact]="false" # unsupported
tool_map[ghc9123,fourmolu]="false" # unsupported
tool_map[ghc9123,hlint]="false" # unsupported
tool_map[ghc9123,hls]="false" # unsupported
tool_map[ghc9123,ormolu]="false" # unsupported

# NOTE: ALIAS: ghc912 -> ghc9122. Since ghc9122 requires no special casing,
# neither does ghc912.

tool_map[ghc9141,apply-refact]="false" # unsupported
tool_map[ghc9141,fourmolu]="false" # unsupported
tool_map[ghc9141,hlint]="false" # unsupported
#tool_map[ghc9141,hls]="false" # unsupported
tool_map[ghc9141,ormolu]="false" # unsupported

# NOTE: ALIAS: ghc914 -> ghc9141
tool_map[ghc914,apply-refact]=${tool_map[ghc9141,apply-refact]}
tool_map[ghc914,fourmolu]=${tool_map[ghc9141,hlint]}
tool_map[ghc914,hlint]=${tool_map[ghc9141,hlint]}
tool_map[ghc914,hls]=${tool_map[ghc9141,hls]}
tool_map[ghc914,ormolu]=${tool_map[ghc9141,ormolu]}

# NOTE: ALIAS: ghc9 -> ghc912
tool_map[ghc9,apply-refact]=${tool_map[ghc912,apply-refact]}
tool_map[ghc9,fourmolu]=${tool_map[ghc912,fourmolu]}
tool_map[ghc9,hlint]=${tool_map[ghc912,hlint]}
tool_map[ghc9,hls]=${tool_map[ghc912,hls]}
tool_map[ghc9,ormolu]=${tool_map[ghc912,ormolu]}

ghc_version=""
tool_list="bare hls ormolu fourmolu hlint apply-refact"

while [ $# -gt 0 ]; do
  case "$1" in
    "-h" | "--help")
      echo -e "ci: Script used for CI testing.\n"
      echo "Usage: ci.sh (-g|--ghc GHC)"
      echo "             [-h|--help]"
      echo ""
      echo "Available options:"
      echo -e "  -g,--ghc\tGHC version to test."
      exit 0
      ;;
    "-g" | "--ghc")
      ghc_version=$2
      shift
      ;;
    *)
      echo "Unexpected arg: '$1'. Try --help."
      exit 1
    esac
    shift
  done

set +e

succeeded_str="Succeeded:"
failed_str="Failed:"
any_failed=0

if [[ -z $ghc_version ]]; then
  echo "Option --ghc is required."
  exit 1
fi

for tool in $tool_list; do
  val=${tool_map[$ghc_version,$tool]}

  # Didn't find an entry for ghc_version, try the default.
  if [[ -z $val ]]; then
    val=${tool_map[default,$tool]}
  fi

  if [[ -z $val ]]; then
    echo "*** ci.sh: Error finding map for tool ($ghc_version, $tool) ***"
    exit 1
  fi

  exit_code=0
  if [[ $val == "bare" ]]; then
    echo "*** ci.sh: Testing ($ghc_version, $tool) ***"

    ./test/load_shell.sh \
      --ghc $ghc_version \
      --no-tools \
      --verbose

    exit_code=$?

  elif [[ $val == "true" ]]; then
    echo "*** ci.sh: Testing tool ($ghc_version, $tool) ***"

    ./test/load_shell.sh \
      --ghc $ghc_version \
      --no-tools \
      --$tool true \
      --verbose

    exit_code=$?

  elif [[ $val == "false" ]]; then
    echo "*** ci.sh: Skipping ($ghc_version, $tool) ***"
    exit_code=0
  else
    echo "*** ci.sh: Error, unexpected value: $val ***"
    exit 1
  fi

  if [[ $exit_code -ne 0 ]]; then
    echo "*** ci.sh: ($ghc_version, $tool) Failed ***"
    failed_str+=" ($ghc_version, $tool)"
    any_failed=1
  else
    echo "*** ci.sh: ($ghc_version, $tool) Succeeded ***"
    succeeded_str+=" ($ghc_version, $tool)"
  fi
done

echo $succeeded_str
echo $failed_str
exit $any_failed
