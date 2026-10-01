# tea: Forgejo/Gitea CLI (git.zebra-bull.ts.net).
#
# tea reads its API token only from <XDG_CONFIG_HOME>/tea/config.yml;
# GITEA_SERVER_TOKEN only seeds `tea login add`, it is not honored for
# API auth. So to keep pass the single source of truth: build the login
# config from the same pass entry that pass-git-helper serves for git
# credentials, in $XDG_RUNTIME_DIR (tmpfs, never swapped), point tea at
# it via XDG_CONFIG_HOME, and remove it afterwards. Nothing rests in
# ~/.config/tea.
#
# With a cold gpg-agent cache, pinentry asks for the passphrase exactly
# like a git push would.
function tea --description 'Forgejo CLI; token fetched from pass'
    set -l secret (pass show git/git.zebra-bull.ts.net)
    or return 1
    set -l token $secret[1]

    set -l runtime $XDG_RUNTIME_DIR
    test -n "$runtime"
    or set runtime /run/user/(id -u)
    set -l dir $runtime/tea-pass
    mkdir -p $dir/tea
    and chmod 700 $dir $dir/tea
    or return 1

    printf 'logins:\n    - name: git.zebra-bull.ts.net\n      url: https://git.zebra-bull.ts.net\n      token: '"'"'%s'"'"'\n      user: charitarth\n      default: true\n      ssh_host: git.zebra-bull.ts.net\npreferences:\n    editor: false\n' $token >$dir/tea/config.yml
    or return 1
    chmod 600 $dir/tea/config.yml

    env XDG_CONFIG_HOME=$dir tea $argv
    set -l rc $status
    rm -f $dir/tea/config.yml
    return $rc
end
