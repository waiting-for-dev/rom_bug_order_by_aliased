require "bundler/setup"
require "rom"
require "pry-byebug"

module Types
  include Dry::Types.module
end

rom = ROM.container(:sql, 'sqlite::memory') do |conf|
  conf.default.create_table(:users) do
    primary_key :id

    column :username, String, null: false
  end

  conf.relation(:users) do
    schema(infer: true) do
      attribute :username, Types::String.meta(alias: :name)
    end
  end
end

users = rom.relations[:users]

puts "===> users.order(users[:username])"
order = users.order(users[:username])
puts order.dataset.sql
begin
  order.to_a
rescue => e
  puts e.inspect
end

puts '----------------------------------------------------------------'

puts "===> users.order(users[:username].as(:name))"
begin
  order = users.order(users[:username].as(:name))
rescue => e
  puts e.inspect
end