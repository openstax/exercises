# Imports a spreadsheet containing vocab terms
module VocabTerms
  module Importer

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
    include Publishable::Importer
    include RowParser

    def import_row(row, row_number)
      term = row[4]
      return if term.blank?

      term = term.to_s.strip
      chapter = row[2].split('-').first.to_i

      @term_row_map ||= {}
      existing_row, existing_chapter = @term_row_map[term.downcase]
      unless existing_row.nil?
        Rails.logger.info do
          "WARNING: Duplicate term \"#{term}\" found in rows #{existing_row} (chapter #{
          existing_chapter}) and #{row_number} (chapter #{chapter})"
        end

        raise "Term \"#{term}\" appears twice in chapter #{chapter}" \
          if existing_chapter == chapter
      end
      @term_row_map[term.downcase] = [row_number, chapter]

      book_title = row[0]
      uuid = row[3]
      lo = row[5]
      distractor_terms = row[6..-2]
      definition = row[-1]

      book = BOOK_NAMES[book_title]

      book_tag = "book:stax-#{book}"
      lo_tag = "lo:stax-#{book}:#{lo}"
      cnxmod_tag = "context-cnxmod:#{uuid}"
      dok_tag = 'dok:1'
      blooms_tag = 'blooms:1'
      time_tag = 'time:short'
      type_tag = 'type:recall'

      @latest_term_map ||= Hash.new do |hash, chapter|
        hash[chapter] = Hash.new do |hash, name|
          lo_like = "lo:stax-#{book}:#{chapter}-%"
          ta = Tag.arel_table
          pub = Publication.arel_table
          pubg = PublicationGroup.arel_table
          hash[name] = VocabTerm.joins([{publication: :publication_group}, {vocab_term_tags: :tag}]).where(name: name).where(ta[:name].matches lo_like).order([pubg[:number].desc, pub[:version].desc]).first
        end
      end

      @term_map ||= Hash.new do |hash, chapter|
        hash[chapter] = Hash.new do |hash, name|
          hash[name] = VocabTerm.new(name: name, definition: 'N/A').tap do |term|
            unless @latest_term_map[chapter][name].nil?
              term.publication.publication_group = \
                @latest_term_map[chapter][name].publication.publication_group
              term.publication.version = @latest_term_map[chapter][name].publication.version + 1
            end
          end
        end
      end

      vt = @term_map[chapter][term]
      vt.definition = definition
      vt.tags = [book_tag, lo_tag, cnxmod_tag, dok_tag, blooms_tag, time_tag, type_tag]

      # http://stackoverflow.com/a/8922049
      grouped_distractor_terms = distractor_terms.reject(&:blank?).group_by { |elt| elt }
      duplicate_distractor_terms = grouped_distractor_terms.select { |k, v| v.size > 1}.map(&:first)
      uniq_distractor_terms = grouped_distractor_terms.keys

      duplicate_distractor_terms.each do |ddt|
        Rails.logger.info do
          "WARNING: Duplicate distractor term \"#{ddt}\" found in row #{row_number}"
        end
      end

      vt.vocab_distractors = uniq_distractor_terms.map do |dt|
        distractor_term = @term_map[chapter][dt]
        VocabDistractor.new(distractor_term: distractor_term)
      end

      vt.publication.authors << Author.new(user: author) if author
      vt.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder) \
        if copyright_holder

      vt.save!
      vt.publication.publish.save!

      if vt.content_equals?(@latest_term_map[chapter][term])
        vt.destroy!
        @term_map[chapter][term] = @latest_term_map[chapter][term]

        skipped = true
      else
        chapter = /\A(\d+)-\d+-\d+\z/.match(lo)[1]
        list_name = "#{book_title.capitalize} Chapter #{chapter}"
        @lists ||= {}
        @lists[list_name] ||= List.find_or_create_by!(name: list_name) do |list|
          [author, copyright_holder].compact.uniq.each do |owner|
            list.list_owners << ListOwner.new(owner: owner)
          end

          Rails.logger.info { "Created new list: #{list_name}" }
        end
        list = @lists[list_name]

        lpg = ListPublicationGroup.new(
          list: list, publication_group: vt.publication.publication_group
        )
        vt.publication.publication_group.list_publication_groups << lpg
        list.list_publication_groups << lpg

        skipped = false
      end

      Rails.logger.info do
        row = "Imported row ##{row_number}"
        uid = skipped ? "Existing uid: #{@latest_term_map[chapter][term].uid}" :
                        "New uid: #{vt.uid}"
        changes = skipped ? "Vocab term skipped (no changes)" :
                            "New #{vt.version == 1 ? 'vocab term' : 'version'}"
        "#{row} - #{uid} - #{changes}"
      end
    end

  end
end
