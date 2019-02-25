require 'rack/test' 
require 'json'
require_relative '../../app/api.rb'


module ExpenseTracker
  RSpec.describe 'Expense Trackers API' do 
  include Rack::Test::Methods
  def app
    ExpenseTracker::API.new
  end
    it "records the submittted expenses" do
      coffee={
       "payee" => "Starbucks",
       "pay_amount" => "54",
       "pay_date" => "05-08-1996"   
      }
      post '/expenses',JSON.generate(coffee)
      puts "the last response that is obtained is  #{last_response.body}"
      expect(last_response.status).to eql(200)#this line is a must that tries t check the response that we have got back from the server so once the resposne is 200 then we can say that the record got successfully inserted then     
    end

    it "records the submitted expenses and gives back the expense id" do
      cappucino = {
        "payee"=> "Starbuck",
        "pay_amount" => 7483,
        "pay_date" => '05-08-1996'
      }
      post_expense(cappucino)
    end

    it "gets all the expenses below certain date" do
      cappucino = {
        "payee" => "Star1",
        "pay_amount" => 678.5,
        "pay_date" => '08=09-1997'
      }
      coffee = {
        "payee" => "star2",
        "pay_amount" => 8984,
        "pay_date" => "89=09-3456"  
      }
      post_expense(coffee )
      post_expense(cappucino)
      puts "it gets all the expenses"
      get_expenses('05-08-1996',coffee,cappucino)
    end

    def post_expense(coffee)
      post '/expenses',JSON.generate(coffee)
      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id'=> a_kind_of(Integer))
      coffee.merge({'id' => parsed["expense_id"]})
    end
    
    def get_expenses(date,coffee,cappucino)
      get '/expenses'
      parsed = JSON.parse(last_response.body)
      puts "the resposne obtained for getting al lthe expeneses would be #{last_response.body}"
      expect(parsed).to contain_exactly(coffee,cappucino)
    end    
  end
end