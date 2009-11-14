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
  
  it "should make localized" do
    p = Page.create(:title => "Simple page")
    p.make_localized(:title)
    # p.title_ru.should == "Simple page"
    # p.title_en.should == "Simple page"
  end

  it "should not care about localized fields creation order" do
    p = Page.new
    p.title_en = 'title en'
    p.title_ru = 'title ru'
    p.title_en.should == 'title en'
    p.title_ru.should == 'title ru'

    p = Page.new
    p.title_ru = 'title ru'
    p.title_en = 'title en'
    p.title_ru.should == 'title ru'
    p.title_en.should == 'title en'
  end

  it "should work if localized field is empty" do
    p = Page.new
    p.title.should be_nil
    p.title_ru.should be_nil
  end

end
