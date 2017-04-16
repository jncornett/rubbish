require 'spec_helper'
require 'rubbish/use'

describe "Rubbish#usable_modules" do
  it "returns a copy of the 'use'-able modules in the current environment" do
    original = Rubbish.usable_modules
    copy = Rubbish.usable_modules
    copy << :alteration
    expect(Rubbish.usable_modules).to eq(original)
  end
end

describe Rubbish::Usable do
  it "can be included to 'register' a module as 'usable'" do
    m = Module.new do
      include Rubbish::Usable
    end
    expect(Rubbish.usable_modules.include?(m)).to be(true)
  end
end

describe Rubbish::Use do
  describe "Rubbish::Use#use" do
  end
end