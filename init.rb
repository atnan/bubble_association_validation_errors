# http://pivots.pivotallabs.com/users/nick/blog/articles/359-alias-method-chain-validates-associated-informative-error-message
# http://pastie.caboo.se/142774

module ActiveRecord::Validations::ClassMethods
  def validates_associated(*associations)
    options = associations.extract_options!.symbolize_keys
    associations.each do |association|
      class_eval do
        validates_each(associations, options) do |record, associate_name, value|
          associates = record.send(associate_name)
          associates = [associates] unless associates.respond_to?('each')
          associates.each do |associate|
            if associate && !associate.valid?
              associate.errors.each do |key, value|
                record.errors.add(key, value)
              end
            end
          end
        end
      end
    end
  end
end
