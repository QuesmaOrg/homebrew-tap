cask "quesma-shipper" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.3-127.8deb83c6976a"
  sha256 arm:   "e0d4b78e3482c7de508c68cdc2a6501471e8671cc7e4043934e24fda988688ef",
         intel: "5aae5ce52c3d5fa81995a721ac990603b326c4adff1e327ffa6717ea438fc8ff"

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
