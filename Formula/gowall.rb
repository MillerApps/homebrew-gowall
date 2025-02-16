class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme & more"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Create a test file
    (testpath/"test.jpg").write <<~EOS
      Test Image
    EOS
    assert_match "Image processed", shell_output("#{bin}/gowall convert test.jpg -t catppuccin")
  end
end
