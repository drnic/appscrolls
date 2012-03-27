require 'spec_helper'

describe RailsWizard::Scroll do
  context "with a generated scroll" do
    subject{ RailsWizard::Scroll.generate('scroll_example', "# this is a test", :category => 'example', :name => "RailsWizard Example") }

    context 'string setter methods' do
      (RailsWizard::Scroll::ATTRIBUTES - ['config']).each do |setter|
        it "should be able to set #{setter} with an argument" do
          subject.send(setter + '=', "test")
          subject.send(setter).should == 'test'
        end

        it 'should be able to get the value from the instance' do
          subject.send(setter + '=', 'test')
          subject.new.send(setter).should == subject.send(setter)
        end
      end
    end

    describe '.attributes' do
      it 'should be accessible from the instance' do
        subject.new.attributes.should == subject.attributes
      end
    end

    describe '.generate' do
      it 'should work with a string and hash as arguments' do
        scroll = RailsWizard::Scroll.generate('some_key', '# some code', :name => "Example")
        scroll.superclass.should == RailsWizard::Scroll
      end

      it 'should work with an IO object' do
        file = StringIO.new <<-RUBY
# this is an example

__END__

category: example
name: This is an Example
description: You know it's an exmaple.
RUBY
        scroll = RailsWizard::Scroll.generate('just_a_test', file)
        scroll.template.should == '# this is an example'        
        scroll.category.should == 'example'
        scroll.name.should == 'This is an Example'
      end

      it 'should raise an exception if the file is incorrectly formatted' do
        file = StringIO.new <<-RUBY
# just ruby, no YAML
RUBY
        lambda{RailsWizard::Scroll.generate('testing',file)}.should raise_error(ArgumentError)
      end
    end

    describe '#compile' do
      it 'should say the name' do
        subject.name = "Awesome Sauce"
        subject.new.compile.should be_include("say_scroll 'Awesome Sauce'")
      end

      it 'should include the template' do
        subject.template = "This is only a test."
        subject.new.compile.should be_include(subject.template)
      end
    end
  end

  it 'should set default attributes' do
    scroll = RailsWizard::Scroll.generate('abc','# test')
    
    RailsWizard::Scroll::DEFAULT_ATTRIBUTES.each_pair do |k,v|
      scroll.send(k).should == v
    end
  end

  context 'Comparable' do
    subject{ RailsWizard::Scroll }
    it 'a < b.run_after(a)' do
      A = subject.generate('a', '#')
      B = subject.generate('b', '#', :run_after => ['a'])

      (A < B).should be_true
    end

    it 'a > b.run_before(a)' do
      A = subject.generate('a', '#')
      B = subject.generate('b', '#', :run_before => ['a'])
      
      (A > B).should be_true
    end

    after do
      Object.send :remove_const, :A if defined?(A)
      Object.send :remove_const, :B if defined?(B)
    end
  end
end

__END__

this is a test
