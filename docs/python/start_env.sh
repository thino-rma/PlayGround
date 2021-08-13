# alias conda_xxxx='cd ~/python_work/xxxx; . start_env.sh'
# alias start_jupyter='jupyter-notebook --ip=0.0.0.0 --port=8888'

if [ -z "$1" ]; then
    _CURRENT_DIR=`pwd`
    TARGET_ENV=${_CURRENT_DIR##*/}
else
    TARGET_ENV=$1
    if [ -d ~/python_work/${TARGET_ENV} ]; then
        echo "cd ~/python_work/${TARGET_ENV}"
        cd ~/python_work/${TARGET_ENV}
    fi
fi

if [[ "$0" != "-bash" ]]; then
    echo "don't execute this script in subshell"
    echo "$ source $0"
    exit 11
fi

if [ "${CONDA_SHLVL}" == "2" ]; then
    echo "current env: ${CONDA_DEFAULT_ENV}"
else
    if [ "${CONDA_SHLVL}" == "0" ]; then
        echo "conda activate base"
        conda activate base
        if [ "${CONDA_SHLVL}" != "1" ]; then
            echo "### conda not found?"
            echo "type conda"
            type conda
        fi
    fi

    if [ "${CONDA_SHLVL}" == "1" ]; then
        echo "conda activate ${TARGET_ENV}"
        conda activate ${TARGET_ENV}
        if [ "${CONDA_SHLVL}" != "2" ]; then
            echo "### env not found: ${TARGET_ENV}"
            echo "conda env list"
            conda env list
        fi
    fi

    if [ "${CONDA_SHLVL}" == "2" ]; then
        # jupyter-notebook --ip=0.0.0.0 --port=8888
        :
    fi
fi
