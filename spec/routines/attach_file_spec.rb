require "rails_helper"

RSpec.describe AttachFile, type: :routine do
  let!(:attachable) { FactoryGirl.create :exercise }

  it 'attaches the file in the given path to the given attachable object' do
    result = nil
    expect{
      result = described_class.call(attachable: attachable,
                                    file: 'spec/fixtures/os_exercises_logo.png')
    }.to change{ attachable.reload.attachments.count }.by(1)
    expect(result.errors).to be_empty

    expect(attachable.attachments.last.asset.url).to eq result.outputs.url
  end

  it 'sets the attachment and url for different sizes as outputs' do
    output = described_class.call(attachable: attachable,
                                  file: 'spec/fixtures/os_exercises_logo.png').outputs
    attachment = attachable.reload.attachments.last
    expect(output.as_json).to match(
                                'attachment' => a_hash_including(
                                  "id"          => attachment.id,
                                  "parent_id"   => attachment.parent.id,
                                  "parent_type" => "Exercise"
                                ),
                                'large_url'  => a_string_starting_with("/attachments/large_"),
                                'medium_url' => a_string_starting_with("/attachments/medium_"),
                                'small_url'  => a_string_starting_with("/attachments/small_"),
                                'url'        => a_string_starting_with("/attachments/")
                              )

  end

end
