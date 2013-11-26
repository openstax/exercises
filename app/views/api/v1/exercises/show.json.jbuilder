json.(@exercise, :id, :number, :version)
json.background do
  json.partial!('api/v1/contents/show', content: @exercise.background)
end
json.parts @exercise.parts do |part|
  json.partial! 'api/v1/parts/show', part: part
end


