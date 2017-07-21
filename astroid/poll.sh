#!/bin/sh

# Astroid poll script
# runs at interval under astroids control
# or manually
HOOKS=$HOME/.config/notmuch/hooks

# What I want:
# - do a very quick sync
# - run notmuch new, but not the hooks (because that would run mbsync)

# Just pull INBOX and flags
mbsync hsd-quick

notmuch new --no-hooks
notmuch tag --batch --input=$HOOKS/tag/incoming

# Do we need to notify here? I'm just going to plan to use this
# manually, so it's likely I'm already looking at the index
# $HOOKS/notifynew
