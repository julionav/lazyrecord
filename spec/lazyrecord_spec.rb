require_relative '../lib/lazyrecord'

class Task < LazyRecord
  attr_accessor :text, :completed

  def initialize(text:)
    @text = text
    @completd = false
  end
end

describe LazyRecord do
  before :each do
    LazyRecord.store.flush!
  end

  describe "::create" do
    it "creates and save a record" do
      Task.create(text: "hola")
      expect(Task.all.length).to be(1)
    end
  end

  describe "::delete" do
    it "deletes a record" do
      Task.create(text: "hola")
      expect(Task.all.length).to be(1)

      Task.delete(1)
      expect(Task.all.length).to be(0)
    end
  end
end
