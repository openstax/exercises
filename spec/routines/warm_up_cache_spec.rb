require 'rails_helper'

RSpec.describe WarmUpCache, type: :routine do
  before do
    5.times do
      FactoryBot.create :exercise
      FactoryBot.create :exercise, :published
      FactoryBot.create :vocab_term, vocab_distractors_count: 1
      FactoryBot.create :vocab_term, :published, vocab_distractors_count: 1
    end
  end

  it 'caches all exercises and vocab terms' do
    expect { described_class.call }.to(
      change { Rails.cache.instance_variable_get(:@data).count }.by(60)
    )

    expect { described_class.call }.not_to(
      change { Rails.cache.instance_variable_get(:@data).count }
    )
  end
end
