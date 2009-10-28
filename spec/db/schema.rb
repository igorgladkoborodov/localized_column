ActiveRecord::Schema.define(:version => 0) do
  create_table :pages, :force => true do |t|
    t.text :title
    t.text :content
  end
  
  create_table :xmen, :force => true do |t|
  end
end