if command -v yq >/dev/null 2>&1; then
  export ARM_CLIENT_ID=`cat ~/.dotfiles/secret.yaml | yq e '.zygizo.tfsp_appid' -`
  export ARM_CLIENT_SECRET=`cat ~/.dotfiles/secret.yaml | yq e '.zygizo.tfsp_password' -`
  export ARM_SUBSCRIPTION_ID=`cat ~/.dotfiles/secret.yaml | yq e '.zygizo.tfsp_subscription' -`
  export ARM_TENANT_ID=`cat ~/.dotfiles/secret.yaml | yq e '.zygizo.tfsp_tenant' -`
fi
