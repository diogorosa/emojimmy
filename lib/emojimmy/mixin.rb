module Emojimmy
  module Mixin
    def self.inject_methods(model, attributes)
      model.class_eval do
        before_save do
          attributes.each do |attribute|
            unless respond_to?("#{attribute}=")
              raise ArgumentError.new(
                "#{model} must respond to #{attribute}= in order for Emojimmy to store emoji characters in it."
              )
            end

            self[attribute] = Emojimmy.emoji_to_token(self[attribute])
            true
          end
        end

        attributes.each do |attribute|
          define_method attribute do
            Emojimmy.token_to_emoji(super())
          end
        end
      end
    end
  end
end
