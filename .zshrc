# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/amogh/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
POWERLEVEL9K_MODE="nerdfont-complete"
#POWERLEVEL9K_MODE="awesome-fontconfig"
#source ~/powerlevel9k/powerlevel9k.zsh-theme

# Font mode for powerlevel9k
P9K_MODE="nerdfont-complete"


#POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""

#POWERLEVEL9K_OS_ICON_BACKGROUND=024 #navyblue
POWERLEVEL9K_OS_ICON_BACKGROUND=017 #navyblue
POWERLEVEL9K_OS_ICON_FOREGROUND=202 #orangered1

POWERLEVEL9K_BATTERY_TEMPLATE='yellow'
POWERLEVEL9K_BATTERY_CHARGING='yellow'
POWERLEVEL9K_BATTERY_CHARGED='green'
POWERLEVEL9K_BATTERY_DISCONNECTED='$DEFAULT_COLOR'
POWERLEVEL9K_BATTERY_LOW_THRESHOLD='10'
POWERLEVEL9K_BATTERY_LOW_COLOR='red'
POWERLEVEL9K_BATTERY_ICON='\uf240'

POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND=236
POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND=236
POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND=236
POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=040
POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND="yellow"
POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND="red"

POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=235
POWERLEVEL9K_LOAD_WARNING_BACKGROUND=235
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=235
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=007
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR=040


zsh_wifi_signal(){
    local signal=$(cat ~/.wifi)
    #local signal=$(nmcli device wifi | grep amogh | awk '{print $7}')
    local color='%F{blue}'
    [[ $signal -gt -60 ]] && color='%F{040%}'
    [[ $signal -lt -70 ]] && color='%F{red}'
    echo -n "%{$color%}\uf424%{%f%} [$signal.0]%{%f%}"
}

POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND=234

POWERLEVEL9K_CONTEXT_TEMPLATE='%F{040%}%n%{%f%}@%F{020%}%m%{%f%}'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=233
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=233
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='red'
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND='orange'

POWERLEVEL9K_VCS_CLEAN_FOREGROUND=017 # navyblue
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=040 # green3a
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=017 # navyblue
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=220 # gold1
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=236 #grey19
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=160 #red3a
POWERLEVEL9K_SHOW_CHANGESET=false
POWERLEVEL9K_STATUS_VERBOSE=false


POWERLEVEL9K_DOCKER_MACHINE_FOREGROUND='21'
POWERLEVEL9K_DOCKER_MACHINE_BACKGROUND='254'
POWERLEVEL9K_KUBECONTEXT_BACKGROUND='21'
POWERLEVEL9K_KUBECONTEXT_FOREGROUND='254'



POWERLEVEL9K_LOAD_BACKGROUND='green3a'

POWERLEVEL9K_DIR_HOME_FOREGROUND=232
POWERLEVEL9K_DIR_HOME_BACKGROUND=020
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=232
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=021
POWERLEVEL9K_DIR_ETC_FOREGROUND=232
POWERLEVEL9K_DIR_ETC_BACKGROUND=160
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=232
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=020




POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon battery disk_usage load custom_wifi_signal context root_indicator dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time load disk_usage battery command_execution_time)


plugins=(
	git
	docker

	)
source $ZSH/oh-my-zsh.sh

