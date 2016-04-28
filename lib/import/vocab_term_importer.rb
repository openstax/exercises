# Imports a spreadsheet containing vocab terms
module Import
  module VocabTermImporter

    BOOK_NAMES = {
      'Anatomy and Physiology' => 'anp',
      'Biology' => 'bio',
      'College Physics' => 'phys',
      'Concepts of Biology' => 'cbio',
      'Introduction to Sociology 2e' => 'soc',
      'Principles of Economics' => 'econ',
      'Principles of Macroeconomics' => 'macro',
      'Principles of Microeconomics' => 'micro'
    }
    include PublishableImporter
    include RowParser

    def populate_term_map(row, row_number)
      term = row[4]

      @term_row_map ||= {}
      existing_row = @term_row_map[term]
      raise "Duplicate Term: Rows #{existing_row} and #{row_number}" unless existing_row.nil?
      @term_row_map[term] = row_number

      @term_map ||= {}

    end

    def import_term(row, row_number)
      term = row[4]

      @term_row_map ||= {}
      existing_row = @term_row_map[term]
      raise "Duplicate Term: Rows #{existing_row} and #{row_number}" unless existing_row.nil?
      @term_row_map[term] = row_number

      book_title = row[0]
      uuid = row[3]
      lo = row[5]
      distractor_terms = row[6..-2]
      definition = row[-1]

      book = BOOK_NAMES[book_title]

      book_tag = "book:stax-#{book}"

      @term_map ||= Hash.new{ |hash, key| hash[key] = VocabTerm.new(name: key) }
      vt = @term_map[term]
      vt.definition = definition

      lo_tag = "lo:stax-#{book}:#{lo}"

      cnxmod_tag = "context-cnxmod:#{uuid}"

      vt.tags = [book_tag, lo_tag, cnxmod_tag]

      vt_id = vt.id
      latest_vocab_term = VocabTerm.joins([:publication, vocab_term_tags: :tag])
                                   .where{id != vt_id}
                                   .where(name: term, vocab_term_tags: {tag: {name: book_tag}})
                                   .order{[publication.number.desc, publication.version.desc]}.first

      unless latest_vocab_term.nil?
        vt.publication.number = latest_vocab_term.publication.number
        vt.publication.version = latest_vocab_term.publication.version + 1
      end

      vt.distractor_terms = distractor_terms.map{ |dt| @term_map[dt] }

      vt.publication.authors << Author.new(user: author) if author
      vt.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder) \
        if copyright_holder

      if vt.content_equals?(latest_vocab_term)
        vt.vocab_distracteds.each do |vocab_distracted|
          vocab_distracted.update_attribute :distractor_term, latest_vocab_term
        end
        vt.vocab_distracteds.reset

        vt.destroy! if vt.persisted?
        @term_map[term] = latest_vocab_term

        skipped = true
      else
        chapter = /\A(\d+)-\d+-\d+\z/.match(lo)[1]
        list_name = "#{book.capitalize} Chapter #{chapter}"
        @lists ||= {}
        @lists[list_name] ||= List.find_or_create_by!(name: list_name) do |list|
          [author, copyright_holder].compact.uniq.each do |owner|
            list.list_owners << ListOwner.new(owner: owner)
          end

          Rails.logger.info "Created new list: #{list_name}"
        end
        list = @lists[list_name]

        lvt = ListVocabTerm.new(list: list, vocab_term: vt)
        vt.list_vocab_terms << lvt
        list.list_vocab_terms << lvt
        vt.save!
        vt.publication.publish.save!

        skipped = false
      end

      row = "Imported row ##{row_number}"
      uid = skipped ? "Existing uid: #{latest_vocab_term.uid}" : "New uid: #{vt.uid}"
      changes = skipped ? "Vocab term skipped (no changes)" : \
                          "New #{latest_vocab_term.nil? ? 'vocab term' : 'version'}"
      Rails.logger.info "#{row} - #{uid} - #{changes}"
    end

  end
end
