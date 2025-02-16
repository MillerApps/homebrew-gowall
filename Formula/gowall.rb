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

    # Create minimal valid JPEG (1x1 pixel)
    test_image = testpath/"test.jpg"
    test_image.binwrite [
      0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46,
      0x00, 0x01, 0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00,
      0xFF, 0xDB, 0x00, 0x43, 0x00, 0xFF, 0xDA, 0x00, 0x08,
      0x01, 0x01, 0x00, 0x00, 0x3F, 0x00, 0xFF, 0xD9
    ].pack("C*")

    # Run conversion command
    output = shell_output("#{bin}/gowall convert #{test_image} -t nord 2>&1")

    # Verify terminal output messages
    assert_match(/Processing single image.../i, output)
    assert_match(/Image processed and saved as .*\/Pictures\/gowall\/test\.jpg/i, output)

    # Verify file system changes
    output_dir = testpath/"Pictures/gowall"
    output_file = output_dir/"test.jpg"
    
    assert_predicate output_dir, :directory?, "Output directory not created"
    assert_predicate output_file, :exist?, "Processed image missing"
    assert output_file.size.positive?, "Processed image is empty"
  end
end

