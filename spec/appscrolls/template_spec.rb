require 'spec_helper'

describe AppScrollsScrolls::Template do
  subject{ AppScrollsScrolls::Template }
  let(:scroll){ AppScrollsScrolls::Scroll.generate('name','# test') }

  describe '#initialize' do
    it 'should work with classes' do
      subject.new('name', [scroll]).scrolls.should == [scroll]
    end
  end

  describe '#scrolls_with_dependencies' do
    def s(*deps)
      mock(:Class, :requires => deps, :superclass => AppScrollsScrolls::Scroll)
    end
    
    def scroll(name)
      AppScrollsScrolls::Scrolls[name]
    end
    
    subject do
      @template = AppScrollsScrolls::Template.new('name', []) 
      @template.stub!(:scrolls).and_return(@scrolls)
      @template.stub!(:scroll_classes).and_return(@scrolls)
      @template
    end
    
    it 'should return the same number scrolls if none have dependencies' do
      @scrolls = [s, s]
      subject.scrolls_with_dependencies.size.should == 2
    end

    it 'should handle simple dependencies' do
      @scrolls = [s(s, s), s(s)]
      subject.scrolls_with_dependencies.size.should == 5
    end

    it 'should handle multi-level dependencies' do
      @scrolls = [s(s(s))]
      subject.scrolls_with_dependencies.size.should == 3
    end

    it 'should uniqify' do
      a = s
      b = s(a)
      c = s(s, a, b)
      @scrolls = [a,b,c]
      subject.scrolls_with_dependencies.size.should == 4
    end
    
    it 'should resolve and sort' do
      template = AppScrollsScrolls::Template.new('name', [scroll('eycloud')])
      template.resolve_scrolls.should == [scroll('eycloud_recipes_on_deploy'), scroll('git'), scroll('github'), scroll('eycloud')]
    end
  end
end
