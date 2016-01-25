json.array!(@pictures) do |picture|
  json.extract! picture, :id, :picture_path, :name, :user_id
  json.url picture_url(picture, format: :json)
end
