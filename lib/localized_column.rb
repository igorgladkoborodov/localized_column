module LocalizedColumn
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def localized_column(*columns)
      columns.each do |column|

        serialize column

        define_method column do |*args|
          super *args
        end
        define_method "#{column}=" do |*args|
          super *args
        end

        define_method "new_#{column}" do |*args| #todo: default_locale
          locale = args.first ? args.first.to_sym : I18n.locale.to_sym
          if send("old_#{column}")
            if send("old_#{column}")[locale].present?
              send("old_#{column}")[locale]
            elsif send("old_#{column}")[I18n.default_locale].present?
              send("old_#{column}")[I18n.default_locale]
            end
          end
        end
        alias_method "old_#{column}", column
        alias_method column, "new_#{column}"

        define_method "new_#{column}=" do |val|
          send "#{column}_#{I18n.locale}=", val
        end
        alias_method "old_#{column}=", "#{column}="
        alias_method "#{column}=", "new_#{column}="


        I18n.available_locales.each do |lang|
          define_method :"#{column}_#{lang}" do
            self.send column, lang
          end
          define_method :"#{column}_#{lang}=" do |val|
            self.send "old_#{column}=", (self.send("old_#{column}") || {}).merge({lang => val})
          end
        end
      end
    end
  end
end

