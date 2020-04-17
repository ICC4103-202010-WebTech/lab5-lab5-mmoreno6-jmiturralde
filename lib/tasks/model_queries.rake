namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.

    customer_id = 2
    puts("Query 1: show the total number of tickets bought by costumer id: " + customer_id.to_s)
    result =  Customer.joins(:tickets).where("customer_id = ?", customer_id).count
    puts(result)
    puts("EQQ")

    customer_id = 8
    puts("Query 3: show names of attended events by costumer id: " + customer_id.to_s)
    result =  Event.joins(ticket_types: [{tickets: [{order: :customer}]}]).where("customer_id =?", customer_id).select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EQQ")

    event_id = 1
    puts("Query 4: show the total number of tickets sold by event id: " + event_id.to_s)
    result = TicketType.joins(:tickets, :event).where("event_id = ?", event_id).count
    puts(result)
    puts("EQQ")

    event_id = 1
    puts("Query 5: show the total sales for an event by event id: " + event_id.to_s)
    result = TicketType.joins(:tickets, :event).where("event_id = ?", event_id).sum("ticket_price")
    puts(result)
    puts("EQQ")

    gender = "f"
    puts("Query 6: show event most attended by: " + gender)
    result = Event.joins(ticket_types: [{tickets: [{order: :customer}]}]).where("gender = ?",gender).group("id").limit(1).select(:name).map { |x| x.name }
    puts(result)
    puts("EQQ")
  end
end