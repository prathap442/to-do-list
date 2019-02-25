require 'sinatra/base' 
require 'json'
module ExpenseTracker
  class API < Sinatra::Base
    @@expenses = []
    post '/expenses' do
      @@expenses.push({"expense_id"=> Random.rand(1..200)})
      JSON.generate("expense_id" => 42)
    end

    get '/expenses' do 
      JSON.generate(@@expenses)
    end
  end

end

