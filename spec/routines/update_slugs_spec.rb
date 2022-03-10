require 'rails_helper'

RSpec.describe UpdateSlugs, type: :routine do
  let!(:exercise)         { FactoryBot.create :exercise }
  let!(:updated_exercise) { FactoryBot.create :exercise }

  before do
    allow_any_instance_of(Exercise).to(
      receive(:set_slug_tags!) { |exercise| exercise.id == updated_exercise.id }
    )
  end

  it 'calls set_slug_tags! on all exercises and sets updated_at for updated exercises' do
    expect { described_class.call }.to  change     { updated_exercise.reload.updated_at }
                                   .and not_change { exercise.reload.updated_at         }
  end
end
