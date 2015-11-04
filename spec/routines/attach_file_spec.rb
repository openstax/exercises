require "rails_helper"

RSpec.describe AttachFile, type: :routine do
  let!(:attachable) { FactoryGirl.create :exercise }

  it 'attaches the file in the given path to the given attachable object' do
    result = nil
    expect{
      result = AttachFile.call(attachable, 'spec/fixtures/os_exercises_logo.png')
    }.to change{ attachable.reload.attachments.count }.by(1)
    expect(result.errors).to be_empty

    expect(attachable.attachments.last.asset.url).to eq result.outputs.url
  end
end
