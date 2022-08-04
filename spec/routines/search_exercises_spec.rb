require "rails_helper"

RSpec.describe SearchExercises, type: :routine do
  before(:all) do
    DatabaseCleaner.start

    10.times { FactoryBot.create(:exercise, :published) }

    ex = Exercise.arel_table
    qu = Question.arel_table
    st = Stem.arel_table
    ans = Answer.arel_table

    tested_strings = [ "%adipisci%", "%draft%" ]

    ex_ids = Exercise.left_joins(questions: [:stems, :answers]).where(
               ex[:title].matches_any(tested_strings)
           .or(ex[:stimulus].matches_any(tested_strings))
           .or(qu[:stimulus].matches_any(tested_strings))
           .or(st[:content].matches_any(tested_strings))
           .or(ans[:content].matches_any(tested_strings))).pluck(:id)

    Exercise.where(id: ex_ids).destroy_all

    @exercise_1 = Exercise.new
    Api::V1::Exercises::Representer.new(@exercise_1).from_hash(
      'nickname' => 'Some Exercise',
      'tags' => ['tag1', 'tag2'],
      'title' => "Lorem ipsum",
      'stimulus' => "Dolor",
      'questions' => [{
        'stimulus' => "Sit amet",
        'stem_html' => "Consectetur adipiscing elit",
        'answers' => [{
          'content_html' => "Sed do eiusmod tempor"
        }],
        'formats' => [ 'multiple-choice', 'free-response' ]
      }],
      'solutions_are_public' => true
    )
    @exercise_1.save!
    @exercise_1.publication.publish.save!
    FactoryBot.create :author, publication: @exercise_1.publication
    FactoryBot.create :copyright_holder, publication: @exercise_1.publication
    @exercise_1.publication.reload
    FactoryBot.create :author, publication: @exercise_1.publication
    FactoryBot.create :copyright_holder, publication: @exercise_1.publication

    @exercise_2 = Exercise.new
    Api::V1::Exercises::Representer.new(@exercise_2).from_hash(
      'nickname' => 'MyExercise',
      'tags' => ['tag2', 'tag3'],
      'title' => "Dolorem ipsum",
      'stimulus' => "Quia dolor",
      'questions' => [{
        'stimulus' => "Sit amet",
        'stem_html' => "Consectetur adipisci velit",
        'answers' => [{
          'content_html' => "Sed quia non numquam"
        }],
        'formats' => [ 'true-false' ]
      }],
      'solutions_are_public' => false
    )
    @exercise_2.save!
    @exercise_2.publication.version = 42
    @exercise_2.publication.publish.save!
    FactoryBot.create :author, publication: @exercise_2.publication
    FactoryBot.create :copyright_holder, publication: @exercise_2.publication

    @exercise_draft = FactoryBot.build(:exercise)
    Api::V1::Exercises::Representer.new(@exercise_draft).from_hash(
      'tags' => ['all', 'the', 'tags'],
      'title' => "DRAFT",
      'stimulus' => "This is a draft",
      'questions' => [{
        'stimulus' => "with no collaborators",
        'stem_html' => "and should not appear",
        'answers' => [{
          'content_html' => "in most searches"
        }],
        'formats' => [ 'multiple-choice', 'free-response' ]
      }]
    )
    @exercise_draft.save!

    @exercises_count = Exercise.count
  end
  after(:all) { DatabaseCleaner.clean }

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
      @exercise_draft.publication.copyright_holders << CopyrightHolder.new(user: user)
      @exercise_draft.reload
      result = described_class.call({q: 'content:draft'}, user: user.reload)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_draft]
    end

    [ :id, :uid, :uuid, :group_uuid, :number, :version, :nickname, :title ].each do |field|
      it "returns an Exercise matching some #{field}" do
        result = described_class.call(q: "#{field}:\"#{@exercise_2.public_send field}\"")
        expect(result.errors).to be_empty

        outputs = result.outputs
        expect(outputs.total_count).to eq 1
        expect(outputs.items).to eq [@exercise_2]
      end
    end

    it "returns an Exercise matching some tag" do
      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "does not return old versions of published Exercises matching the tag" do
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

    it "returns an Exercise matching some content" do
      result = described_class.call(q: 'content:"aDiPiScInG eLiT"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching an author" do
      result = described_class.call(q: "author:\"#{@exercise_1.authors.first.name}\"")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching a copyright holder" do
      result = described_class.call(
        q: "copyright_holder:\"#{@exercise_1.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching a collaborator" do
      result = described_class.call(
        q: "collaborator:\"#{@exercise_1.authors.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching a format" do
      result = described_class.call q: "format:multiple-choice"
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns an Exercise matching solutions_are_public" do
      result = described_class.call q: "solutions_are_public:true"
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end
  end

  context "multiple matches" do
    it "returns Exercises matching some tag" do
      result = described_class.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns a Exercises matching any of a list of tags" do
      result = described_class.call(q: 'tag:tAg1,TaG3')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns an Exercise matching all of a list of tags" do
      result = described_class.call(q: 'tag:tAg1 tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns Exercises matching some content" do
      result = described_class.call(q: 'content:AdIpIsCi')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns Exercises matching any of a list of authors" do
      result = described_class.call(
        q: "author:\"#{@exercise_1.authors.first.name},#{@exercise_2.authors.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns an Exercise matching all of a list of authors" do
      result = described_class.call(
        q: "author:\"#{@exercise_1.authors.first.name
           }\" author:\"#{@exercise_1.authors.last.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns Exercises matching any of a list of copyright holders" do
      result = described_class.call(
        q: "copyright_holder:\"#{@exercise_1.copyright_holders.first.name
           },#{@exercise_2.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns an Exercise matching all of a list of copyright holders" do
      result = described_class.call(
        q: "copyright_holder:\"#{@exercise_1.copyright_holders.first.name
           }\" copyright_holder:\"#{@exercise_1.copyright_holders.last.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns Exercises matching any of a list of collaborators" do
      result = described_class.call(
        q: "collaborator:\"#{@exercise_1.authors.first.name
           },#{@exercise_2.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns an Exercise matching all of a list of collaborators" do
      result = described_class.call(
        q: "collaborator:\"#{@exercise_1.authors.first.name
           }\" collaborator:\"#{@exercise_1.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
    end

    it "returns Exercises matching any of a list of formats" do
      result = described_class.call q: "format:multiple-choice,true-false"
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@exercise_1, @exercise_2]
    end

    it "returns an Exercise matching all of a list of formats" do
      result = described_class.call q: "format:multiple-choice format:free-response"
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@exercise_1]
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
