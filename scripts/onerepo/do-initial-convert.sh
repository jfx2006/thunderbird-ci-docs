#!/bin/bash -xv

set -e

SCRIPTDIR=$(dirname "$0")
HERE=$(realpath "${SCRIPTDIR}")

_HG="/usr/bin/hg"
_HGCFG="--config convert.git.renamelimit=100000 --config convert.hg.saverev=True"
HG="${_HG} ${_HGCFG}"

CVS_GIT_REPO=mozilla-cvs-history
CC_HG_REPO=COMM-CENTRAL
MC_HG_REPO=MOZ-CENTRAL
SINGLE_REPO=single-repo

#if /bin/false; then
#  git clone https://github.com/ehsan/mozilla-cvs-history.git ${CVS_GIT_REPO}
#  ${HG} clone https://hg.mozilla.org/comm-central ${CC_HG_REPO}
#else
#  git -C ${CVS_GIT_REPO} pull
#  ${HG} -R ${CC_HG_REPO} pull
#  ${HG} -R ${MC_HG_REPO} pull
#fi

MC_REV=$(${HG} -R ${MC_HG_REPO} id -i -r tip  --template='{node|short}\n')

echo "Branch map:"
echo "default comm/default" | tee branchmap.txt
echo "File map:"
echo "rename . comm" | tee filemap.txt

${HG} convert --filemap=cc0.txt --branchmap=branchmap.txt $CVS_GIT_REPO ${SINGLE_REPO}/

CVS_TIP=$(${HG} id -R ${SINGLE_REPO} -i -r tip --debug)
CC_0=$(hg id -R ${CC_HG_REPO} -i -r 0 --debug)
echo "${CC_0}" "${CVS_TIP}" | tee splicemap.txt

${HG} convert --splicemap=splicemap.txt \
	--filemap=filemap.txt \
	--branchmap=branchmap.txt \
	"${HERE}/${CC_HG_REPO}" \
	${SINGLE_REPO}/

${HG} -R ${SINGLE_REPO} up default
${HG} -R ${SINGLE_REPO} pull -f -b default "${HERE}/${MC_HG_REPO}"

${HG} -R ${SINGLE_REPO} up comm/default
${HG} -R ${SINGLE_REPO} merge default
${HG} -R ${SINGLE_REPO} commit -m "Merge mozilla-central@${MC_REV} to comm/default. a=merge"

