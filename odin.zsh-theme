#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
#
# Odin - Fantastic theme for oh-my-zsh
#
# 
#
# Emanuel Casco
#   Github:   https://github.com/emanuelcasco
#   Twitter:  https://twitter.com/sindresorhus
#
# ------------------------------------------------------------------------------

# Set required options
#
setopt prompt_subst

# Load required modules
#
autoload -Uz vcs_info

# Set vcs_info parameters
#
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

# Fastest possible way to check if repo is dirty
#
git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # Check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "%F{yellow}"
}

# Display information about the current repository
#
repo_information() {
    echo "%F{green}`git_dirty`${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_ $vcs_info_msg_2_%f"
}

# Displays the exec time of the last command if set threshold was exceeded
#
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    [ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the initial timestamp for cmd_exec_time
#
#preexec() {
#    cmd_timestamp=`date +%s`
#}

# Output additional information about paths, repos and exec time
#
precmd() {
    vcs_info # Get version control info before we start outputting stuff
    print -P " $(repo_information) %F{yellow}$(cmd_exec_time)%f"
}

# Define prompts
#

PROMPT="%F{yellow}⌁%f [%*] $FX[bold]%n %(?.%F{white}.%F{red})❯ %f$FX[no-bold]%f"
#PROMPT="%F{yellow}⌁%f [%*] $FX[bold]%n %(?.%F{white}.%F{red})%(?.%F{green}✓%f.%F{red}✘%f) %f$FX[no-bold]%f"


RPROMPT="%F{green}${SSH_TTY:+%n@%m}%f" # Display username if connected via SSH

export LC_CTYPE=en_US.UTF-8
ZLE_PROMPT_INDENT=0

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
# ------------------------------------------------------------------------------
