require "rails_helper"

RSpec.describe AssetUploader do

  let(:exercise) { FactoryBot.build(:exercise) }
  let(:png) { File.new("#{Rails.root}/spec/fixtures/rails.png") }

  def asset_file(name)
    File.new("#{Rails.root}/spec/fixtures/#{name}")
  end

  describe "image processing" do

    it 'resizes images' do
      %w{jpg png gif}.each do |ext|
        file = asset_file("os_exercises_logo.#{ext}")
        asset = Attachment.create(parent: exercise, asset: file).asset
        [:large, :medium, :small].each do | version |
          expect(asset.versions[version]).not_to be_nil
          expect(Pathname.new(asset.versions[version].path)).to exist
        end
      end
    end

    it 'blows up on invalid file types' do
      expect {
        Attachment.create!(parent: exercise, asset: asset_file("sample_exercises.xlsx"))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'accepts but does not process pdfs' do
      asset = Attachment.create!(parent: exercise, asset: asset_file("os_exercises_logo.pdf")).asset
      expect(asset.path).not_to be_nil
      [:large, :medium, :small].each do |version|
        expect(asset.versions[version].path).to be_nil
      end
    end

  end

end
