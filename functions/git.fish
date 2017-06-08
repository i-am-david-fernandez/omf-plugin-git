function __git_all -d "Iterate a git command over all discovered repositories."
    set -l root './'
    if test -d $argv[1]
        set root $argv[1]
        set -e argv[1]
    end

    for repo in (find $root -type d -name ".git")
        set -l repo (realpath "$repo/..")
        echo-info --minor ">> $repo"
        pushd $repo
        git -c color.status=always -c color.ui=always $argv
        popd
    end
end

function git -d "Git command wrapper"

    set -l new_args

    for arg in $argv
        set -e argv[1]

        switch $arg
            case '--all'
                __git_all $argv | less -rFX
                return

            case 'diff'
                if which icdiff > /dev/null ^&1
                    command git difftool --extcmd "icdiff --line-numbers --no-bold" --no-prompt $argv | less -rFX
                    return
                else
                    set new_args $new_args $arg
                end

            case '*'
                set new_args $new_args $arg
        end
    end

    command git $new_args
end
