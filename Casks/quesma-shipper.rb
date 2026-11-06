cask "quesma-shipper" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.3-121.9fb35a89cb51"
  sha256 arm:   "34e303df880c8af5376efed4734063a57d983f5890f34f350588fcf5a2e7a9d6",
         intel: "560134daa76f67f6745cd3e77e55b1954ea8c3d40d11eb90d57cf13dff9be4e7"

  url "https://updates.quesma.dev/targets/#{sha256}.quesma-shipper-darwin-#{arch}"
  name "Quesma Shipper"
  desc "Collect coding-agent history for your Quesma dashboard"
  homepage "https://github.com/QuesmaOrg/quesma-shipper"

  auto_updates true
  depends_on macos: :ventura
  container type: :naked

  rename "*quesma-shipper-darwin-#{arch}", "quesma-shipper"

  installer script: {
    executable: "quesma-shipper",
    args:       ["postinstall"],
    sudo:       false,
  }
  binary "quesma-shipper"

  uninstall script: {
    executable: "#{staged_path}/quesma-shipper",
    args:       ["service", "uninstall"],
    sudo:       false,
  }

  zap script: {
    executable: "#{staged_path}/quesma-shipper",
    args:       ["uninstall", "--purge", "--yes"],
    sudo:       false,
  }

  caveats <<~EOS
    Connect this computer using the login command from your Quesma dashboard.
    The background service starts automatically and waits for login.
    The shipper updates itself automatically from its signed update channel.
    To update immediately: quesma-shipper update
    Uninstall keeps enrollment and upload history for a later reinstall.
  EOS
end
