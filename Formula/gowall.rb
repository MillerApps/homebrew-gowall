class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme & more"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Set temporary home directory for isolation
    ENV["HOME"] = testpath.to_s

    # Load the valid JPEG file from one level up from the formula file.
    jpeg_path = Pathname.new(File.expand_path("../1x1.jpeg", __FILE__))

    # Write its binary content into the test directory.
    test_image = testpath/"test.jpg"
    test_image.binwrite(valid_jpeg_path.binread)

    # Run conversion command
    output = shell_output("#{bin}/gowall convert #{test_image} -t nord 2>&1", 1)

    # Verify terminal output messages
    assert_match(/Processing single image.../i, output)
    assert_match(%r{Image processed and saved as .*/Pictures/gowall/test\.jpg}i, output)
  end
end
