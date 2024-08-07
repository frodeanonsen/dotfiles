if command -v yq >/dev/null 2>&1; then
  export ARM_CLIENT_ID=`cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_appid' -r`
  export ARM_CLIENT_SECRET=`cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_password' -r`
  export ARM_SUBSCRIPTION_ID=`cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_subscription' -r`
  export ARM_TENANT_ID=`cat ~/.dotfiles/secret.yaml | yq '.zygizo.tfsp_tenant' -r`
fi
