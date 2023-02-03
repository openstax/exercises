require 'vcr_helper'
require 'rake'

RSpec.describe 'books breakdown', type: :rake, vcr: VCR_OPTS do
  before :all do
    Rake.application.rake_require 'tasks/books/breakdown'
    Rake::Task.define_task :environment
  end

  before { Rake::Task['books:breakdown'].reenable }

  let(:book_uuid) { '14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22' }
  let(:filename)  { "#{Rails.root}/tmp/test-#{book_uuid}.csv" }

  it 'returns correct exercise counts' do
    # Disable set_slug_tags!
    allow_any_instance_of(Exercise).to receive(:set_slug_tags!)

    ex1 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:ada35081-9ec4-4eb8-98b2-3ce350d5427f' ]
    ex1.questions.first.stems.first.stylings.first.update_attribute :style, Style::MULTIPLE_CHOICE
    FactoryBot.create :styling, stylable: ex1.questions.first.stems.first, style: Style::FREE_RESPONSE
    ex1.publication.publish.save!

    ex2 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:5e1ff6e7-0980-4ae0-bc8a-4b591a7c1760' ]
    ex2.questions.first.stems.first.stylings.first.update_attribute :style, Style::TRUE_FALSE
    FactoryBot.create :styling, stylable: ex2.questions.first.stems.first, style: Style::FREE_RESPONSE
    ex2.publication.publish.save!

    ex3 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:5e1ff6e7-0980-4ae0-bc8a-4b591a7c1760' ]
    ex3.questions.first.stems.first.stylings.first.update_attribute :style, Style::MULTIPLE_CHOICE
    ex3.publication.publish.save!

    ex4 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:59221da8-5fb6-4b3e-9450-079cd616385b' ]
    ex4.questions.first.stems.first.stylings.first.update_attribute :style, Style::TRUE_FALSE
    ex4.publication.publish.save!

    ex5 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:59221da8-5fb6-4b3e-9450-079cd616385b' ]
    ex5.questions.first.stems.first.stylings.first.update_attribute :style, Style::FREE_RESPONSE
    ex5.publication.publish.save!

    ex6 = FactoryBot.create :exercise, tags: [ 'context-cnxmod:59221da8-5fb6-4b3e-9450-079cd616385b' ]
    ex6.questions.first.stems.first.stylings.first.update_attribute :style, Style::MULTIPLE_CHOICE
    ex6.publication.publish.save!

    Rake.application.invoke_task "books:breakdown[#{book_uuid},#{filename}]"

    rows = CSV.read filename
    expect(rows.first).to eq([
      'UUID', 'Type', 'Number', 'Title', 'Total Exercises', '2-step MC/TF', 'MC/TF only', 'FR only'
    ])
    expect(rows.second).to eq([
      '14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22', 'Book', '', 'Anatomy and Physiology', '6', '2', '3', '1'
    ])
    expect(rows.third).to eq([
      '7c42370b-c3ad-48ac-9620-d15367b882c6', 'Page', '', 'Preface', '0', '0', '0', '0'
    ])
    expect(rows.fourth).to eq([
      'd3ad443b-78fa-551e-a67f-182bd0cb4c77', 'Unit/Chapter', '1', 'Unit 1 Levels of Organization', '6', '2', '3', '1'
    ])
    expect(rows.fifth).to eq([
      '5ae6cc38-7b7b-5e9c-a7a4-5d8251baac7f',
      'Unit/Chapter',
      '1',
      'Chapter 1 An Introduction to the Human Body',
      '6',
      '2',
      '3',
      '1'
    ])
    expect(rows[5]).to eq([
      'ccc4ed14-6c87-408b-9934-7a0d279d853a', 'Page', '', 'Introduction', '0', '0', '0', '0'
    ])
    expect(rows[6]).to eq([
      'ada35081-9ec4-4eb8-98b2-3ce350d5427f',
      'Page',
      '1.1',
      '1.1 Overview of Anatomy and Physiology',
      '1',
      '1',
      '0',
      '0'
    ])
    expect(rows[7]).to eq([
      '5e1ff6e7-0980-4ae0-bc8a-4b591a7c1760',
      'Page',
      '1.2',
      '1.2 Structural Organization of the Human Body',
      '2',
      '1',
      '1',
      '0'
    ])
    expect(rows[8]).to eq([
      '59221da8-5fb6-4b3e-9450-079cd616385b', 'Page', '1.3', '1.3 Functions of Human Life', '3', '0', '2', '1'
    ])
    rows[9..-1].each do |row|
      expect(row[4..-1]).to eq(['0', '0', '0', '0'])
    end
  ensure
    FileUtils.rm_f filename
  end
end
