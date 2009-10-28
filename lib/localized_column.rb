module LocalizedColumn
  module ClassMethods
    # Walk on columns in parameters, add localization to each column with all available locales.
    def localized_column(*columns)
      include LocalizedColumn::InstanceMethods
    
      columns.each do |column|
        serialize column
        
        define_method column do
          locales_hash(column)[current_locale] if locales_hash(column)
        end
      
        I18n.available_locales.each { |lang| add_localization(column, lang) }
      end
    end
  
    # This defines attr_accessor (title_en=, title_en)
    def add_localization(column, language)
      define_method "#{column}_#{language}=" do |text|
        set_column(column, language, text)
      end
    
      define_method "#{column}_#{language}" do
        get_column(column, language)
      end
    end
  end
  
  module InstanceMethods
    # Returns value for name and locale
    def set_blank_hash(column)
      eval("self.#{column} = {}") unless send(column)
    end
    
    # Returns hash of localized strings
    def locales_hash(column)
      attributes[column.to_s]
    end
    
    # Return value for current locale
    def get_column(name, locale)
      set_blank_hash(name)
      locales_hash(name)[locale]
    end
    
    # Sets value for name in locale
    def set_column(name, locale, value)
      set_blank_hash(name)
      locales_hash(name)[locale] = value
    end
    
    # First get current locale, second - default locale, third - first available locale
    def current_locale
      I18n.locale.to_sym || I18n.default_locale.to_sym || I18n.available_locales.first.to_sym
    end
  end
end

