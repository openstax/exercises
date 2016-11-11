namespace :vocab_terms do
  desc 'unlinks all vocab terms that are currently linked to other terms'
  task :unlink, :environment do
    VocabTerm.joins(:vocab_distractors).latest(scope: VocabTerm.all).uniq.find_each do |vocab_term|
      vocab_term = vocab_term.new_version if vocab_term.is_published?
      vocab_term.unlink.save!
    end
  end
end
