require 'rails_helper'
require 'rake'

RSpec.describe 'exercises tag', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/tag"
    Rake::Task.define_task(:environment)
  end

  context 'import_from_module_map' do
    let(:fixture_path) { './spec/fixtures/sample_module_map.csv' }

    let :run_rake_task do
      Rake::Task["exercises:tag:import_from_module_map"].reenable
      Rake.application.invoke_task "exercises:tag:import_from_module_map[#{fixture_path}]"
    end

    it 'adds additional tags' do
      exercise = FactoryBot.create :exercise
      exercise.exercise_tags << FactoryBot.create(:exercise_tag, tag: FactoryBot.create(:tag, name: "context-cnxmod:c6b53107-4efb-48a9-8ccf-4db622f029f3"))
      expect{
        run_rake_task
      }.to change{ exercise.tags.reload.count }.by(1)
      # adds the matching tag
      expect(exercise.tags.where(name:"context-cnxmod:ea90794e-0043-4160-a494-3f370885c7e3")).to exist
      # skips tag that wasn't found
      expect(exercise.tags.where(name:"context-cnxmod:2f8a5d38-00d5-4c53-8df5-01294fb5a764")).not_to exist
    end
  end

  context 'spreadsheet' do
    let(:fixture_path) { '../spec/fixtures/sample_tags.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:tag:spreadsheet"].reenable
      Rake.application.invoke_task "exercises:tag:spreadsheet[#{fixture_path}]"
    end

    it 'passes arguments to Exercises::Tag::Spreadsheet' do
      expect(Exercises::Tag::Spreadsheet).to(
        receive(:call).with(filename: fixture_path)
      )
      run_rake_task
    end
  end

  context 'assessments' do
    let(:fixture_path) { '../spec/fixtures/sample_assessment_tags.xlsx' }
    let(:book_uuid)    { SecureRandom.uuid }

    let :run_rake_task do
      Rake::Task["exercises:tag:assessments"].reenable
      Rake.application.invoke_task "exercises:tag:assessments[#{fixture_path},#{book_uuid}]"
    end

    it 'passes arguments to Exercises::Tag::Assessments' do
      expect(Exercises::Tag::Assessments).to(
        receive(:call).with(filename: fixture_path, book_uuid: book_uuid)
      )
      run_rake_task
    end
  end

  context 'wrq' do
    let(:fixture_path) { '../spec/fixtures/sample_tag_wrqs.xlsx' }
    let(:book_uuid)    { SecureRandom.uuid }

    let :run_rake_task do
      Rake::Task["exercises:tag:wrq"].reenable
      Rake.application.invoke_task "exercises:tag:wrq[#{fixture_path},#{book_uuid}]"
    end

    it 'passes arguments to Exercises::Tag::WrittenResponse' do
      expect(Exercises::Tag::WrittenResponse).to(
        receive(:call).with(filename: fixture_path, book_uuid: book_uuid)
      )
      run_rake_task
    end
  end

  context 'convert_eoc' do
    let(:book_uuid)   { SecureRandom.uuid }
    let(:book_slug)   { 'rspec-convert-eoc-book' }
    let(:output_path) { "#{book_slug}.csv" }

    let(:chapter_1_uuid) { SecureRandom.uuid }
    let(:chapter_2_uuid) { SecureRandom.uuid }

    let :book do
      tree = {
        'id' => "#{SecureRandom.uuid}@1",
        'title' => 'Test Book',
        'contents' => [
          { 'id' => "#{chapter_1_uuid}@1", 'title' => 'Chapter 1', 'contents' => [] },
          { 'id' => "#{chapter_2_uuid}@1", 'title' => 'Chapter 2', 'contents' => [] }
        ]
      }

      OpenStax::Content::Book.new(
        archive: OpenStax::Content::Archive.new(version: 'test'),
        uuid: book_uuid, version: '1', slug: book_slug, hash: { 'tree' => tree }
      )
    end

    before { allow(FindBook).to receive(:[]).with(uuid: book_uuid).and_return(book) }

    after { FileUtils.rm_f(output_path) }

    let :run_rake_task do
      Rake::Task["exercises:tag:convert_eoc"].reenable
      Rake.application.invoke_task "exercises:tag:convert_eoc[dummy.xlsx,#{book_uuid},false]"
    end

    def written_rows
      CSV.read(output_path)
    end

    context 'with a numeric Exercise ID column' do
      before do
        allow(ProcessSpreadsheet).to receive(:call) do |**_kwargs, &block|
          # Roo::Excelx returns numeric cells as Floats; ProcessSpreadsheet stringifies
          # them, so a real "101" cell arrives here as the string "101.0".
          block.call(['chapter', 'exercise id'], ['1', '101.0'], 0)
          block.call(['chapter', 'exercise id'], ['1', '102.0'], 1)
          block.call(['chapter', 'exercise id'], ['2', '201.0'], 2)
        end
      end

      it 'writes plain integer exercise IDs, not float-formatted strings' do
        run_rake_task

        rows = written_rows
        expect(rows.first).to eq(['Exercise ID', 'Tags...'])
        expect(rows[1..].map(&:first)).to eq(%w(101 102 201))
      end

      it 'tags each exercise with its own chapter uuid' do
        run_rake_task

        rows = written_rows
        expect(rows[1][1]).to eq(
          "assessment:practice:https://openstax.org/orn/book:subbook/#{book_uuid}:#{chapter_1_uuid}"
        )
        expect(rows[3][1]).to eq(
          "assessment:practice:https://openstax.org/orn/book:subbook/#{book_uuid}:#{chapter_2_uuid}"
        )
      end
    end

    context 'with an Exercise Nickname column (no ID column present)' do
      before do
        allow(ProcessSpreadsheet).to receive(:call) do |**_kwargs, &block|
          block.call(['chapter', 'exercise nickname'], ['1', '01-01-TB-AQ01'], 0)
        end
      end

      it 'leaves the nickname untouched instead of trying to coerce it to a number' do
        run_rake_task

        rows = written_rows
        expect(rows.first).to eq(['Exercise Nickname', 'Tags...'])
        expect(rows[1][0]).to eq('01-01-TB-AQ01')
      end
    end
  end
end
