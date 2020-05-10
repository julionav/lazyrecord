require_relative '../lib/lazyrecord'

class Task < LazyRecord
  attr_accessor :text, :completed

  def initialize(text:)
    @text = text
    @completed = false
  end
end

class StickyNote < LazyRecord
  attr_accessor :notes, :group

  def initialize(notes:, group: "general")
    @notes = notes
    @group = group
  end
end

describe LazyRecord do
  describe "::create" do
    it "creates and save a task record" do
      current_count = Task.all.length
      Task.create(text: "hola")
      expect(Task.all.length).to be(current_count + 1)
    end

    it "creates and save a sticky record" do
      current_count = StickyNote.all.length
      StickyNote.create(notes: "hola")
      expect(StickyNote.all.length).to be(current_count + 1)
    end
  end

  describe "::delete" do
    it "deletes a task record" do
      current_count = Task.all.length

      Task.create(text: "hola")
      expect(Task.all.length).to be(current_count + 1)

      Task.delete(current_count)
      expect(Task.all.length).to be(current_count)
    end

    it "deletes a sticky record" do
      current_count = StickyNote.all.length

      StickyNote.create(notes: "hola")
      expect(StickyNote.all.length).to be(current_count + 1)

      StickyNote.delete(current_count)
      expect(StickyNote.all.length).to be(current_count)
    end
  end
end