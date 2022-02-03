require 'digest/md5'

module RedisPersistable
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

    def redis_find_by(attr)
      define_singleton_method "find_by_#{attr.to_s}" do |value|
        md5 = Digest::MD5.hexdigest value
        hash = ActiveSupport::HashWithIndifferentAccess.new
        attribute_names.each do |attribute|
          redis_key = "#{name.demodulize.underscore}:#{md5}:#{attribute}"
          hash[attribute] = redis.get redis_key
        end
        hash
      end

      define_singleton_method "primary_key" do
        attr
      end
    end
  end

  def persisted?
    !!self.id
  end

  def temporal_attributes
    h = {}
    attributes.keys.each do |k|
      h[k] = send("temporal_#{k}")
    end
    h
  end

  def save!
    return false unless valid?

    self.id = Digest::MD5.hexdigest temporal_attributes[self.class.primary_key.to_s]
    attributes.keys.each do |symb|
      self.send("#{symb.to_s}=", self.send("temporal_#{symb.to_s}"))
    end
    true
  end
end
