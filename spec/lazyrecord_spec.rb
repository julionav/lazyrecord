require_relative '../lib/lazyrecord'

class Task < LazyRecord
  attr_accessor :text, :completed

  def initialize(text:)
    @text = text
    @completed = false
  end
end

class Post < LazyRecord
  attr_accessor :text

  def initialize(text)
    @text = text
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

    context "with multiple models" do
      it "creates and save records" do
        Task.create(text: "HOLA!")
        Post.create("WORKS?")
        expect(Task.all.length).to be(1)
        expect(Post.all.length).to be(1)
      end
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
