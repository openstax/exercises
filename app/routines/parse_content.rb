class ParseContent

  lev_routine transaction: :no_transaction

  protected

  def exec(content)
    linked_content = Rinku.auto_link(content, :urls, 'target="_blank"')
    outputs[:content] = linked_content
  end

end
