set +e

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

export ghcVersions="
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
   ghc981
   ghc982
   "

cmd="--command exit"
apply_refact="--arg applyRefact true"
fourmolu="--arg fourmolu true"
hlint="--arg hlint true"
hls="--arg hls true"
ormolu="--arg ormolu true"
verbose=0

while [ $# -gt 0 ]; do
  case "$1" in
    "-h" | "--help")
      echo -e "load_shell: Loads haskell shell.\n"
      echo "Usage: load_shell.sh [--apply-refact (true | false)]"
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
      echo -e "  --apply-refact (true | false)  Enables apply-refact tool.\n"
      echo -e "  --d,--dry-run                  Runs with --dry-run i.e. does not build"
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
    "--apply-refact")
      apply_refact=$(parse_bool "applyRefact" $2)
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
      ghcVersions=$2
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
      apply_refact="--arg applyRefact false"
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

load_all () {
  cmd_str="nix-shell -A default
    --argstr ghcVers $1
    $apply_refact
    $fourmolu
    $hlint
    $hls
    $hlint
    $cmd"

  if [[ $verbose == 1 ]]; then
    echo "Running: $cmd_str"
  fi

  $cmd_str
}

load_ghc981 () {
  cmd_str="nix-shell -A default
    --argstr ghcVers $1
    --arg applyRefact false
    $cmd"

  if [[ $verbose == 1 ]]; then
    echo "Running: $cmd_str"
  fi

  $cmd_str
}

succeeded_str="Succeeded:"
failed_str="Failed:"
any_failed=0
for ghcVers in $ghcVersions; do
  echo "*** TESTING $ghcVers ***"

  if [[ $ghcVers == "ghc981" ]]; then
    load_ghc981 $ghcVers
  else
    load_all $ghcVers
  fi

  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo "*** $ghcVers FAILED ***"
    failed_str+=" $ghcVers"
    any_failed=1
  else
    echo "*** $ghcVers SUCCEEDED ***"
    succeeded_str+=" $ghcVers"
  fi

done

echo $succeeded_str
echo $failed_str
exit $any_failed