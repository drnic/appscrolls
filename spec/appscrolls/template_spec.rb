require 'spec_helper'

describe AppScrolls::Template do
  subject{ AppScrolls::Template }
  let(:scroll){ AppScrolls::Scroll.generate('name','# test') }

  describe '#initialize' do
    it 'should work with classes' do
      subject.new([scroll]).scrolls.should == [scroll]
    end
  end

  describe '#scrolls_with_dependencies' do
    def s(*deps)
      mock(:Class, :requires => deps, :superclass => AppScrolls::Scroll)
    end

    def scroll(name)
      AppScrolls::Scrolls[name]
    end
    
    def scrolls(names)
      names.split.map(&method(:scroll))
    end

    subject do
      @template = AppScrolls::Template.new([]) 
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
      template = AppScrolls::Template.new([scroll('eycloud')])
      template.resolve_scrolls.should == [scroll('eycloud_recipes_on_deploy'), scroll('git'), scroll('github'), scroll('eycloud')]
    end
    
    it 'should correctly sort long dependencies' do
      template = AppScrolls::Template.new(scrolls('active_admin postgresql simple_form compass_twitter_bootstrap delayed_job guard rails_basics git thin haml exception_notification devise_haml omniauth tweaks rvm mailgun heroku'))
      ordered = template.resolve_scrolls
      ordered.each_with_index do |scroll, index|
        scroll.run_after.each do |scroll_name|
          earlier_scroll_index = ordered.index(scroll(scroll_name))
          earlier_scroll_index.should be < index if earlier_scroll_index
        end
        scroll.run_before.each do |scroll_name|
          later_scroll_index = ordered.index(scroll(scroll_name))
          later_scroll_index.should be > index if later_scroll_index
        end
      end
    end
  end
end
