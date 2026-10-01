# On omarchy, fish is exec'd from a bash that already ran `mise activate bash`
# (see bash/omarchy.bash). That hook doesn't run in fish, so activate again for
# fish. zygbook activates mise from ~/.env.fish and never has a bash parent.
if status is-interactive
    and test "$MISE_SHELL" = bash
    and command -q mise
    mise activate fish | source
end
