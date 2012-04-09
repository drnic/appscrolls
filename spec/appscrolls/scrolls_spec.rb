require 'spec_helper'

describe AppScrollsScrolls::Scrolls do
  subject{ AppScrollsScrolls::Scrolls }
  let(:scroll){ AppScrollsScrolls::Scroll.generate("scroll_test", "# Testing", :name => "Test Scroll", :category => "test", :description => "Just a test.")}

  before(:all) do
    AppScrollsScrolls::Scrolls.add(scroll)
  end

  it '.list_classes should include scroll classes' do
    subject.list_classes.should be_include(scroll)
  end

  it '.list should include scroll keys' do
    subject.list.should be_include('scroll_test')
  end

  describe '.for' do
    it 'should find for a given category' do
      AppScrollsScrolls::Scrolls.for('test').should be_include('scroll_test')
    end
  end
end
