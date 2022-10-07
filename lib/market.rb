class Market
  attr_accessor :base, :quote
  def initialize(options)
    @base = options[:base].to_sym
    @quote = options[:quote].to_sym
  end
end
