set +e

# Test every ghc version w/ all optional tools. Obviously this can take a very
# long time.

parse_bool (){
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

export ghcVersions="
   ghc8107
   ghc902
   ghc925
   ghc926
   ghc927
   ghc928
   ghc944
   ghc945
   ghc946
   ghc961
   ghc962
   ghc963
   ghc981
   "

cmd="--command exit"
apply_refact="--arg applyRefact true"
fourmolu="--arg fourmolu true"
hlint="--arg hlint true"
hls="--arg hls true"
ormolu="--arg ormolu true"
verbose=0
while [ $# -gt 0 ]; do
    if [[ $1 == "--help" || $1 == "-h" ]]; then
      echo -e "load_shell: Loads haskell shell.\n"
      echo "Usage: load_shell.sh [--apply-refact (true | false)]"
      echo "                     [-d|--dry-run]"
      echo "                     [--fourmolu (true | false)]"
      echo "                     [--ghc GHC]"
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
      echo -e "  --ghc                          Runs with a specific ghc e.g. ghc902. Otherwise"
      echo -e "                                 tries all versions.\n"
      echo -e "  --hlint (true | false)         Enables hlint tool.\n"
      echo -e "  --hls (true | false)           Enables hls tool.\n"
      echo -e "  --no-tools                     Disables all tools.\n"
      echo -e "  --ormolu (true | false)        Enables ormolu tool.\n"
      exit 0
    elif [[ $1 == "--apply-refact" ]]; then
      apply_refact=$(parse_bool "applyRefact" $2)
      shift
    elif [[ $1 == "--dry-run" || $1 == "-d" ]]; then
      cmd="--dry-run"
    elif [[ $1 == "--fourmolu" ]]; then
      fourmolu=$(parse_bool "fourmolu" $2)
      shift
    elif [[ $1 == "--ghc" ]]; then
      ghcVersions=$2
      shift
    elif [[ $1 == "--hlint" ]]; then
      hlint=$(parse_bool "hlint" $2)
      shift
    elif [[ $1 == "--hls" ]]; then
      hls=$(parse_bool "hls" $2)
      shift
    elif [[ $1 == "--no-tools" ]]; then
      apply_refact="--arg applyRefact false"
      fourmolu="--arg fourmolu false"
      hlint="--arg hlint false"
      hls="--arg hls false"
      ormolu="--arg ormolu false"
    elif [[ $1 == "--ormolu" ]]; then
      ormolu=$(parse_bool "ormolu" $2)
      shift
    elif [[ $1 == "--verbose" || $1 == "-v" ]]; then
      verbose=1
    else
      echo "Unexpected arg: '$1'. Try --help."
      exit 1
    fi
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

  $($cmd_str)
}

load_bare () {
  cmd_str="nix-shell -A default
    --argstr ghcVers $1
    --arg applyRefact false
    --arg fourmolu false
    --arg hlint false
    --arg hls false
    --arg hlint false
    $cmd"

  if [[ $verbose == 1 ]]; then
    echo "Running: $cmd_str"
  fi

  $($cmd_str)
}

succeeded_str="Succeeded:"
failed_str="Failed:"
any_failed=0
for ghcVers in $ghcVersions; do
  echo "*** TESTING $ghcVers ***"

  if [[ $ghcVers == "ghc981" ]]; then
    load_bare $ghcVers
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