json.array!(@questions) do |question|
  json.extract! question, :id, :project_id, :subject, :content
  json.url question_url(question, format: :json)
end
