Factory.define :wordstat do |m|
	m.word { |a| a.association(:word) }
  m.lookup_count 1
  m.favorite_count 2
  m.list_count 3
  m.comment_count 4
end