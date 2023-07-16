module FixtureUtil
  def fixture(file)
    spec_dir.join("fixtures", file).read
  end
end
