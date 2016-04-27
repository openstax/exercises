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

      @term_row_map ||= {}
      existing_row = @term_row_map[term]
      raise "Duplicate Term: Rows #{existing_row} and #{row_number}" unless existing_row.nil?
      @term_row_map[term] = row_number

      book_title = row[0]
      uuid = row[3]
      lo = row[5]
      distractors = row[6..-2]
      definition = row[-1]

      book = BOOK_NAMES[book_title]

      book_tag = "book:stax-#{book}"

      @term_map ||= {}
      @term_map[term] ||= VocabTerm.new(name: name, definition: definition)
      vt = @term_map[term]

      lo_tag = "lo:stax-#{book}:#{lo}"

      cnxmod_tag = "context-cnxmod:#{uuid}"

      vt.tags = [book_tag, lo_tag, cnxmod_tag]

      latest_vocab_term = VocabTerm.joins([:publication, vocab_term_tags: :tag])
                                   .where(vocab_term_tags: {tag: {name: book_tag}})
                                   .order{[publication.number.desc, publication.version.desc]}.first

      unless latest_vocab_term.nil?
        vt.publication.number = latest_vocab_term.publication.number
        vt.publication.version = latest_vocab_term.publication.version + 1
      end

      vt.save!

      vt.distractor_terms = distractors.map{ |distractor| @term_map[distractor] }

      if author
        au = Author.new
        au.publication = vt.publication
        au.user = author
        vt.publication.authors << au
      end

      if copyright_holder
        cc = CopyrightHolder.new
        cc.publication = vt.publication
        cc.user = copyright_holder
        vt.publication.copyright_holders << cc
      end

      chapter = /\A(\d+)-\d+-\d+\z/.match(lo)[1]
      list_name = "#{book.capitalize} Chapter #{chapter}"

      list = List.find_by(name: list_name)
      if list.nil?
        list = List.create(name: list_name)

        [author, copyright_holder].compact.uniq.each do |u|
          lo = ListOwner.new
          lo.owner = u
          lo.list = list
          list.list_owners << lo
        end

        list.save!
        Rails.logger.info "Created new list: #{list_name}"
      end

      lvt = ListVocabTerm.new
      lvt.vocab_term = vt
      lvt.list = list
      vt.list_vocab_terms << lvt
      vt.save!
      list.list_vocab_terms << lvt

      if vt.content_equals?(latest_vocab_term)
        vt.destroy
        skipped = true
        @term_map[term] = latest_vocab_term
      else
        skipped = false
        @term_map[term] = vt
      end

      row = "Imported row ##{row_number}"
      uid = skipped ? "Existing uid: #{latest_vocab_term.uid}" : "New uid: #{vt.uid}"
      changes = skipped ? "Vocab term skipped (no changes)" : \
                          "New #{latest_vocab_term.nil? ? 'vocab term' : 'version'}"
      Rails.logger.info "#{row} - #{uid} - #{changes}"
    end

  end
end
