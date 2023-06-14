set +e

# Test every ghc version w/ all optional tools. Obviously this can take a very
# long time.

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
   ghc961
   ghc962
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
      echo -e "load_default: Loads default shells with all options enabled.\n"
      echo "Usage: load_default [-d|--dry-run]"
      echo "                    [--ghc GHC]"
      echo "                    [--no-tools]"
      echo "                    [-h|--help]"
      echo "                    [-v|--verbose]"
      echo ""
      echo "Available options:"
      echo -e "  --d,--dry-run \tRuns with --dry-run.\n"
      echo -e "  --ghc         \tRuns with a specific ghc e.g. ghc902.\n"
      echo -e "  --no-tools    \tDisables all tools.\n"
      exit 0
    elif [[ $1 == "--dry-run" || $1 == "-d" ]]; then
      cmd="--dry-run"
    elif [[ $1 == "--ghc" ]]; then
      ghcVersions=$2
      shift
    elif [[ $1 == "--no-tools" ]]; then
      apply_refact="--arg applyRefact false"
      fourmolu="--arg fourmolu false"
      hlint="--arg hlint false"
      hls="--arg hls false"
      ormolu="--arg ormolu false"
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

succeeded_str="Succeeded:"
failed_str="Failed:"
any_failed=0
for ghcVers in $ghcVersions; do
  echo "*** TESTING $ghcVers ***"

  # TODO: Remove special case once hlint supported
  if [[ $ghcVers == "ghc961" || $ghcVers == "ghc962" ]]; then
    cmd_str="nix-shell -A default
      --argstr ghcVers $ghcVers
      $fourmolu
      $hls
      $ormolu
      $cmd"

    if [[ $verbose == 1 ]]; then
      echo "Running: $cmd_str"
    fi

    $($cmd_str)
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