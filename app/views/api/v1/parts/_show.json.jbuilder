json.(part, :id, :position, :credit)
json.background do 
  json.partial! 'api/v1/contents/show', content: part.background
end
json.questions part.questions, partial: 'api/v1/questions/show'