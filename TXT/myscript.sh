#!/bin/bash
# Copyright (C) 2020-2022 Cicak Bin Kadal

WEEK="08"

# This free document is distributed in the hope that it will be 
# useful, but WITHOUT ANY WARRANTY; without even the implied 
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# REV16: Sun 08 May 2022 14:00:00 WIB
# REV15: Wed 20 Apr 2022 08:38:14 WIB
# REV12: Sat 19 Mar 2022 18:00:03 WIB
# REV06: Sun 20 Feb 2022 15:18:49 WIB
# REV04: Sat 20 Nov 2021 19:10:06 WIB
# START: Mon 28 Sep 2020 21:05:04 WIB

# ATTN:
# You new to set "REC2" with your own Public-Key Identity!
# Check it out with "gpg --list-key"
REC2="60914D29C01C81F1"
# REC1: public key
REC1="63FB12B215403B20"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"
RESDIR="$HOME/RESULT/"

[ -d $RESDIR ] || mkdir -p $RESDIR
pushd $RESDIR
for II in W?? ; do
    [ -d $II ] || continue
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    rm -vf $TARFILE $TARFASC
    echo "tar cfj $TARFILE $II/"
    tar cfj $TARFILE $II/
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
done
popd

if [[ "$WEEK" != "00" ]] ; then
    II="${RESDIR}myW$WEEK.tar.bz2.asc"
    echo "Check and move $II..."
    [ -f $II ] && mv -vf $II .
fi

echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

echo "sha256sum -c $SHA"
sha256sum -c $SHA

echo "gpg --output $SHA.asc --armor --sign --detach-sign $SHA"
gpg --output $SHA.asc --armor --sign --detach-sign $SHA

echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

echo ""
echo "==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ===="
echo "==== ==== ==== ATTN: is this WEEK $WEEK ?? ==== ==== ==== ===="
echo "==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ===="
echo ""

exit 0

