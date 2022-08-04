require "rails_helper"

RSpec.describe SearchVocabTerms, type: :routine do
  before(:all) do
    DatabaseCleaner.start

    10.times { FactoryBot.create(:vocab_term, :published) }

    tested_strings = ["%lorem ipsu%", "%uia dolor sit ame%", "%adipiscing elit%", "draft"]

    vt = VocabTerm.arel_table
    VocabTerm.where(
      vt[:name].matches_any(tested_strings).or(vt[:definition].matches_any(tested_strings))
    ).destroy_all

    @vocab_term_1 = FactoryBot.build(:vocab_term, :published)
    Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_1).from_hash(
      'nickname' => 'Some Vocab',
      'tags' => ['tag1', 'tag2'],
      'term' => "Lorem ipsum",
      'definition' => "Dolor sit amet",
      'distractor_literals' => ["Consectetur adipiscing elit", "Sed do eiusmod tempor"],
      'solutions_are_public' => true
    )
    @vocab_term_1.save!
    FactoryBot.create :author, publication: @vocab_term_1.publication
    FactoryBot.create :copyright_holder, publication: @vocab_term_1.publication
    @vocab_term_1.publication.reload
    FactoryBot.create :author, publication: @vocab_term_1.publication
    FactoryBot.create :copyright_holder, publication: @vocab_term_1.publication
    @vocab_term_1.publication.authors.reset
    @vocab_term_1.publication.copyright_holders.reset

    @vocab_term_2 = FactoryBot.build(:vocab_term, :published)
    Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_2).from_hash(
      'nickname' => 'MyVocab',
      'tags' => ['tag2', 'tag3'],
      'term' => "Dolorem ipsum",
      'definition' => "Quia dolor sit amet",
      'distractor_literals' => ["Consectetur adipisci velit", "Sed quia non numquam"],
      'solutions_are_public' => false
    )
    @vocab_term_2.save!
    @vocab_term_2.publication.update_attribute :version, 42
    FactoryBot.create :author, publication: @vocab_term_2.publication
    FactoryBot.create :copyright_holder, publication: @vocab_term_2.publication
    @vocab_term_2.publication.authors.reset
    @vocab_term_2.publication.copyright_holders.reset

    @vocab_term_draft = FactoryBot.build(:vocab_term)
    Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_draft).from_hash(
      'tags' => ['all', 'the', 'tags'],
      'term' => "draft",
      'definition' => "Not ready for prime time",
      'distractor_literals' => ["Release to production NOW"]
    )
    @vocab_term_draft.save!

    @vocab_terms_count = VocabTerm.count
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
      @vocab_term_draft.publication.authors << Author.new(user: user)
      @vocab_term_draft.publication.copyright_holders << CopyrightHolder.new(user: user)
      @vocab_term_draft.reload
      result = described_class.call({q: 'content:draft'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_draft]
    end

    [ :id, :uid, :uuid, :group_uuid, :number, :version, :nickname, :name ]
      .each do |field|
      it "returns a VocabTerm matching some #{field}" do
        result = described_class.call(q: "#{field}:\"#{@vocab_term_2.public_send field}\"")
        expect(result.errors).to be_empty

        outputs = result.outputs
        expect(outputs.total_count).to eq 1
        expect(outputs.items).to eq [@vocab_term_2]
      end
    end

    it "returns a VocabTerm matching some term" do
      result = described_class.call(q: 'term:"oLoReM iPsU"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "returns a VocabTerm matching some definition" do
      result = described_class.call(q: 'definition:"UiA dOlOr SiT aMe"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "returns a VocabTerm matching some tag" do
      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching some content" do
      result = described_class.call(q: 'content:"oLoReM iPsU"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "does not match distractors" do
      result = described_class.call(q: 'content:"aDiPiScInG eLiT"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty
    end

    it "does not return old versions of VocabTerms matching the tags" do
      new_vocab_term = @vocab_term_1.new_version
      new_vocab_term.tags = ['tag2', 'tag3']
      new_vocab_term.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term_2 = new_vocab_term.new_version
      new_vocab_term_2.tags = ['tag1', 'tag2', 'tag3']
      new_vocab_term_2.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term_2.publication.publish
      new_vocab_term_2.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_vocab_term_2]

      new_vocab_term_2.publication.publish
      new_vocab_term_2.publication.save!

      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_vocab_term_2]
    end

    it "returns a VocabTerm matching an author" do
      result = described_class.call(q: "author:\"#{@vocab_term_1.authors.first.name}\"")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching a copyright holder" do
      result = described_class.call(
        q: "copyright_holder:\"#{@vocab_term_1.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching a collaborator" do
      result = described_class.call(
        q: "collaborator:\"#{@vocab_term_1.authors.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching solutions_are_public" do
      result = described_class.call q: "solutions_are_public:true"
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end
  end

  context "multiple matches" do
    it "returns VocabTerms matching some tag" do
      result = described_class.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns a VocabTerms matching any of a list of tags" do
      result = described_class.call(q: 'tag:tAg1,TaG3')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns a VocabTerm matching all of a list of tags" do
      result = described_class.call(q: 'tag:tAg1 tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns VocabTerms matching some content" do
      result = described_class.call(q: 'content:"lOrEm IpSuM"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns VocabTerms matching any of a list of authors" do
      result = described_class.call(
        q: "author:\"#{@vocab_term_1.authors.first.name},#{@vocab_term_2.authors.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns a VocabTerm matching all of a list of authors" do
      result = described_class.call(
        q: "author:\"#{@vocab_term_1.authors.first.name
           }\" author:\"#{@vocab_term_1.authors.last.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns VocabTerms matching any of a list of copyright holders" do
      result = described_class.call(
        q: "copyright_holder:\"#{@vocab_term_1.copyright_holders.first.name
           },#{@vocab_term_2.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns a VocabTerm matching all of a list of copyright holders" do
      result = described_class.call(
        q: "copyright_holder:\"#{@vocab_term_1.copyright_holders.first.name
           }\" copyright_holder:\"#{@vocab_term_1.copyright_holders.last.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns VocabTerms matching any of a list of collaborators" do
      result = described_class.call(
        q: "collaborator:\"#{@vocab_term_1.authors.first.name
           },#{@vocab_term_2.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns a VocabTerm matching all of a list of collaborators" do
      result = described_class.call(
        q: "collaborator:\"#{@vocab_term_1.authors.first.name
           }\" collaborator:\"#{@vocab_term_1.copyright_holders.first.name}\""
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "sorts by multiple fields in different directions" do
      result = described_class.call(q: 'content:"lOrEm IpSuM"',
                                    order_by: "number DESC, version ASC")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_2, @vocab_term_1]
    end

    it "displays the latest versions but no drafts for an anonymous user" do
      new_vocab_term_2 = @vocab_term_2.new_version
      new_vocab_term_2.save!
      new_vocab_term_2.publication.publish.save!

      new_vocab_term_2_draft = new_vocab_term_2.new_version
      new_vocab_term_2_draft.save!

      result = described_class.call(q: 'content:"lOrEm IpSuM"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, new_vocab_term_2]
    end

    it "displays the latest versions and drafts for an author" do
      new_vocab_term_2 = @vocab_term_2.new_version
      new_vocab_term_2.save!
      new_vocab_term_2.publication.publish.save!

      new_vocab_term_2_draft = new_vocab_term_2.new_version
      new_vocab_term_2_draft.save!

      user = FactoryBot.create :user

      [@vocab_term_1, new_vocab_term_2, new_vocab_term_2_draft].each do |vocab_term|
        vocab_term.authors << Author.new(user: user)
      end

      result = described_class.call({ q: 'content:"lOrEm IpSuM"' }, { user: user })
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 3
      expect(outputs.items).to eq [@vocab_term_1, new_vocab_term_2_draft, new_vocab_term_2]
    end
  end
end
