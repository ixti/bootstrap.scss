# Copyright (c) 2007 - 2010 blueprintcss.org
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
#     copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
#     The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.


class String
  # see if string has any content
  def blank?; self.length.zero?; end

  # strip space after :, remove newlines, replace multiple spaces with only one space, remove comments
  def strip_space
    gsub(/:\s*/, ":").gsub(/\n/, "").gsub(/\s+/, " ").gsub(/(\/\*).*?(\*\/)/, "")
  end

  # remove newlines, insert space after comma, replace two spaces with one space after comma
  def strip_selector_space
    gsub(/\n/, "").gsub(",", ", ").gsub(", ", ", ")
  end

  # remove leading whitespace, remove end whitespace
  def strip_side_space
    gsub(/^\s+/, "").gsub(/\s+$/, $/)
  end
end


class NilClass
  def blank?
    true
  end
end


module Blueprint
  # Strips out most whitespace and can return a hash or string of parsed data
  class CSSParser
    attr_accessor :namespace
    attr_reader   :css_output, :raw_data

    # ==== Options
    # * <tt>css_string</tt> String of CSS data
    # * <tt>options</tt>
    #   * <tt>:namespace</tt> -- Namespace to use when generating output
    def initialize(css_string = "", options = {})
      @raw_data     = css_string
      @namespace    = options[:namespace] || ""
      compress(@raw_data)
    end

    # returns string of CSS which can be saved to a file or otherwise
    def to_s
      @css_output
    end

    # returns a hash of all CSS data passed
    #
    # ==== Options
    # * <tt>data</tt> -- CSS string; defaults to string passed into the constructor
    def parse(data = nil)
      data ||= @raw_data

      # wrapper array holding hashes of css tags/rules
      css_out = []
      # clear initial spaces
      data = data.strip_side_space.strip_space

      # split on end of assignments
      data.split('}').each_with_index do |assignments, index|
        # split again to separate tags from rules
        tags, styles = assignments.split('{').map{|a| a.strip_side_space }
        unless styles.blank?
          # clean up tags and apply namespaces as needed
          tags = tags.strip_selector_space
          tags.gsub!(/\./, ".#{namespace}") unless namespace.blank?

          # split on semicolon to iterate through each rule
          rules = []
          styles.split(";").each do |key_val_pair|
            unless key_val_pair.nil?
              # split by property/val and append to rules array with correct declaration
              property, value = key_val_pair.split(":", 2).map {|kv| kv.strip_side_space }
              break unless property && value
              rules << "#{property}:#{value};"
            end
          end
          # now keeps track of index as hashes don't keep track of position
          # (which will be fixed in Ruby 1.9)
          unless tags.blank? || rules.to_s.blank?
            css_out << {:tags => tags, :rules => rules.join, :idx => index}
          end
        end
      end
      css_out
    end

    private

    def compress(data)
      @css_output = ""
      parse(data).flatten.sort_by {|i| i[:idx]}.each do |line|
        @css_output += "#{line[:tags]} {#{line[:rules]}}\n"
      end
    end
  end
end
