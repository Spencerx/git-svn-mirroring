#!/bin/bash

die() {
	echo "master-sync: $*"
	exit 1
}


# Create a temporary branch, starting from last sync point on master
git branch -f svn-tmp svn-last-sync
git checkout svn-tmp

# Merge master in svn-tmp
git merge  master

# Rebase the squashed commit on top of the svn sync branch.
git rebase --onto svn-sync-branch svn-last-sync svn-tmp

# Fast forward the svn sync branch with the squashed commit.
git checkout svn-sync-branch
git merge --ff-only svn-tmp

# Sync the suqashed commit to Subversion
git svn dcommit

# Update the pointer to the last synced commit
git branch -f svn-last-sync master
git checkout svn-last-sync

