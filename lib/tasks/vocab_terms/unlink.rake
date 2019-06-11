namespace :vocab_terms do
  desc 'unlinks all vocab terms that are currently linked to other terms'
  task unlink: :environment do
    VocabTerm.joins(:vocab_distractors).latest.distinct.find_in_batches do |vocab_terms|
      VocabTerm.transaction do
        vocab_terms.each do |vocab_term|
          vocab_term = vocab_term.new_version if vocab_term.is_published?
          vocab_term.unlink.save!
        end
      end
    end
  end
end
