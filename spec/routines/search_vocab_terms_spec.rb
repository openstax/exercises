require "rails_helper"

RSpec.describe SearchVocabTerms, type: :routine do
  before(:each) do
    10.times{ FactoryGirl.create(:vocab_term, :published) }

    tested_strings = ["%lorem ipsu%", "%adipiscing elit%", "draft"]
    VocabTerm.where{(name.like_any tested_strings) |
                    (definition.like_any tested_strings)}.delete_all

    @vocab_term_1 = FactoryGirl.build(:vocab_term, :published)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_1).from_json({
      tags: ['tag1', 'tag2'],
      term: "Lorem ipsum",
      definition: "Dolor sit amet",
      distractor_literals: ["Consectetur adipiscing elit", "Sed do eiusmod tempor"]
    }.to_json)
    @vocab_term_1.save!

    @vocab_term_2 = FactoryGirl.build(:vocab_term, :published)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_2).from_json({
      tags: ['tag2', 'tag3'],
      term: "Dolorem ipsum",
      definition: "Quia dolor sit amet",
      distractor_literals: ["Consectetur adipisci velit", "Sed quia non numquam"]
    }.to_json)
    @vocab_term_2.save!

    @vocab_term_draft = FactoryGirl.build(:vocab_term)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_draft).from_json({
      tags: ['all', 'the', 'tags'],
      term: "draft",
      definition: "Not ready for prime time",
      distractor_literals: ["Release to production NOW"]
    }.to_json)
    @vocab_term_draft.save!

    @vocab_terms_count = VocabTerm.count
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
      user = FactoryGirl.create :user
      @vocab_term_draft.publication.authors << Author.new(user: user)
      @vocab_term_draft.reload
      result = described_class.call({q: 'content:draft'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_draft]
    end

    it "returns a VocabTerm matching the content" do
      result = described_class.call(q: 'content:"oLoReM iPsU"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "returns a VocabTerm matching the tags" do
      result = described_class.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching the publication number" do
      number = @vocab_term_2.publication.number
      result = described_class.call(q: "number:#{number}")
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

    it 'changes the definition of "latest" if published_before is specified' do
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

      result = described_class.call(
        q: "tag:tAg1 published_before:\"#{new_vocab_term.published_at.as_json}\""
      )

      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end
  end

  context "multiple matches" do
    it "returns VocabTerms matching the content" do
      result = described_class.call(q: 'content:"lOrEm IpSuM"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns VocabTerms matching the tags" do
      result = described_class.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
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

      user = FactoryGirl.create :user

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
