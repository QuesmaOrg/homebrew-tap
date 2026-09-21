cask "quesma-shipper" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.3-28.7467dd0e6e9c"
  sha256 arm:   "effa5800ea7746dc3e6b1bd6d6c6a27395034a49931a2498c949b78948fdc41d",
         intel: "247afd3e2aea8881212ab7dc4884461d8167d9d723ab096289ff76d2ff52cf64"

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
