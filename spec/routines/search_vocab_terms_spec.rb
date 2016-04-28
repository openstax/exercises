require "rails_helper"

RSpec.describe SearchVocabTerms, type: :routine do
  let!(:user) { FactoryGirl.create :user }

  before(:each) do
    10.times do
      vt = FactoryGirl.create(:vocab_term, :published)
      vt.publication.authors << Author.new(publication: vt.publication, user: user)
    end

    lorem = "%lorem ipsu%"
    ad = "%adipiscing elit%"
    test_terms = [lorem, ad]
    VocabTerm.where{(name.like_any test_terms) | (definition.like_any test_terms)}.delete_all

    @vocab_term_1 = FactoryGirl.build(:vocab_term)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_1).from_json({
      tags: ['tag1', 'tag2'],
      term: "Lorem ipsum",
      definition: "Dolor sit amet",
      distractor_literals: ["Consectetur adipiscing elit", "Sed do eiusmod tempor"]
    }.to_json)
    @vocab_term_1.save!
    @vocab_term_1.publication.authors << Author.new(publication: @vocab_term_1.publication,
                                                    user: user)
    @vocab_term_1.publication.publish
    @vocab_term_1.publication.save!

    @vocab_term_2 = FactoryGirl.build(:vocab_term)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_2).from_json({
      tags: ['tag2', 'tag3'],
      term: "Dolorem ipsum",
      definition: "Quia dolor sit amet",
      distractor_literals: ["Consectetur adipisci velit", "Sed quia non numquam"]
    }.to_json)
    @vocab_term_2.save!
    @vocab_term_2.publication.authors << Author.new(publication: @vocab_term_2.publication,
                                                    user: user)
    @vocab_term_2.publication.publish
    @vocab_term_2.publication.save!

    @vocab_term_draft = FactoryGirl.build(:vocab_term)
    Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_draft)
                                                              .from_json({
      tags: ['all', 'the', 'tags'],
      term: "draft",
      definition: "Not ready for prime time",
      distractor_literals: ["Release to production NOW"]
    }.to_json)
    @vocab_term_draft.save!

    @vocab_terms_count = VocabTerm.count
  end

  context "no matches" do
    it "does not return VocabTerms that the user is not allowed to see" do
      result = described_class.call(q: 'content:"oLoReM iPsU"')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty
    end
  end

  context "single match" do
    it "returns a VocabTerm matching the content" do
      result = described_class.call({q: 'content:"oLoReM iPsU"'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "returns a VocabTerm matching the tags" do
      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching the publication number" do
      number = @vocab_term_2.publication.number
      result = described_class.call({q: "number:#{number}"}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "does not match distractors" do
      result = described_class.call({q: 'content:"aDiPiScInG eLiT"'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty
    end

    it "does not return old versions of VocabTerms matching the tags" do
      new_vocab_term = @vocab_term_1.new_version
      new_vocab_term.tags = ['tag2', 'tag3']
      new_vocab_term.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term_2 = new_vocab_term.new_version
      new_vocab_term_2.tags = ['tag1', 'tag2', 'tag3']
      new_vocab_term_2.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_vocab_term_2]

      new_vocab_term_2.publication.publish
      new_vocab_term_2.publication.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_vocab_term_2]
    end

    it 'changes the definition of "latest" if published_before is specified' do
      new_vocab_term = @vocab_term_1.new_version
      new_vocab_term.tags = ['tag2', 'tag3']
      new_vocab_term.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = described_class.call({q: 'tag:tAg1'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to be_empty

      result = described_class.call(
        {q: "tag:tAg1 published_before:\"#{new_vocab_term.published_at.as_json}\""}, user: user
      )

      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end
  end

  context "multiple matches" do
    it "returns VocabTerms matching the content" do
      result = described_class.call({q: 'content:"lOrEm IpSuM"'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns VocabTerms matching the tags" do
      result = described_class.call({q: 'tag:TaG2'}, user: user)
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "sorts by multiple fields in different directions" do
      result = described_class.call(
        {q: 'content:lOrEm IpSuM', order_by: "number DESC, version ASC"}, user: user
      )
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_2, @vocab_term_1]
    end
  end
end
