require "rails_helper"

RSpec.describe SearchVocabTerms, type: :routine do
  before(:each) do
    10.times do
      ex = FactoryGirl.create(:vocab_term)
      ex.publication.publish
      ex.publication.save!
    end

    ad = "%adipisci%"
    VocabTerm.joins{questions.outer.stems.outer}
            .joins{questions.outer.answers.outer}
            .where{(title.like ad) |\
                   (stimulus.like ad) |\
                   (questions.stimulus.like ad) |\
                   (stems.content.like ad) |\
                   (answers.content.like ad)}.delete_all

    @vocab_term_1 = VocabTerm.new
    Api::V1::VocabTermRepresenter.new(@vocab_term_1).from_json({
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
    @vocab_term_1.save!
    @vocab_term_1.publication.publish
    @vocab_term_1.publication.save!

    @vocab_term_2 = VocabTerm.new
    Api::V1::VocabTermRepresenter.new(@vocab_term_2).from_json({
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
    @vocab_term_2.save!
    @vocab_term_2.publication.publish
    @vocab_term_2.publication.save!

    @vocab_terms_count = VocabTerm.count
  end

  context "single match" do
    it "returns a VocabTerm matching the content" do
      result = SearchVocabTerms.call(q: 'content:aDiPiScInG eLiT')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching the tags" do
      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]
    end

    it "returns a VocabTerm matching the publication number" do
      number = @vocab_term_2.publication.number
      result = SearchVocabTerms.call(q: "number:#{number}")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_2]
    end

    it "does not return old versions of published VocabTerms matching the tags" do
      new_vocab_term = VocabTerm.new
      Api::V1::VocabTermRepresenter.new(new_vocab_term).from_json({
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
      new_vocab_term.publication.number = @vocab_term_1.publication.number
      new_vocab_term.publication.version = @vocab_term_1.publication.version + 1
      new_vocab_term.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      new_vocab_term_2 = VocabTerm.new
      Api::V1::VocabTermRepresenter.new(new_vocab_term_2).from_json({
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
      new_vocab_term_2.publication.number = new_vocab_term.publication.number
      new_vocab_term_2.publication.version = new_vocab_term.publication.version + 1
      new_vocab_term_2.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      new_vocab_term_2.publication.publish
      new_vocab_term_2.publication.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [new_vocab_term_2]
    end

    it 'changes the definition of "latest" if published_before is specified' do
      new_vocab_term = VocabTerm.new
      Api::V1::VocabTermRepresenter.new(new_vocab_term).from_json({
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
      new_vocab_term.publication.number = @vocab_term_1.publication.number
      new_vocab_term.publication.version = @vocab_term_1.publication.version + 1
      new_vocab_term.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 1
      expect(outputs.items).to eq [@vocab_term_1]

      new_vocab_term.publication.publish
      new_vocab_term.publication.save!

      result = SearchVocabTerms.call(q: 'tag:tAg1')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 0
      expect(outputs.items).to eq []

      result = SearchVocabTerms.call(
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
      result = SearchVocabTerms.call(q: 'content:AdIpIsCi')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "returns VocabTerms matching the tags" do
      result = SearchVocabTerms.call(q: 'tag:TaG2')
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_1, @vocab_term_2]
    end

    it "sorts by multiple fields in different directions" do
      result = SearchVocabTerms.call(q: 'content:aDiPiScI',
                                    order_by: "number DESC, version ASC")
      expect(result.errors).to be_empty

      outputs = result.outputs
      expect(outputs.total_count).to eq 2
      expect(outputs.items).to eq [@vocab_term_2, @vocab_term_1]
    end
  end
end
