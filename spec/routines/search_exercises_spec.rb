require "rails_helper"

RSpec.describe SearchExercises, type: :routine do
  before(:each) do
    10.times do
      ex = FactoryGirl.create(:exercise)
      ex.publication.publish
      ex.publication.save!
    end

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

    @exercises_count = Exercise.count
  end

  context "single match" do
    it "returns an Exercise matching the content" do
      result = SearchExercises.call(q: 'content:aDiPiScInG eLiT')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching the tags" do
      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "does not return old versions of published Exercises matching the tags" do
      new_exercise = Exercise.new
      Api::V1::ExerciseRepresenter.new(new_exercise).from_json({
        tags: ['tag2', 'tag3'],
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
      new_exercise.publication.number = @exercise_1.publication.number
      new_exercise.publication.version = @exercise_1.publication.version + 1
      new_exercise.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]

      new_exercise.publication.publish
      new_exercise.publication.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      new_exercise_2 = Exercise.new
      Api::V1::ExerciseRepresenter.new(new_exercise_2).from_json({
        tags: ['tag1', 'tag2', 'tag3'],
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
      new_exercise_2.publication.number = new_exercise.publication.number
      new_exercise_2.publication.version = new_exercise.publication.version + 1
      new_exercise_2.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      new_exercise_2.publication.publish
      new_exercise_2.publication.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_exercise_2]
    end

    it 'changes the definition of "latest" if created_before is specified' do
      new_exercise = Exercise.new
      Api::V1::ExerciseRepresenter.new(new_exercise).from_json({
        tags: ['tag2', 'tag3'],
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
      new_exercise.publication.number = @exercise_1.publication.number
      new_exercise.publication.version = @exercise_1.publication.version + 1
      new_exercise.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]

      new_exercise.publication.publish
      new_exercise.publication.save!

      result = SearchExercises.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      result = SearchExercises.call(
        q: "tag:tAg1 created_before:\"#{new_exercise.created_at.as_json}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end
  end

  context "multiple matches" do
    it "returns Exercises matching the content" do
      result = SearchExercises.call(q: 'content:AdIpIsCi')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns Exercises matching the tags" do
      result = SearchExercises.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "sorts by multiple fields in different directions" do
      result = SearchExercises.call(q: 'content:aDiPiScI',
                                    order_by: "number DESC, version ASC")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_2, @exercise_1]
    end
  end
end
