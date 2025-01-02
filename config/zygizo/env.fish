if command -v yq >/dev/null 2>&1
    set -x ARM_CLIENT_ID (cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_appid' -r)
    set -x ARM_CLIENT_SECRET (cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_password' -r)
    set -x ARM_SUBSCRIPTION_ID (cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_subscription' -r)
    set -x ARM_TENANT_ID (cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_tenant' -r)
    set -x CR_PAT (cat ~/.dotfiles/secret.yaml | yq '.zygizo.github_token' -r)
end
