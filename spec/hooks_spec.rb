$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rubbish/hooks'

describe Rubbish::Hooks do
  before :each do
    @hooks = Class.new do
      include Rubbish::Hooks
    end.new
  end

  it "has a method to retrieve the hook mapping" do
    hooks = @hooks.hooks
    expect(@hooks.hooks).to equal(hooks)
  end

  it "registers a hook by responding to the 'on' method" do
    bloc = proc { }
    @hooks.on :some_event, &bloc
    some_event_hooks = @hooks.hooks[:some_event]
    expect(some_event_hooks).to eq([bloc])
  end

  it "removes registered hooks by responding to the 'off' method" do
    @hooks.hooks[:some_event].push(&proc { })
    @hooks.off :some_event
    expect(@hooks.hooks[:some_event].empty?).to be(true)
  end

  describe "Rubbish::Hooks#trigger" do
    it "is a no-op if there are no procs associated with a given event" do
      @hooks.hook :some_non_existent_event
    end

    it "calls hook procs associated with a given event" do
      doc = []
      @hooks.on(:some_event) { doc.push :called }
      @hooks.hook :some_event
      expect(doc.length).to equal(1)
    end

    it "does not trigger procs associated with another event" do
      doc = []
      @hooks.on(:some_event) { doc.push :called }
      @hooks.hook :some_other_event
      expect(doc.empty?).to be(true)
    end

    it "passes arguments to the associated procs" do
      doc = []
      @hooks.on(:some_event) { |args| doc.push(args) }
      expect(@hooks.hooks[:some_event].length).to equal(1)
      @hooks.hook :some_event, :args
      expect(doc).to eq([:args])
    end

    it "calls all procs associated with a given event, in the order they were assigned" do
      doc = []
      @hooks.on(:some_event) { doc.push :first }
      @hooks.on(:some_event) { doc.push :second }
      @hooks.hook :some_event
      expect(doc).to eq([:first, :second])
    end

    it "passes the same arguments to all the associated procs" do
      doc = []
      @hooks.on(:some_event) { |args| doc.push args }
      @hooks.on(:some_event) { |args| doc.push args }
      @hooks.hook :some_event, :args
      expect(doc).to eq([:args, :args])
    end

  end

  describe "Rubbish::Hooks#before" do
    it "pushes a proc onto an event stack *before* the existing events" do
      doc = []
      @hooks.on(:some_event) { doc.push :first }
      @hooks.before(:some_event) { doc.push :second }
      @hooks.hook :some_event
      expect(doc).to eq([:second, :first])
    end
  end

  describe "Rubbish::Hooks::Cancel" do
    it "can be used to cancel a chain of events" do
      doc = []
      @hooks.on(:some_event) { doc.push :first }
      @hooks.on(:some_event) { raise Rubbish::Hooks::Cancel.new }
      @hooks.on(:some_event) { doc.push :second }
      @hooks.hook :some_event
      expect(doc).to eq([:first])
    end
  end

  describe "Rubbish::Hooks::Arguments" do
    it "can be used to alter the arguments to successive procs in the chain" do
      doc = []
      @hooks.on(:some_event) { |args| doc.push args }
      @hooks.on(:some_event) { raise Rubbish::Hooks::Arguments.new(:new_args) }
      @hooks.on(:some_event) { |args| doc.push args }
      @hooks.hook :some_event, :args, :new_args
      expect(doc).to eq([:args, :new_args])
    end
  end
end