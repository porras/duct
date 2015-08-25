require 'spec_helper'
require 'duct/cli'

describe Duct::Cli do
  subject { Duct::Cli.new(argv) }

  context 'just filename' do
    let(:argv) { ['myscript.rb'] }

    its(:filename) { should == 'myscript.rb' }
    its(:command)  { should be_nil }
    its(:params)   { should be_empty }
    its(:error?)   { should be_false }
  end

  context 'filename with space' do
    let(:argv) { ['myscript space.rb'] }

    its(:filename) { should == 'myscript space.rb' }
    its(:command)  { should be_nil }
    its(:params)   { should be_empty }
    its(:error?)   { should be_false }
  end

  context 'filename and params' do
    let(:argv) { ['myscript.rb', 'param1', 'param2'] }

    its(:filename) { should == 'myscript.rb' }
    its(:command)  { should be_nil }
    its(:params)   { should == ['param1', 'param2'] }
    its(:error?)   { should be_false }
    its('runner.script_command') { should match(%r{.+ruby 'myscript.rb' param1 param2.+}) }
  end

  context 'filename with space and params' do
    let(:argv) { ['myscript space.rb', 'param1', 'param2'] }

    its(:filename) { should == 'myscript space.rb' }
    its(:command)  { should be_nil }
    its(:params)   { should == ['param1', 'param2'] }
    its(:error?)   { should be_false }
    its('runner.script_command') { should match(%r{.+ruby 'myscript space.rb' param1 param2.+}) }
  end

  context 'command and filename' do
    let(:argv) { ['update', 'myscript.rb'] }

    its(:filename) { should == 'myscript.rb' }
    its(:command)  { should == 'update' }
    its(:params)   { should be_empty }
    its(:error?)   { should be_false }

    context 'with params for the command' do
      let(:argv) { ['update', 'sinatra', 'myscript.rb'] }

      its(:filename) { should == 'myscript.rb' }
      its(:command)  { should == 'update sinatra' }
      its(:params)   { should be_empty }
      its(:error?)   { should be_false }
    end
  end

  context 'errors' do
    context 'nothing' do
      let(:argv) { [] }

      its(:error?) { should be_true }
    end
  end
end
