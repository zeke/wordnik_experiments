Factory.define :word do |m|
  m.sequence(:spelling) { |i| "word#{i}" }  
end