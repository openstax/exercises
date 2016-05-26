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

    def import_row(row, row_number)
      term = row[4]
      return if term.blank?

      term = term.to_s.strip

      @term_row_map ||= {}
      existing_row = @term_row_map[term.downcase]
      raise "Duplicate Term: Rows #{existing_row} and #{row_number} (#{term})" \
        unless existing_row.nil?
      @term_row_map[term.downcase] = row_number

      book_title = row[0]
      uuid = row[3]
      lo = row[5]
      distractor_terms = row[6..-2]
      definition = row[-1]

      book = BOOK_NAMES[book_title]

      book_tag = "book:stax-#{book}"
      lo_tag = "lo:stax-#{book}:#{lo}"
      cnxmod_tag = "context-cnxmod:#{uuid}"

      @latest_term_map ||= Hash.new do |hash, key|
        hash[key] = VocabTerm.joins([:publication, vocab_term_tags: :tag])
                             .where(name: key, vocab_term_tags: {tag: {name: book_tag}})
                             .order{[publication.number.desc, publication.version.desc]}.first
      end

      @term_map ||= Hash.new do |hash, key|
        hash[key] = VocabTerm.new(name: key, definition: 'N/A').tap do |term|
          unless @latest_term_map[key].nil?
            term.publication.number = @latest_term_map[key].publication.number
            term.publication.version = @latest_term_map[key].publication.version + 1
          end
        end
      end

      vt = @term_map[term]
      vt.definition = definition
      vt.tags = [book_tag, lo_tag, cnxmod_tag]

      vt.vocab_distractors = distractor_terms.map do |dt|
        next if dt.blank?

        distractor_term = @term_map[dt]
        distractor_term.save! # Save before linking to other terms
        VocabDistractor.new(distractor_term: distractor_term)
      end.compact

      vt.publication.authors << Author.new(user: author) if author
      vt.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder) \
        if copyright_holder

      vt.save! # Save before comparing with existing records

      if vt.content_equals?(@latest_term_map[term])
        vt.destroy!
        @term_map[term] = @latest_term_map[term]

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
      uid = skipped ? "Existing uid: #{@latest_term_map[term].uid}" : "New uid: #{vt.uid}"
      changes = skipped ? "Vocab term skipped (no changes)" : \
                          "New #{@latest_term_map[term].nil? ? 'vocab term' : 'version'}"
      Rails.logger.info "#{row} - #{uid} - #{changes}"
    end

  end
end
