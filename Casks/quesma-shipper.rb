cask "quesma-shipper" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.3-69.9d4f8d0c99a7"
  sha256 arm:   "57d3b1f763da1c1539f0bc6d49a4d8f4ffa105504cb95a6b5a17d674db2ab957",
         intel: "3e5888484a23b67026303d3b7462f19920a51f26836d9d48d40d47d0429d0381"

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
