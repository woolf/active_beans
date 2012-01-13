module ActiveBeans
  def self.to_bean obj
    [obj.class.to_s, Marshal.dump(obj)].to_json
  end

  def self.from_bean o
    bean = JSON.parse(o)
    # bean[0] contains Class
    Marshal.load(bean[1])
  end
end

# class Module
#   def self.from_bean o
#     Kernel.const_get(o)
#   end
# end

# class NilClass
#   def self.from_bean o
#     nil
#   end
# end

# class TrueClass
#   def self.from_bean o
#     true
#   end
# end

# class FalseClass
#   def self.from_bean o
#     false
#   end
# end

# class Numeric
#   def self.from_bean o
#     case self.to_s
#     when "Numeric"
#     when "Fixnum"
#       o.to_i
#     when "Float"
#       o.to_f
#     when "Bignum"
#       o.to_i
#     else
#       raise StandardError, "Unknown Numeric class #{self.inspect}"
#     end
#   end
# end

# class Symbol
#   def to_bean
#     [self.class, to_s].to_json
#   end

#   def self.from_bean str
#     str.to_sym
#   end
# end

# class Object
#   def to_bean
#     [self.class, to_s].to_json
#   end

#   def from_bean o
#     puts "Object.from_bean"
#     puts o
#     bean = JSON.parse(o)
#     puts bean.inspect
#     puts Kernel.const_get(bean[0]).to_s + ".from_bean " + bean[1].to_s
#     #puts bean[1]
#     Kernel.const_get(bean[0]).from_bean(bean[1])
#   end

# end

# class String
#   def self.from_bean str
#     str
#   end
# end

# class Class
#   def self.from_bean str
#     Kernel.const_get(str)
#   end
# end

# class Array
#   def to_bean
#     "[\"#{self.class}\",[" << map(&:to_bean).join(',') << ']]'
#   end

#   def self.from_bean obj
#     obj.map {|bean| Kernel.const_get(bean[0]).from_bean(bean[1]) }
#   end
# end

# class Hash
#   def to_bean
#     "[\"#{self.class}\",{" << map{|k,v| k.to_bean + '=>' + v.to_bean}.join(',') << '}]'
#   end
  
#   def self.from_bean obj
#     puts "Hash.from_bean"
#     p obj
#     p obj.class
#   end
# end

# class Range
#   def to_bean
#     "(#{first.to_bean}#{exclude_end? ? '...' : '..'}#{last.to_bean})"
#   end
# end

# class Time
#   def rrepr() "Time.parse('#{self.inspect}')" end
# end

# class Date
#   def rrepr() "Date.parse('#{self.inspect}')" end
# end
