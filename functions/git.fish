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
        git $argv
        popd
    end
end

function git -d "Git command wrapper"
    # Package entry-point

    set new_args

    for arg in $argv
        set -e argv[1]

        switch $arg
            case '--all'
                __git_all $argv | less -rFX
                return

            case '*'
                set new_args $new_args $arg
        end
    end

    command git $new_args
end
