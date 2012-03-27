require 'spec_helper'

describe RailsWizard::Scrolls do
  subject{ RailsWizard::Scrolls }
  let(:scroll){ RailsWizard::Scroll.generate("scroll_test", "# Testing", :name => "Test Scroll", :category => "test", :description => "Just a test.")}

  before(:all) do
    RailsWizard::Scrolls.add(scroll)
  end

  it '.list_classes should include scroll classes' do
    subject.list_classes.should be_include(scroll)
  end

  it '.list should include scroll keys' do
    subject.list.should be_include('scroll_test')
  end

  describe '.for' do
    it 'should find for a given category' do
      RailsWizard::Scrolls.for('test').should be_include('scroll_test')
    end
  end
end
