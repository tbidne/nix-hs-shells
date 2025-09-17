#!/usr/bin/env bash

set +e

curr_timestamp () {
  date '+%s'
}

# Test every ghc version w/ all optional tools. Obviously this can take a very
# long time.

parse_bool () {
  if [[ $2 == "true" ]]; then
    echo "--arg $1 true"
  elif [[ $2 == "false" ]]; then
    echo "--arg $1 false"
  else
    echo "Unexpected arg: '$2'. Expected one of (true | false)."
    exit 1
  fi
}

export LANG="C.UTF-8"

# NOTE: [Manageable CI]
#
# Not included due to poor caching + not important:
#   - ghc944
#   - ghc961
#
# Note that these exclusions only make manual testing w/ all_cached_ghc_versions or
# current_cached_ghc_versions easier, since CI always supplies an individual --ghc
# arg (thus can avoid poor versions itself).
#
# The 'Cached' descripters refers to just GHC i.e. all of the following have
# good caching w.r.t GHC but not necessarily all tools.

export all_cached_ghc_versions="
   ghc8107
   ghc902
   ghc925
   ghc926
   ghc927
   ghc928
   ghc945
   ghc946
   ghc947
   ghc948
   ghc962
   ghc963
   ghc964
   ghc965
   ghc966
   ghc967
   ghc981
   ghc982
   ghc983
   ghc983
   ghc9101
   ghc9102
   ghc9121
   ghc9122
   "

# This is a subset of all_cached_ghc_versions i.e. the last 3 major releases that
# we do not exclude for other reasons e.g. poor caching.
export current_cached_ghc_versions="
   ghc981
   ghc982
   ghc983
   ghc984
   ghc9101
   ghc9102
   ghc9121
   ghc9122
   "

cmd="--command exit"
apply_refact="--arg apply-refact true"
fourmolu="--arg fourmolu true"
ghc_versions=$current_cached_ghc_versions
hlint="--arg hlint true"
hls="--arg hls true"
ormolu="--arg ormolu true"
verbose=0

while [ $# -gt 0 ]; do
  case "$1" in
    "-h" | "--help")
      echo -e "load_shell: Loads haskell shell.\n"
      echo "Usage: load_shell.sh [-a|--all]"
      echo "                     [--apply-refact (true | false)]"
      echo "                     [-d|--dry-run]"
      echo "                     [--fourmolu (true | false)]"
      echo "                     [-g|--ghc GHC]"
      echo "                     [--hlint (true | false)]"
      echo "                     [--hls (true | false)]"
      echo "                     [--no-tools]"
      echo "                     [--ormolu (true | false)]"
      echo "                     [-h|--help]"
      echo "                     [-v|--verbose]"
      echo ""
      echo "Available options:"
      echo -e "  -a,--all                       Runs all ghc versions.\n"
      echo -e "  --all-tools                    Enables all tools.\n"
      echo -e "  --apply-refact (true | false)  Enables apply-refact tool.\n"
      echo -e "  -d,--dry-run                   Runs with --dry-run i.e. does not build"
      echo -e "                                 anything.\n"
      echo -e "  --fourmolu (true | false)      Enables fourmolu tool.\n"
      echo -e "  -g,--ghc                       Runs with a specific ghc e.g. ghc902. Otherwise"
      echo -e "                                 tries all versions.\n"
      echo -e "  --hlint (true | false)         Enables hlint tool.\n"
      echo -e "  --hls (true | false)           Enables hls tool.\n"
      echo -e "  --no-tools                     Disables all tools.\n"
      echo -e "  --ormolu (true | false)        Enables ormolu tool.\n"
      exit 0
      ;;
    "-a" | "--all")
      ghc_versions=$all_cached_ghc_versions
      ;;
    "--all-tools")
      apply_refact="--arg apply-refact true"
      fourmolu="--arg fourmolu true"
      hlint="--arg hlint true"
      hls="--arg hls true"
      ormolu="--arg ormolu true"
      ;;
    "--apply-refact")
      apply_refact=$(parse_bool "apply-refact" $2)
      shift
      ;;
    "-d" | "--dry-run")
      cmd="--dry-run"
      ;;
    "--fourmolu")
      fourmolu=$(parse_bool "fourmolu" $2)
      shift
      ;;
    "-g" | "--ghc")
      ghc_versions=$2
      shift
      ;;
    "--hlint")
      hlint=$(parse_bool "hlint" $2)
      shift
      ;;
    "--hls")
      hls=$(parse_bool "hls" $2)
      shift
      ;;
    "--no-tools")
      apply_refact="--arg apply-refact false"
      fourmolu="--arg fourmolu false"
      hlint="--arg hlint false"
      hls="--arg hls false"
      ormolu="--arg ormolu false"
      ;;
    "--ormolu")
      ormolu=$(parse_bool "ormolu" $2)
      shift
      ;;
    "-v" | "--verbose")
      verbose=1
      ;;
    *)
      echo "Unexpected arg: '$1'. Try --help."
      exit 1
    esac
    shift
  done

load () {
  cmd_str="nix-shell -A default
    --argstr ghc-vers $1
    $apply_refact
    $fourmolu
    $hlint
    $hls
    $ormolu
    $cmd"

  if [[ $verbose == 1 ]]; then
    echo "Running: $cmd_str"
  fi

  $cmd_str
}

succeeded_str="Succeeded:"
failed_str="Failed:"
any_failed=0
for ghc_vers in $ghc_versions; do
  echo "*** load_shell.sh: Testing ghc $ghc_vers ***"

  start_ts=$(curr_timestamp)

  load $ghc_vers
  exit_code=$?

  end_ts=$(curr_timestamp)

  diff_sec=$(( $end_ts - $start_ts ))

  if [[ $exit_code -ne 0 ]]; then
    echo "*** load_shell.sh: $ghc_vers Failed ($diff_sec seconds) ***"
    failed_str+=" $ghc_vers"
    any_failed=1
  else
    echo "*** load_shell.sh: $ghc_vers Succeeded ($diff_sec seconds) ***"
    succeeded_str+=" $ghc_vers"
  fi

done

echo $succeeded_str
echo $failed_str
exit $any_failed
