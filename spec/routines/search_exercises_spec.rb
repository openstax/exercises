require "rails_helper"

RSpec.describe SearchExercises, type: :routine do
  before(:each) do
    10.times { FactoryGirl.create(:exercise, :published) }

    ad = "%adipisci%"
    Exercise.joins{questions.outer.stems.outer}
            .joins{questions.outer.answers.outer}
            .where{(title.like ad) |\
                   (stimulus.like ad) |\
                   (questions.stimulus.like ad) |\
                   (stems.content.like ad) |\
                   (answers.content.like ad)}.delete_all

    @exercise_1 = Exercise.new
    Api::V1::ExerciseRepresenter.new(@exercise_1).from_json({
      tags: ['tag1', 'tag2'],
      title: "Lorem ipsum",
      stimulus: "Dolor",
      questions: [{
        stimulus: "Sit amet",
        stem_html: "Consectetur adipiscing elit",
        answers: [{
          content_html: "Sed do eiusmod tempor"
        }]
      }]
    }.to_json)
    @exercise_1.save!
    @exercise_1.publication.publish
    @exercise_1.publication.save!

    @exercise_2 = Exercise.new
    Api::V1::ExerciseRepresenter.new(@exercise_2).from_json({
      tags: ['tag2', 'tag3'],
      title: "Dolorem ipsum",
      stimulus: "Quia dolor",
      questions: [{
        stimulus: "Sit amet",
        stem_html: "Consectetur adipisci velit",
        answers: [{
          content_html: "Sed quia non numquam"
        }]
      }]
    }.to_json)
    @exercise_2.save!
    @exercise_2.publication.publish
    @exercise_2.publication.save!

    @exercise_draft = FactoryGirl.build(:exercise)
    Api::V1::ExerciseRepresenter.new(@exercise_draft).from_json({
      tags: ['all', 'the', 'tags'],
      title: "DRAFT",
      stimulus: "This is a draft",
      questions: [{
        stimulus: "with no collaborators",
        stem_html: "and should not appear",
        answers: [{
          content_html: "in most searches"
        }]
      }]
    }.to_json)
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
      expect(outputs.items).to eq []

      new_exercise_2 = new_exercise.new_version
      new_exercise_2.tags = ['tag1', 'tag2', 'tag3']
      new_exercise_2.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

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
      expect(outputs.items).to eq []

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
  end
end
