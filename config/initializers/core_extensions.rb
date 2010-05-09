class Array; def get_sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end
