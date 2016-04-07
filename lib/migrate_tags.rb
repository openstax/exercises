require 'open-uri'

# Creates new tags for HS questions but does not delete old ones (except for a few unused tags)
# Also changes all cnxmod tags to context-cnxmod
class MigrateTags

  lev_routine transaction: :no_transaction

  BOOK_UUIDS = {
    'k12phys' => '334f8b61-30eb-4475-8e05-5260a4866b4b',
    'apbio' => 'd52e93f4-8653-4273-86da-3850001c0786'
  }

  def exec
    cnx_id_map = Hash.new{ |hash, key| hash[key] = Hash.new{ |hash, key| hash[key] = {} } }
    BOOK_UUIDS.each do |book_name, uuid|
      url = "https://archive-staging-tutor.cnx.org/contents/#{uuid}.json"
      hash = open(url) { |f| JSON.parse(f.read) }
      map_collection(hash['tree'], cnx_id_map[book_name])
    end

    # Cnxmod tags
    cnxmod_tags = Tag.where{name.like 'cnxmod:%'}
    cnxmod_tags.each{ |tag| tag.update_attribute :name, "context-#{tag.name}" }

    # LO tags
    lo_tags = Tag.where{name.like_any ['k12phys-ch%-s%-lo%', 'apbio-ch%-s%-lo%']} # Used by Tutor
    lo_tags.each do |tag|
      matches = /\A(\w+)-ch(\d+)-s(\d+)-lo(\d+)\z/.match tag.name
      next if matches.nil?

      book_name = matches[1]
      chapter = matches[2]
      section = matches[3]
      lo = matches[4]
      new_tag tag, "lo:stax-#{book_name}:#{chapter.to_i}-#{section.to_i}-#{lo.to_i}"
    end

    aplo_tags = Tag.where{name.like 'apbio-ch%-s%-aplo-%'} # Used by Tutor
    aplo_tags.each do |tag|
      matches = /\Aapbio-ch\d+-s\d+-aplo-([\w-]+)\z/.match tag.name
      next if matches.nil?

      lo = matches[1]
      new_tag tag, "lo:aplo-bio:#{lo}"
    end

    all_lo_tags = lo_tags + aplo_tags

    # ID tags
    id_tags = Tag.where{name.like_any ['k12phys-ch%-ex%', 'apbio-ch%-ex%']} # Used by CNX
    id_tags.preload(exercise_tags: :exercise).sort_by(&:name).each_with_index do |tag, index|
      matches = /\A(\w+)-ch\d+-ex\d+\z/.match tag.name
      next if matches.nil?

      book_name = matches[1]
      # The new format does not have the chapter number
      new_tag tag, "exid:stax-#{book_name}:#{index + 1}"
    end

    # Book location tags
    section_and_all_lo_tags = Tag.where{name.like_any ['k12phys-ch%-s%', 'apbio-ch%-s%']}
                                 .preload(exercise_tags: :exercise)
    section_tags = section_and_all_lo_tags - all_lo_tags
    section_tags.each do |tag|
      matches = /\A(\w+)-ch(\d+)-s(\d+)\z/.match tag.name
      next if matches.nil?

      book_name = matches[1]
      chapter = matches[2]
      section = matches[3]
      uuid = cnx_id_map[book_name][chapter.to_i][section.to_i]
      new_tag tag, "context-cnxmod:#{uuid}"
    end

    book_tags = Tag.where(name: ['k12phys', 'apbio']) # Used in Tutor
    book_tags.each{ |tag| new_tag tag, "book:stax-#{tag.name}" }

    # DoK, Blooms, Time
    dok_tags = Tag.where{name.like 'dok%'} # Used in Tutor
    dok_tags.preload(exercise_tags: :exercise).each do |tag|
      next if tag.name.include? ':'

      new_tag tag, tag.name.gsub('dok', 'dok:')
    end

    blooms_tags = Tag.where{name.like 'blooms-%'} # Used in Tutor
    blooms_tags.preload(exercise_tags: :exercise)
               .each{ |tag| new_tag tag, tag.name.gsub('blooms-', 'blooms:') }

    time_tags = Tag.where{name.like 'time-%'} # Used in Tutor
    time_tags.preload(exercise_tags: :exercise)
             .each{ |tag| new_tag tag, tag.name.gsub('time-', 'time:') }

    # Display tags (Unused - Remove)
    Tag.where{name.like 'display%'}.preload(:exercise_tags).each do |tag|
      tag.exercise_tags.delete_all
      tag.delete
    end

    # Requires choices tags (Unused - Remove)
    Tag.where{name.like 'requires-choices:%'}.preload(:exercise_tags).each do |tag|
      tag.exercise_tags.delete_all
      tag.delete
    end

    # Tagging legend changes
    tl_id_tags = Tag.where{name.like 'id:%'} # Unused (CC does not use exercise ID's)
    tl_id_tags.each{ |tag| tag.update_attribute :name, tag.name.gsub('id:', 'exid:') }

    tl_type_tags = Tag.where{name.like 'ost-type:%'} # Unused (CC uses all exercises)
    tl_type_tags.each{ |tag| tag.update_attribute :name, tag.name.gsub('ost-type:', 'type:') }

    # Type tags
    inbook_tag = Tag.find_or_create_by(name: 'inbook-yes') # Unused
    new_tag inbook_tag, 'type:conceptual-or-recall'
    inbook_tag.destroy

    grasp_check_tag = Tag.find_or_create_by(name: 'grasp-check') # Unused
    new_tag grasp_check_tag, 'filter-type:grasp-check'
    new_tag grasp_check_tag, 'requires-context:y'
    grasp_check_tag.destroy

    visual_connection_tag = Tag.find_or_create_by(name: 'visual-connection') # Unused
    new_tag visual_connection_tag, 'filter-type:grasp-check'
    new_tag visual_connection_tag, 'requires-context:y'

    interactive_tag = Tag.find_or_create_by(name: 'interactive') # Unused
    new_tag interactive_tag, 'filter-type:grasp-check'
    new_tag interactive_tag, 'requires-context:y'

    evolution_tag = Tag.find_or_create_by(name: 'evolution') # Unused
    new_tag evolution_tag, 'filter-type:grasp-check'
    new_tag evolution_tag, 'requires-context:y'

    old_practice_tag = Tag.find_or_create_by(name: 'os-practice-problems') # Used by Tutor
    new_tag old_practice_tag, 'type:practice'

    old_concepts_tag = Tag.find_or_create_by(name: 'os-practice-concepts') # Used by Tutor
    new_tag old_concepts_tag, 'type:conceptual'

    conceptual_tag = Tag.find_or_create_by(name: 'type:conceptual')
    conceptual_or_recall_tag = Tag.find_or_create_by(name: 'type:conceptual-or-recall')
    practice_tag = Tag.find_or_create_by(name: 'type:practice')

    old_cr_tag = Tag.find_or_create_by(name: 'ost-chapter-review') # Used by Tutor
    chapter_review_exercise_tags = old_cr_tag.exercise_tags.preload(exercise: :tags)
    chapter_review_exercise_tags.each do |et|
      tag_names = et.exercise.tags.map(&:name)
      tag = if tag_names.include?('concept')
        conceptual_tag
      elsif tag_names.include?('apbio') &&
            tag_names.include?('review') &&
            tag_names.include?('time-short')
        conceptual_or_recall_tag
      else
        practice_tag
      end
      ExerciseTag.find_or_create_by(exercise: et.exercise, tag: tag)
    end
    new_tag old_cr_tag, 'filter-type:chapter-review'

    old_tp_tag = Tag.find_or_create_by(name: 'ost-test-prep') # Unused
    new_tag old_tp_tag, 'type:practice'
    new_tag old_tp_tag, 'filter-type:test-prep'

    old_ap_tp_tag = Tag.find_or_create_by(name: 'ap-test-prep') # Unused
    new_tag old_ap_tp_tag, 'type:practice'
    new_tag old_ap_tp_tag, 'filter-type:ap-test-prep'
  end

  protected

  # Creates a new tag and associates it with the same records as the given tag
  def new_tag(tag, name)
    return if tag.nil?

    @tags ||= {}
    @tags[name] ||= Tag.find_or_create_by(name: name)
    tag.exercise_tags.each do |et|
      ExerciseTag.find_or_create_by(exercise: et.exercise, tag: @tags[name])
    end
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
