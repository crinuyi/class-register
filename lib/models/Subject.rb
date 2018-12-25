class Subject < Sequel::Model
    plugin :validation_helpers
    def validate
        validates_presence :name
        validates_unique :name
        validates_schema_types :name
        validates_min_length 2, :name
        validates_format /[A-ZĄĘĆŹŻŚÓŁ]-?[A-ZĄĘĆŹŻŚÓŁa-ząęćśżźół .]+/, :name
    end
end