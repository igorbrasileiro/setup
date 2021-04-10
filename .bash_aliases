alias gitfep='git fetch && git pull origin $(git branch --show-current)'
alias flink='yarn link @vtex/gatsby-theme-store @vtex/gatsby-plugin-i18n @vtex/store-ui'
source ~/.enhancd/init.sh
ENHANCD_FILTER=fzf; export ENHANCD_FILTER
ENHANCD_HOOK_AFTER_CD='ls -A';export ENHANCD_HOOK_AFTER_CD
