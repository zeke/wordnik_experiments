class Object
  
  unless method_defined? "blank?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/Object.html#M000265
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
  
  # @person ? @person.name : nil
  # vs
  # @person.try(:name)
  # Snagged from http://ozmm.org/posts/try.html; later incorporated into Rails 2.3
  unless method_defined? "try"
    def try(method)
      send method if respond_to? method
    end
  end

  def is_numeric?
    !self.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
  end
  
end

class String

  # Pollute the space between every letter in a string,
  # so it will be exempt from any impending string searches.
  def pollute(delimiter = "^--^--^")
    self.split('').map{|letter| "#{letter}#{delimiter}" }.join
  end

  # Meant to be paired with the pollute method, this removes 'pollution' from the string
  def sanitize(delimiter = "^--^--^")
    self.gsub(delimiter, "")
  end

  # Removes the middle from long strings, replacing with a placeholder
  def ellipsize(options={})
     max = options[:max] || 40
     delimiter = options[:delimiter] || "..."
     return self if self.size <= max
     offset = max/2
     self[0,offset] + delimiter + self[-offset,offset]
  end
  
  # Generates a permalink-style string, with odd characters removed, etc.
  def permalinkify
    result = self.to_s
    result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    result.gsub!(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
    result.gsub!(/[ \-]+/i,      '-') # No more than one of the separator in a row.
    result.gsub!(/^\-|\-$/i,      '') # Remove leading/trailing separator.
    result.downcase
  end
  
  # Removes HTML tags from a string
  def strip_tags
    self.gsub(/<\/?[^>]*>/, "")
  end

  # Removes first instance of string
  def nix(string)
    self.sub(string, "")
  end

  # Removes all instances of string
  def gnix(string)
    self.gsub(string, "")
  end

  # Prepends 'http://' to the beginning of non-empty strings that don't already have it.
  def add_http
    return "" if self.blank?
    return "http://#{self}" unless self.starts_with?("http")
    self
  end
  
  # Removes presentationally superflous http and/or www text from the beginning of the string
  def remove_http_and_www
    return "" if self.blank?
    return self.split(".").remove_first_element.join(".") if self.starts_with?("www.")
    self.gsub("http://www.", "").gsub("http://", "").gsub("https://www.", "").gsub("https://", "")
  end
  
  # Shortens a string, preserving the last word. Truncation can be limited by words or characters
  def truncate_preserving_words(options={})
    end_string = options[:end_string] || "..."
    max_words = options[:max_words] || nil
    if max_words
      words = self.split()
      return self if words.size < max_words
      words = words[0..(max_words-1)]
      words << end_string
      words.join(" ")
    else
      max_chars = options[:max_chars] || 60
      return self if self.size < max_chars
      out = self[0..(max_chars-1)].split(" ")
      out.pop
      out << end_string
      out.join(" ")
    end
  end
  
  # Extracts domain name from a URL
  def domain
    url = self.dup
    url=~(/^(?:\w+:\/\/)?([^\/?]+)(?:\/|\?|$)/) ? $1 : url
  end
  
  # Extracts domain name (sans 'www.') from a URL string
  def domain_without_www
    self.domain.remove_http_and_www
  end
  
  # Returns true or false depending on whether a string appears to be a URL
  def valid_url?
    !self.match(/https?:\/\/([^\/]+)(.*)/).nil?
  end
  
  # Returns true or false depending on whether a string appears to be an email address
  def valid_email?
    !self.match(/^[A-Z0-9._%-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|biz|info|name|aero|biz|info|jobs|museum|name)$/i).nil?
  end
  
  # Removes tab characters and instances of more than one space
  def remove_whitespace
    self.gnix("\t").split(" ").remove_blanks.join(" ")
  end
  
  # Returns true if all letters in the string are capitalized
  def upcase?
    self.upcase == self
  end

  # Returns true if all letters in the string are lowercase
  def downcase?
    self.downcase == self
  end
  
  unless method_defined? "ends_with?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/StartsEndsWith.html#M000441
    def ends_with?(suffix)
      suffix = suffix.to_s
      self[-suffix.length, suffix.length] == suffix
    end
  end
  
  unless method_defined? "starts_with?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/StartsEndsWith.html#M000441
    def starts_with?(prefix)
      prefix = prefix.to_s
      self[0, prefix.length] == prefix
    end
  end
  
end

class Array

  def remove_blanks
    self.reject{ |e| e.blank? }
  end
  
  # Like Array.shift, but returns the array instead of removed the element.
  def remove_first_element
    self[1..self.size]
  end

  # Like Array.pop, but returns the array instead of removed the element.
  def remove_last_element
    self[0..self.size-2]
  end
  
  def get_sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end;
  
end

module Enumerable
  # http://snippets.dzone.com/posts/show/3838
  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end
end