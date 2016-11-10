namespace :vocab_terms do
  desc "unlinks all vocab terms that are currently linked to other terms"
  task :unlink, :environment do
    VocabTerm.joins(:vocab_distractors).uniq.find_each{ |vocab_term| vocab_term.unlink.save! }
  end
end
