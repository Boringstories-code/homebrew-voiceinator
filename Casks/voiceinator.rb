cask "voiceinator" do
  version "1.0.0"
  sha256 "bf66fe87793acec8995c845933ce640bcdf6153cdb10bb9155cedd59a4c5feea"

  url "https://updates.boringlabs.online/Voiceinator-#{version}.dmg"
  name "Voiceinator"
  desc "Offline voice dictation that cleans up what you say"
  homepage "https://voiceinator.com/"

  livecheck do
    url "https://updates.boringlabs.online/manifest.json"
    strategy :json do |json|
      json["shortVersion"][/^\d+(?:\.\d+)+/]
    end
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Voiceinator.app"

  # Voiceinator is free and not notarized. Clearing quarantine here is what
  # lets a brew install open on the first launch with no Gatekeeper dialog.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Voiceinator.app"]
  end

  zap trash: [
    "~/Library/Application Support/Voiceinator",
    "~/Library/Caches/io.boringstories.voiceinator",
    "~/Library/Preferences/io.boringstories.voiceinator.plist",
  ]

  caveats <<~EOS
    Voiceinator needs a Mac with Apple Silicon. It asks for Microphone,
    Accessibility and Input Monitoring on first launch. After you grant
    Accessibility it relaunches itself once; no need to quit and reopen.
  EOS
end
