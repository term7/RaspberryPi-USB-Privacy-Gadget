#!/bin/bash

# Random Hostname Generator

ALL_NON_RANDOM_WORDS=/usr/share/dict/ukenglish.txt
non_random_words=`cat $ALL_NON_RANDOM_WORDS | wc -l`

NEW_HOSTNAME=$(WORD=`od -N3 -An -i /dev/urandom |
awk -v f=0 -v r="$non_random_words" '{printf "%i\n", f + r * $1 / 16777216}'`
sed `echo $WORD`"q;d" $ALL_NON_RANDOM_WORDS
  let "X = X + 1")

# Change Static Hostname
hostnamectl set-hostname $NEW_HOSTNAME
head -n -1 /etc/hosts > /etc/tmp
mv /etc/tmp /etc/hosts
echo -e "127.0.1.1      $NEW_HOSTNAME" >> /etc/hosts
