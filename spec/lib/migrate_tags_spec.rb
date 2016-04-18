require 'rails_helper'
require 'migrate_tags'

RSpec.describe MigrateTags do
  context 'high school' do
    it 'does not assign new LO tags' do
      ex = FactoryGirl.create :exercise, tags: ['k12phys-ch01-s01-lo01']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('k12phys-ch01-s01-lo01')
      expect(tag_names).not_to include('lo:stax-k12phys:1-1-1')
    end

    it 'does not assign new APLO tags' do
      ex = FactoryGirl.create :exercise, tags: ['apbio-ch01-s01-aplo-1-1']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('apbio-ch01-s01-aplo-1-1')
      expect(tag_names).not_to include('lo:aplo-bio:1-1')
    end

    it 'does not migrate chapter tags' do
      ex = FactoryGirl.create :exercise, tags: ['k12phys-ch01']
      described_class.call
      expect{ described_class.call }.not_to change{ ex.reload.tags }
    end

    it 'assigns new id tags' do
      ex = FactoryGirl.create :exercise, tags: ['k12phys-ch01-ex001']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('k12phys-ch01-ex001')
      expect(tag_names).to include('exid:k12phys-ch01-ex001')
    end

    it 'assigns cnxmod tags based on section tags' do
      ex = FactoryGirl.create :exercise, tags: ['k12phys-ch01-s01']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('k12phys-ch01-s01')
      expect(tag_names).to include('context-cnxmod:17f6ff53-2d92-4669-acdd-9a958ea7fd0a')
    end

    it 'assigns new book tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['k12phys']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('k12phys')
      expect(tag_names).to include('book:stax-k12phys')
    end

    it 'assigns new DoK tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['dok1']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('dok1')
      expect(tag_names).to include('dok:1')
    end

    it 'does not create dok:: tags' do
      ex = FactoryGirl.create :exercise, tags: ['dok:1']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('dok:1')
      expect(tag_names).not_to include('dok::1')
    end

    it 'assigns new Blooms tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['blooms-1']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('blooms-1')
      expect(tag_names).to include('blooms:1')
    end

    it 'does not create blooms:: tags' do
      ex = FactoryGirl.create :exercise, tags: ['blooms:1']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('blooms:1')
      expect(tag_names).not_to include('blooms::1')
    end

    it 'assigns new time tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['time-short']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('time-short')
      expect(tag_names).to include('time:short')
    end

    it 'does not create time:: tags' do
      ex = FactoryGirl.create :exercise, tags: ['time:short']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('time:short')
      expect(tag_names).not_to include('time::short')
    end

    it 'removes display tags' do
      ex = FactoryGirl.create :exercise, tags: ['display-foo', 'display:foo']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to be_empty
    end

    it 'assigns new tags for os-practice-concepts' do
      ex = FactoryGirl.create :exercise, tags: ['os-practice-concepts']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('os-practice-concepts')
      expect(tag_names).to include('type:conceptual-or-recall')
    end

    it 'assigns new tags for os-practice-problems' do
      ex = FactoryGirl.create :exercise, tags: ['os-practice-problems']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('os-practice-problems')
      expect(tag_names).to include('type:practice')
    end

    it 'assigns new tags for ost-chapter-review' do
      ex = FactoryGirl.create :exercise, tags: ['ost-chapter-review']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('ost-chapter-review')
      expect(tag_names).not_to include('type:conceptual')
      expect(tag_names).to include('type:practice')
    end

    it 'assigns new tags for ost-chapter-review and concept' do
      ex = FactoryGirl.create :exercise, tags: ['ost-chapter-review', 'concept']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('ost-chapter-review')
      expect(tag_names).to include('concept')
      expect(tag_names).to include('type:conceptual')
      expect(tag_names).not_to include('type:practice')
    end

    it 'assigns new tags for ost-chapter-review, review, time-short, apbio' do
      ex = FactoryGirl.create :exercise, tags: ['ost-chapter-review', 'review',
                                                'time-short', 'apbio']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('ost-chapter-review')
      expect(tag_names).to include('review')
      expect(tag_names).to include('time-short')
      expect(tag_names).to include('apbio')
      expect(tag_names).to include('type:conceptual-or-recall')
      expect(tag_names).not_to include('type:practice')
      expect(tag_names).to include('book:stax-apbio')
      expect(tag_names).to include('time:short')
    end

    it 'assigns new tags for ost-test-prep' do
      ex = FactoryGirl.create :exercise, tags: ['ost-test-prep']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('ost-test-prep')
      expect(tag_names).to include('type:practice')
    end

    it 'migrates grasp-check correctly' do
      ex = FactoryGirl.create :exercise, tags: ['grasp-check']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('grasp-check')
      expect(tag_names).to include('type:practice')
      expect(tag_names).to include('filter-type:import:has-context')
    end

    it 'assigns new tags for visual-connection' do
      ex = FactoryGirl.create :exercise, tags: ['visual-connection']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('visual-connection')
      expect(tag_names).to include('type:practice')
      expect(tag_names).to include('filter-type:import:has-context')
    end

    it 'assigns new tags for interactive' do
      ex = FactoryGirl.create :exercise, tags: ['interactive']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('interactive')
      expect(tag_names).to include('type:practice')
      expect(tag_names).to include('filter-type:import:has-context')
    end

    it 'assigns new tags for evolution' do
      ex = FactoryGirl.create :exercise, tags: ['evolution']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('evolution')
      expect(tag_names).to include('type:practice')
      expect(tag_names).to include('filter-type:import:has-context')
    end

    it 'assigns new tags for ap-test-prep' do
      ex = FactoryGirl.create :exercise, tags: ['ap-test-prep']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).to include('ap-test-prep')
      expect(tag_names).to include('type:practice')
    end
  end

  context 'concept coach' do
    it 'migrates id tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['id:blah']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).not_to include('id:blah')
      expect(tag_names).to include('exid:blah')
    end

    it 'migrates type tags correctly' do
      ex = FactoryGirl.create :exercise, tags: ['ost-type:foo']
      described_class.call
      tag_names = ex.reload.tags.map(&:name)
      expect(tag_names).not_to include('ost-type:foo')
      expect(tag_names).to include('type:foo')
    end
  end
end
