require 'digest/md5'

module RedisObjects
  extend ActiveSupport::Concern

  included do
    include ActiveModel::AttributeMethods
    include Redis::Objects
    attribute_method_prefix 'temporal_'
    attribute_names.each do |attr|
      attr_accessor "temporal_#{attr}"
      value attr.to_sym
    end
    attr_accessor :id
  end

  class_methods do
    def attribute_expireat(attr, fn)
      value attr, expireat: fn
    end
  end

  def initialize(attrs = {})
    super()
  end

  def persisted?
    !!self.id
  end

  def save
    return false unless valid?

    self.id = Digest::MD5.hexdigest Marshal.dump(attributes)
    attributes.keys.each do |symb|
      self.send("#{symb.to_s}=", self.send("temporal_#{symb.to_s}"))
    end
    true
  end
end
