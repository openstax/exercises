class WarmUpCache
  lev_routine transaction: :no_transaction

  protected

  def exec
    Exercise.chainable_latest.find_in_batches(batch_size: 100) do |exercises|
      Api::V1::Exercises::SearchRepresenter.new(items: exercises).to_hash(
        user_options: { can_view_solutions: true }
      )
    end

    VocabTerm.chainable_latest.find_in_batches(batch_size: 100) do |vocab_terms|
      Api::V1::Vocabs::TermSearchRepresenter.new(items: vocab_terms).to_hash
    end
  end
end
