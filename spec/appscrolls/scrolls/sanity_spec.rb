require 'spec_helper'

# This is a simple set of tests to make sure that
# all of the scrolls conform to the base requirements.

AppScrollsScrolls::Scrolls.list_classes.each do |scroll|
  describe scroll do
    it("should have a name"){ scroll.name.should be_kind_of(String) }    
    it("should have a description"){ scroll.description.should be_kind_of(String) }
    it("should have a template"){ scroll.template.should be_kind_of(String) }
    it("should be able to compile"){ scroll.new.compile.should be_kind_of(String) }
    
    it "should have a string or nil category" do
      if scroll.category
        scroll.category.should be_kind_of(String)
      end
    end

    it "should have a Config or nil config" do
      if scroll.config
        scroll.config.should be_kind_of(AppScrollsScrolls::Config)
      end
    end

    it "should be in the list" do
      AppScrollsScrolls::Scrolls.list_classes.should be_include(scroll)
      AppScrollsScrolls::Scrolls.list.should be_include(scroll.key)
    end
  end
end
