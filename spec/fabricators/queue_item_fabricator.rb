Fabricator(:queue_item) do
  video
  position { (1..10).to_a.sample }
end