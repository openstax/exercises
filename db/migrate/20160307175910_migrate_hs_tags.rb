require 'open-uri'

class MigrateHsTags < ActiveRecord::Migration
  BOOK_UUIDS = {
    'k12phys' => '334f8b61-30eb-4475-8e05-5260a4866b4b',
    'apbio' => 'd52e93f4-8653-4273-86da-3850001c0786'
  }

  # Creates new tags for HS questions but does not delete the old ones
  # Does not create new LO tags
  # Migrate LO's and delete old tags after May 30th
  def up
    # Get module UUID's from CNX
    cnx_id_map = Hash.new{ |hash, key| hash[key] = Hash.new{ |hash, key| hash[key] = {} } }
    BOOK_UUIDS.each do |book_name, uuid|
      url = "https://archive-staging-tutor.cnx.org/contents/#{uuid}.json"
      hash = open(url) { |f| JSON.parse(f.read) }
      map_collection(hash['tree'], cnx_id_map[book_name])
    end

    # LO tags (unchanged for now)
    lo_tags = Tag.where{name.like ['k12phys-ch%-s%-lo%', 'apbio-ch%-s%-lo%']} # Used by Tutor
    aplo_tags = Tag.where{name.like 'apbio-ch%-s%-aplo-%'} # Used by Tutor
    all_lo_tags = lo_tags + aplo_tags

    # ID tags
    id_tags = Tag.where{name.like ['k12phys-ch%-ex%', 'apbio-ch%-ex%']} # Used by CNX
    id_tags.sort_by(&:name).each_with_index do |tag, index|
      name, book_name = /\A(\d+)-ch\d+-ex\d+\z/.match tag.name
      # The new format does not have the chapter number
      new_tag tag, "exid:stax-#{book_name}:#{index}"
    end

    # Book location tags
    section_and_all_lo_tags = Tag.where{name.like ['k12phys-ch%-s%', 'apbio-ch%-s%']}
    section_tags = section_and_all_lo_tags - all_lo_tags
    section_tags.each do |tag|
      name, book_name, chapter, section = /\A(\d+)-ch(\d+)-s(\d+)\z/.match tag.name
      uuid = cnx_id_map[book_name][chapter.to_i][section.to_i]
      new_tag tag, "cnxmod:#{uuid}"
    end

    book_tags = Tag.where(name: ['k12phys', 'apbio']) # Unused
    book_tags.each{ |tag| tag.update_attribute :name, "book:stax-#{tag.name}" }

    # DoK, Blooms, Time
    dok_tags = Tag.where{name.like 'dok%'} # Used in Tutor
    dok_tags.each{ |tag| new_tag tag, tag.name.gsub(/dok-?/, 'dok:') }

    blooms_tags = Tag.where{name.like 'blooms%'} # Used in Tutor
    blooms_tags.each{ |tag| new_tag tag, tag.name.gsub(/blooms-?/, 'blooms:') }

    time_tags = Tag.where{name.like 'time%'} # Used in Tutor
    time_tags.each{ |tag| new_tag tag, tag.name.gsub(/time-?/, 'time:') }

    # Display tags (Unused - Remove)
    Tag.where{name.like 'display%'}.destroy_all

    # Requires choices tags (Unused - Remove)
    Tag.where{name.like 'requires-choices:%'}.destroy_all

    # Tagging legend changes
    tl_id_tags = Tag.where{name.like 'id:%'} # Unused (CC does not use exercise ID's)
    tl_id_tags.each{ tag.update_attribute :name, tag.name.gsub('id:', 'exid:') }

    tl_type_tags = Tag.where{name.like 'ost-type:%'} # Unused (CC uses all exercises)
    tl_type_tags.each{ |tag| tag.update_attribute :name, tag.name.gsub('ost-type:', 'type:') }

    # Type tags
    inbook_tag = Tag.find_by(name: 'inbook-yes') # Unused
    inbook_tag.update_attribute :name, 'type:conceptual-or-recall'

    grasp_check_tag = Tag.find_by(name: 'grasp-check') # Unused
    grasp_check_tag.update_attribute :name, 'filter-type:grasp-check'

    old_practice_tag = Tag.find_by(name: 'os-practice-problems') # Used by Tutor
    new_tag old_practice_tag, 'type:practice'

    old_concepts_tag = Tag.find_by(name: 'os-practice-concepts') # Used by Tutor
    new_tag old_concepts_tag, 'type:conceptual'

    conceptual_tag = Tag.find_or_create_by(name: 'type:conceptual')
    practice_tag = Tag.find_or_create_by(name: 'type:practice')

    old_cr_tag = Tag.find_by(name: 'ost-chapter-review') # Used by Tutor
    chapter_review_exercise_tags = old_cr_tag.try(:exercise_tags)
                                             .try(:preload, exercise: :tags) || []
    chapter_review_exercise_tags.each do |et|
      tag = et.exercise.tags.map(&:name).include?('concept') ? conceptual_tag : practice_tag
      ExerciseTag.create!(exercise: et.exercise, tag: tag)
    end
    new_tag old_cr_tag, 'filter-type:chapter-review'

    old_tp_tag = Tag.find_by(name: 'ost-test-prep') # Unused
    new_tag old_tp_tag, 'type:practice'
    new_tag old_tp_tag, 'filter-type:test-prep'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Just restore the backup...'
  end

  protected

  # Creates a new tag and associates it with the same records as the given tag
  def new_tag(tag, name)
    return if tag.nil?

    @tags ||= {}
    @tags[name] ||= Tag.find_or_create_by(name: name)
    tag.exercise_tags.each{ |et| ExerciseTag.create!(exercise: et.exercise, tag: @tags[name]) }
  end

  # Puts the module UUID's from a CNX archive JSON hash into the cnx_id_map
  def map_collection(hash, cnx_id_map, chapter_number = 0)
    contents = hash['contents']
    chapter_number += 1 if contents.none?{ |hash| hash['id'] == 'subcol' }

    page_number = nil
    contents.each do |entry|
      if entry['id'] == 'subcol'
        chapter_number = map_collection(entry, cnx_id_map, chapter_number)
      else
        page_number ||= entry['title'].start_with?('Introduction') ? 0 : 1
        cnx_id_map[chapter_number][page_number] = entry['id'].split('@').first
        page_number += 1
      end
    end

    return chapter_number
  end
end
