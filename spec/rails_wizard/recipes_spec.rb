require 'spec_helper'

describe RailsWizard::Recipes do
  subject{ RailsWizard::Recipes }
  let(:scroll){ RailsWizard::Recipe.generate("scroll_test", "# Testing", :name => "Test Recipe", :category => "test", :description => "Just a test.")}

  before(:all) do
    RailsWizard::Recipes.add(scroll)
  end

  it '.list_classes should include scroll classes' do
    subject.list_classes.should be_include(scroll)
  end

  it '.list should include scroll keys' do
    subject.list.should be_include('scroll_test')
  end

  describe '.for' do
    it 'should find for a given category' do
      RailsWizard::Recipes.for('test').should be_include('scroll_test')
    end
  end
end
