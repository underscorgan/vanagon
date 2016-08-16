require 'vanagon/component/source/git'

describe "Vanagon::Component::Source::Http" do
  let (:base_url) { 'http://buildsources.delivery.puppetlabs.net' }
  let (:file_base) { 'thing-1.2.3' }
  let (:tar_filename) { 'thing-1.2.3.tar.gz' }
  let (:tar_url) { "#{base_url}/#{tar_filename}" }
  let (:tar_dirname) { 'thing-1.2.3' }
  let (:plaintext_filename) { 'thing-1.2.3.txt' }
  let (:plaintext_url) { "#{base_url}/#{plaintext_filename}" }
  let (:plaintext_dirname) { './' }
  let (:md5sum) { 'abcdssasasa' }
  let (:sha256sum) { 'foobarbaz' }
  let (:sha512sum) { 'teststring' }
  let (:workdir) { "/tmp" }

  describe "#dirname" do
    it "returns the name of the tarball, minus extension for archives" do
      http_source = Vanagon::Component::Source::Http.new(tar_url, sum: md5sum, workdir: workdir, sum_type: "md5")
      expect(http_source).to receive(:download).and_return(tar_filename)
      http_source.fetch
      expect(http_source.dirname).to eq(tar_dirname)
    end

    it "returns the current directory for non-archive files" do
      http_source = Vanagon::Component::Source::Http.new(plaintext_url, sum: md5sum, workdir: workdir, sum_type: "md5")
      expect(http_source).to receive(:download).and_return(plaintext_filename)
      http_source.fetch
      expect(http_source.dirname).to eq(plaintext_dirname)
    end
  end

  describe "verify" do
    it "fails with a bad sum_type" do
      http_source = Vanagon::Component::Source::Http.new(plaintext_url, sum: md5sum, workdir: workdir, sum_type: "md4")
      expect(http_source).to receive(:download).and_return(plaintext_filename)
      http_source.fetch
      expect{http_source.verify}.to raise_error(RuntimeError, /Don't know how to produce a sum/)
    end

    it "calls md5 digest when it's supposed to" do
      Digest::MD5.any_instance.stub(:file).and_return(Digest::MD5.new)
      Digest::MD5.any_instance.stub(:hexdigest).and_return(md5sum)
      http_source = Vanagon::Component::Source::Http.new(plaintext_url, sum: md5sum, workdir: workdir, sum_type: "md5")
      expect(http_source).to receive(:download).and_return(plaintext_filename)
      http_source.fetch
      http_source.verify
    end
    it "calls sha256 digest when it's supposed to" do
      Digest::SHA256.any_instance.stub(:file).and_return(Digest::SHA256.new)
      Digest::SHA256.any_instance.stub(:hexdigest).and_return(sha256sum)
      http_source = Vanagon::Component::Source::Http.new(plaintext_url, sum: sha256sum, workdir: workdir, sum_type: "sha256")
      expect(http_source).to receive(:download).and_return(plaintext_filename)
      http_source.fetch
      http_source.verify
    end
    it "calls sha512 digest when it's supposed to" do
      Digest::SHA512.any_instance.stub(:file).and_return(Digest::SHA512.new)
      Digest::SHA512.any_instance.stub(:hexdigest).and_return(sha512sum)
      http_source = Vanagon::Component::Source::Http.new(plaintext_url, sum: sha512sum, workdir: workdir, sum_type: "sha512")
      expect(http_source).to receive(:download).and_return(plaintext_filename)
      http_source.fetch
      http_source.verify
    end
  end
end
