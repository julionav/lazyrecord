require "pstore"

class Store
  def initialize(name)
    @data = PStore.new("#{name}.pstore")
  end

  def create_entity(name)
    transaction do
      if @data[name].nil?
        @data[name] = {}
        @data[current_id_key(name)] = 0
      end
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
      p entity_name
      p @data[current_id_key(entity_name)]
      @data[current_id_key(entity_name)] += 1
    end
  end

  def all(entity_name)
    transaction do
      @data[entity_name]
    end
  end

  def entities
    transaction do
      @data.roots
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
end

class LazyRecord
  STORE_NAME = "lazyrecord"

  attr_accessor :id

  class << self
    def inherited(child_class)
      store.create_entity(child_class.name.downcase)
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

    def create(*args)
      record = new(*args)
      save(record)
      record
    end
  end

  def save
    @id ||= self.class.next_id
    self.class.save(self)
  end
end

class Task < LazyRecord
  attr_accessor :title

  def initialize(title)
    @title = title
  end
end
