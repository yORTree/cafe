class Cafe
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO cafe (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_cafe|
    self.name().==(another_cafe.name()).&(self.id().==(another_cafe.id()))
  end

  define_singleton_method(:all) do
    returned_cafe = DB.exec("SELECT * FROM cafe;")
    caafe = []
    returned_cafe.each() do |cafe|
      name = cafe.fetch("name")
      id = cafe.fetch("id").to_i()
      cafe.push(Cafe.new({:name => type, :id => id}))
    end
  end

  define_singleton_method(:find) do |target_id|
    @id = target_id
    entered_cafe = DB.exec("SELECT * FROM cafe WHERE id = #{target_id};")
    @name = entered_cafe.first().fetch('name')
    Cafe.new({:name => @name, :id => @id})
  end


  define_method(:food_type) do
    food_type = []
    results = DB.exec("SELECT food_type_id FROM cafe_food_type WHERE cafe_id = #{id()};")
    results.each() do |result|
      food_type_id = result.fetch("food_type_id").to_i()
      food_type = DB.exec("SELECT * FROM food_type WHERE id = #{food_type_id};")
      type = food_type.first().fetch("food_type")
      food_type.push(Food.new({:type => type, :id => food_type_id}))
    end
    food_type
  end
end
