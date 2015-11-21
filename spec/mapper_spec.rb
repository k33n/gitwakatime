require 'spec_helper'

describe 'description' do
  let(:git) { Git.open(@wdir) }
  before(:each) do
    GitWakaTime.config.git = git
    GitWakaTime::Mapper.new(start_at: Date.new(2015, 1, 25))
  end

  it 'can be run on dummy' do
    expect(
      GitWakaTime::Commit.all.size
    ).to eq 7 # 9ths is lonely
  end
  it 'can be run on dummy' do
    expect(
      GitWakaTime::Commit.order(:date).first.message
    ).to eq 'created readme'
  end

  it 'maps files dependent commits' do
    expect(
      GitWakaTime::Commit.all.first.commited_files.first.dependent_sha
    ).to eq 'dcd748bd06b8a0f239d779bee4f1eaf1f4aa500d'
  end

  it 'maps files dependent commits' do
    expect(
      GitWakaTime::Commit.all.find do |c|
        c.sha == 'dcd748bd06b8a0f239d779bee4f1eaf1f4aa500d'
      end.commited_files.first.dependent_sha
    ).to eq '2254dd56976b5f32a2289438842e42a35a18ff86'
  end
end
