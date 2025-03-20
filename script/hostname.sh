#!/bin/bash

# Random Hostname Generator
ALL_NON_RANDOM_WORDS=/home/admin/tools/dict/ukenglish.txt

# Count the number of words in the dictionary
non_random_words=$(wc -l < "$ALL_NON_RANDOM_WORDS")

# Generate a random index and select a word
WORD_INDEX=$(od -N3 -An -i /dev/urandom | awk -v r="$non_random_words" '{print int(1 + r * $1 / 16777216)}')
NEW_HOSTNAME=$(sed -n "${WORD_INDEX}p" "$ALL_NON_RANDOM_WORDS")

# Change Static Hostname
hostnamectl set-hostname "$NEW_HOSTNAME"

# Update /etc/hosts safely
sed -i "/127.0.1.1/c\127.0.1.1       $NEW_HOSTNAME" /etc/hosts