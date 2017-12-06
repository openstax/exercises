require "rails_helper"

RSpec.describe SearchExercises, type: :routine do
  before do
    10.times { FactoryBot.create(:exercise, :published) }

    tested_strings = ["%adipisci%", "%draft%"]
    Exercise.joins{questions.outer.stems.outer}
            .joins{questions.outer.answers.outer}
            .where{(title.like_any tested_strings) |\
                   (stimulus.like_any tested_strings) |\
                   (questions.stimulus.like_any tested_strings) |\
                   (stems.content.like_any tested_strings) |\
                   (answers.content.like_any tested_strings)}.delete_all

    @exercise_1 = Exercise.new
    Api::V1::ExerciseRepresenter.new(@exercise_1).from_hash(
      'tags' => ['tag1', 'tag2'],
      'title' => "Lorem ipsum",
      'stimulus' => "Dolor",
      'questions' => [{
        'stimulus' => "Sit amet",
        'stem_html' => "Consectetur adipiscing elit",
        'answers' => [{
          'content_html' => "Sed do eiusmod tempor"
        }]
      }]
    )
    @exercise_1.save!
    @exercise_1.publication.publish.save!

    @exercise_2 = Exercise.new
    Api::V1::ExerciseRepresenter.new(@exercise_2).from_hash(
      'tags' => ['tag2', 'tag3'],
      'title' => "Dolorem ipsum",
      'stimulus' => "Quia dolor",
      'questions' => [{
        'stimulus' => "Sit amet",
        'stem_html' => "Consectetur adipisci velit",
        'answers' => [{
          'content_html' => "Sed quia non numquam"
        }]
      }]
    )
    @exercise_2.save!
    @exercise_2.publication.publish.save!

    @exercise_draft = FactoryBot.build(:exercise)
    Api::V1::ExerciseRepresenter.new(@exercise_draft).from_hash(
      'tags' => ['all', 'the', 'tags'],
      'title' => "DRAFT",
      'stimulus' => "This is a draft",
      'questions' => [{
        'stimulus' => "with no collaborators",
        'stem_html' => "and should not appear",
        'answers' => [{
          'content_html' => "in most searches"
        }]
      }]
    )
    @exercise_draft.save!

    @exercises_count = Exercise.count
  end

  context "no matches" do
    it "does not return drafts that the user is not allowed to see" do
      result = described_class.call(q: 'content:draft')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty
    end
  end

  context "single match" do
    it "returns drafts that the user is allowed to see" do
      user = FactoryBot.create :user
      @exercise_draft.publication.authors << Author.new(user: user)
      @exercise_draft.reload
      result = described_class.call({q: 'content:draft'}, user: user.reload)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_draft]
    end

    it "returns an Exercise matching the content" do
      result = described_class.call(q: 'content:"aDiPiScInG eLiT"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching the tags" do
      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching the publication number" do
      number = @exercise_2.publication.number
      result = described_class.call(q: "number:#{number}")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_2]
    end

    it "does not return old versions of published Exercises matching the tags" do
      new_exercise = @exercise_1.new_version
      new_exercise.tags = ['tag2', 'tag3']
      new_exercise.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]

      new_exercise.publication.publish
      new_exercise.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_exercise_2 = new_exercise.new_version
      new_exercise_2.tags = ['tag1', 'tag2', 'tag3']
      new_exercise_2.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_exercise_2.publication.publish
      new_exercise_2.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_exercise_2]
    end

    it 'changes the definition of "latest" if published_before is specified' do
      new_exercise = @exercise_1.new_version
      new_exercise.tags = ['tag2', 'tag3']
      new_exercise.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]

      new_exercise.publication.publish
      new_exercise.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      result = described_class.call(
        q: "tag:tAg1 published_before:\"#{new_exercise.published_at.as_json}\""
      )

      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end
  end

  context "multiple matches" do
    it "returns Exercises matching the content" do
      result = described_class.call(q: 'content:AdIpIsCi')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns Exercises matching the tags" do
      result = described_class.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "sorts by multiple fields in different directions" do
      result = described_class.call(q: 'content:aDiPiScI', order_by: "number DESC, version ASC")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_2, @exercise_1]
    end

    it "displays the latest versions but no drafts for an anonymous user" do
      new_exercise_2 = @exercise_2.new_version
      new_exercise_2.save!
      new_exercise_2.publication.publish.save!

      new_exercise_2_draft = new_exercise_2.new_version
      new_exercise_2_draft.save!

      result = described_class.call(q: 'content:aDiPiScI')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, new_exercise_2]
    end

    it "displays the latest versions and drafts for an author" do
      new_exercise_2 = @exercise_2.new_version
      new_exercise_2.save!
      new_exercise_2.publication.publish.save!

      new_exercise_2_draft = new_exercise_2.new_version
      new_exercise_2_draft.save!

      user = FactoryBot.create :user

      [@exercise_1, new_exercise_2, new_exercise_2_draft].each do |exercise|
        exercise.authors << Author.new(user: user)
      end

      result = described_class.call({ q: 'content:aDiPiScI' }, { user: user })
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 3
      expect(outputs.items).to eq [@exercise_1, new_exercise_2_draft, new_exercise_2]
    end
  end
end
