set -ev

opam init --yes --no-setup
eval $(opam config env)
opam repo add coq-released https://coq.inria.fr/opam/released
opam install coq.$COQ_VERSION coq-mathcomp-ssreflect.$SSREFLECT_VERSION --yes --verbose

pushd ..
  git clone -b $STRUCTTACT_BRANCH 'https://github.com/uwplse/StructTact.git'
  pushd StructTact
    ./build.sh
  popd

  git clone 'https://github.com/DistributedComponents/InfSeqExt.git'
  pushd InfSeqExt
    ./build.sh
  popd
popd

./build.sh

case $DOWNSTREAM in
verdi-raft)
  pushd ..
    git clone -b $VERDI_RAFT_BRANCH 'http://github.com/uwplse/verdi-raft'
    pushd verdi-raft
      ./build.sh
    popd
  popd
  ;;
esac
