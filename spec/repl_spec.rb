require 'spec_helper'

describe Rubbish::REPL do
  it "can be configured with hooks" do
    rbsh = Rubbish::REPL.new({foo_hook: -> { 'hello' }})
    rv = rbsh.hook(:foo_hook)
    expect(rv).to eq('hello')
  end

  it "can allow the hooks to call through to the passed block" do
    rbsh = Rubbish::REPL.new({foo_hook: -> (&b) { b.call('hello') }})
    rv = rbsh.hook(:foo_hook) { |v| v }
    expect(rv).to eq('hello')
  end

  it "will call through to the passed block if the hook is nil" do
    rbsh = Rubbish::REPL.new({})
    rv = rbsh.hook(:foo_hook, 'hello') { |v| v }
    expect(rv).to eq('hello')
  end

  it "will call through to the passed block if the hook is not callable" do
    rbsh = Rubbish::REPL.new({foo_hook: 17})
    rv = rbsh.hook(:foo_hook, 'hello') { |v| v }
    expect(rv).to eq('hello')
  end
end
