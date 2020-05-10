require "pstore"

class Store
  def initialize(name)
    @name = name
    @data = PStore.new("#{@name}.pstore")
    transaction do
      @entities = @data.roots.reject { |entity| entity.include? "current_id" }
    end
  end

  def create_entity(name)
    transaction do
      if @data[name].nil?
        @data[name] = {}
        @data[current_id_key(name)] = 0
      end
    end

    unless @entities.include? name
      @entities << name
    end
  end

  def find(entity_name, id)
    transaction do
      @data[entity_name][id]
    end
  end

  def current_id_key(entity_name)
    "#{entity_name}_current_id"
  end

  def next_id(entity_name)
    transaction do
      @data[current_id_key(entity_name)] += 1
    end
  end

  def all(entity_name)
    transaction do
      @data[entity_name]
    end
  end

  def transaction
    @data.transaction do
      yield
    end
  end

  def save(entity_name, record)
    transaction do
      @data[entity_name][record.id] = record
    end
  end

  def delete(entity_name, id)
    transaction do
      p @data[entity_name]
    end

    transaction do
      @data[entity_name].delete(id)
    end

    transaction do
      p @data[entity_name]
    end
  end

  def flush!
    @entities.each do |entity|
      transaction do
        @data.delete(entity)
        @data.delete(current_id_key(entity))
      end
      create_entity(entity)
    end
  end
end

class LazyRecord
  STORE_NAME = "lazyrecord"

  attr_accessor :id

  class << self
    def register(*classes)
      classes.each { |class_obj| store.create_entity(class_obj.name.downcase) }
    end

    def entity_name
      name.downcase
    end

    def next_id
      store.next_id(entity_name)
    end

    def all
      store.all(entity_name).values
    end

    def find(id = nil, &block)
      if block_given?
        all.find(&block)
      elsif id
        store.find(entity_name, id)
      else
        raise ArgumentError.new("find requires and id or a block to be provided")
      end
    end

    def store
      @@store ||= Store.new(STORE_NAME)
    end

    def save(record)
      store.save(entity_name, record)
    end

    def delete(id)
      store.delete(entity_name, id)
    end

    def create(*args)
      record = new(*args)
      record.save
      record
    end
  end

  def save
    @id ||= self.class.next_id
    self.class.save(self)
  end
end
