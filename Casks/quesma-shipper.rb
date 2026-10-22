cask "quesma-shipper" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.3-87.cf1d58428e25"
  sha256 arm:   "3cfd0c893339c2e43905d5235265081881b977379453c53409237a2168633926",
         intel: "72c282744d3660f5e06338cf47eb11176e666304b75baeae771364414b921a81"

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
