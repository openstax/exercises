# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { FactoryBot.create :tag }

  it { is_expected.to have_many(:exercise_tags) }
  it { is_expected.to have_many(:vocab_term_tags) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_uniqueness_of(:name) }

  let(:allowed_tags)   { ['Test', 'test', 'test-test', 'namespace:tag',
                          'url#anchor', '_underscore_', '1.2.3'] }
  let(:forbidden_tags) { [nil, '', ' ', '  ', 'em—dash', '"quotes"', "'quotes'",
                          '“smartquotes”', '‘smartquotes’'] }

  it 'validates the format of the tag\'s name' do
    allowed_tags.each { |tag_name| expect(Tag.new(name: tag_name)).to be_valid }
    forbidden_tags.each { |tag_name| expect(Tag.new(name: tag_name)).not_to be_valid }
  end

  it 'converts tags passed to Tag.get() to the proper format' do
    tag_names_set = Set.new(Tag.get(allowed_tags + forbidden_tags).map(&:name))
    allowed_tags.each { |tag_name| expect(tag_names_set).to include(tag_name) }
    forbidden_tags.compact.each do |tag_name|
      sanitized_name = Tag.sanitize_name(tag_name)
      expect(tag_names_set).to include(sanitized_name) unless sanitized_name.blank?
    end
  end
end
