require File.dirname(__FILE__) + '/spec_helper'
 
class Page < ActiveRecord::Base
  localized_column :title, :content
end

describe LocalizedColumn do
  it "should store title for locale" do
    p = Page.create!
    p.update_attributes(:title_en => "Title EN")
    Page.first.title_en.should == "Title EN"
  end
  
  it "should return default title using default locale" do
    I18n.locale = :en
    p = Page.create!
    p.update_attributes(:title_en => "Title EN")
    Page.first.title.should == "Title EN"
  end
  
  it "should return title using current locale" do
    I18n.locale = :ru
    p = Page.create!
    p.update_attributes(:title_en => "Title EN", :title_ru => "Title RU")
    Page.first.title.should == "Title RU"
  end
end