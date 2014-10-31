class ParseContent

  lev_routine transaction: :no_transaction

  protected

  def exec(content)
    outputs[:content] = ActionView::Base.new.auto_link(
                          content, :html => { :target => '_blank' }
                        )
  end

end
