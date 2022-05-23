require 'rails_helper'

module Api::V1::Exercises
  RSpec.describe Representer, type: :representer do

    let(:vocab_term) { FactoryBot.create :vocab_term }
    let(:exercise)   do
      vocab_term.exercises.first.tap do |exercise|
        exercise.title = 'A title'
        exercise.stimulus = 'Stimulus package'
        exercise.save!
      end
    end

    # This is lazily-evaluated on purpose
    let(:representer)    { described_class.new(exercise) }
    let(:representation) { representer.to_hash(user_options: { can_view_solutions: true }) }

    context 'nickname' do
      it 'can be read' do
        exercise.publication.publication_group.nickname = 'MyExercise'
        exercise.publication.publication_group.save!
        expect(representation).to include('nickname' => 'MyExercise')
      end

      it 'can be written' do
        expect(exercise.publication.publication_group).to receive(:nickname=).with('MyExercise')
        described_class.new(exercise).from_hash('nickname' => 'MyExercise')
      end
    end

    context 'license' do
      let!(:license) { FactoryBot.create :license, name: 'AGPLv3' }

      it 'can be read' do
        exercise.license = license
        exercise.save!
        expect(representation).to(
          include 'license' => Api::V1::LicenseRepresenter.new(license).to_hash
        )
      end

      it 'can be written' do
        expect(exercise).to receive(:license=).with(license)
        described_class.new(exercise).from_hash('license' => { 'name' => 'AGPLv3' })
      end

      it 'does not create new licenses' do
        expect(exercise).not_to receive(:license=)
        described_class.new(exercise).from_hash('license' => { 'name' => 'BGPLv4' })
      end

    end

    context 'vocab_term_uid' do
      it 'can be read' do
        expect(representation).to include('vocab_term_uid' => vocab_term.uid)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(exercise).not_to receive(:vocab_term=)
        expect(exercise).not_to receive(:vocab_term_id=)
        described_class.new(exercise).from_hash('vocab_term_uid' => '42@1')
      end
    end

    context 'title' do
      it 'can be read' do
        exercise.title = 'A title'
        exercise.save!
        expect(representation).to include('title' => exercise.title)
      end

      it 'can be written' do
        expect(exercise).to receive(:title=).with('A cool exercise')
        described_class.new(exercise).from_hash('title' => 'A cool exercise')
      end
    end

    context 'stimulus' do
      it 'can be read' do
        expect(representation).to include('stimulus_html' => exercise.stimulus)
      end

      it 'can be written' do
        expect(exercise).to receive(:stimulus=).with('This exercise is cool.')
        described_class.new(exercise).from_hash('stimulus_html' => 'This exercise is cool.')
      end
    end

    context 'images' do
      before(:each) do
        exercise.images.attach(io: File.open(Rails.root.join('public', 'favicon.ico')), filename: 'favicon.ico', content_type: 'image/jpeg')
      end
      it 'are included' do
        expect(representation).to(
          including(
            'images' => [a_hash_including(
                           'url' => a_string_matching(
                             Rails.application.routes.url_helpers.rails_storage_proxy_url(
                              exercise.images.first, {
                                host: Rails.application.secrets.attachments_url
                              })
                           ),
                           'signed_id' => a_string_matching(/\w/),
                           'created_at' => a_string_matching(/\d{4}-([0]\d|1[0-2])-([0-2]\d|3[01])/),
                        )]
          )
        )
      end

      it 'only attaches when not already attached' do
        # attempt to attach an image that is already attached
        representer = described_class.new(exercise)
        expect {
          representer.from_hash('images' => [
                                  { 'signed_id' => exercise.images[0].signed_id },
                                  { 'signed_id' => exercise.images[0].signed_id },
                                ]
                               )
          exercise.save
        }.not_to change { exercise.images.count }
      end

    end

    context 'questions' do
      it 'can be read' do
        3.times { exercise.questions << FactoryBot.build(:question, exercise: exercise) }

        question_representations = exercise.questions.map do |question|
          SimpleQuestionRepresenter.new(question)
                                   .to_hash(user_options: { can_view_solutions: true })
        end

        expect(representation).to include('questions' => question_representations)
      end

      it 'can be written' do
        expect(exercise.questions).to(
          receive(:replace).with([kind_of(Question)]*3) do |questions|
            expect(questions.map(&:stimulus)).to eq [ 'Question 1', 'Question 2', 'Question 3' ]
          end
        )

        described_class.new(exercise).from_hash(
          'questions' => [
            { 'stimulus_html' => 'Question 1' },
            { 'stimulus_html' => 'Question 2' },
            { 'stimulus_html' => 'Question 3' }
          ]
        )
      end
    end

    context "can_view_solutions? queries" do
      let!(:real_exercise) { FactoryBot.create(:exercise, questions_count: 1)}
      let!(:user) { FactoryBot.create :user }

      it 'only calls can_view_solutions? twice' do
        expect_any_instance_of(Exercise).to receive(:can_view_solutions?).twice.and_call_original
        described_class.new(real_exercise).as_json
      end
    end

    context '#to_hash' do
      it 'caches calls to #super' do
        count = 0
        expect(representer).to(
          receive(:create_representation_with).exactly(11).times.and_wrap_original do |mtd, *args|
            count += 1

            mtd.call *args
          end
        )

        representer.to_hash
        expect(count).to eq 2

        representer.to_hash(user_options: { can_view_solutions: true })
        expect(count).to eq 4

        representer.to_hash
        expect(count).to eq 5

        representer.to_hash(user_options: { can_view_solutions: true })
        expect(count).to eq 6

        described_class.all_cache_keys_for(
          exercise, user_options: { can_view_solutions: true }
        ).each { |key| Rails.cache.delete key }

        representer.to_hash(user_options: { can_view_solutions: true })
        expect(count).to eq 9

        representer.to_hash
        expect(count).to eq 10

        representer.to_hash(user_options: { can_view_solutions: true })
        expect(count).to eq 11
      end
    end
  end
end
