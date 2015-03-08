Paid.api_key = "sk_test_ma6AiJSf4HitoUwI6cXhaQ"

account = Paid::Account.retrieve

customer = Paid::Customer.by_alias("holyalias")

new_customer = Paid::Customer.create(
  :name => "Paid",
  :email => "hello@paidapi.com",
  :description => "Obviously this is just a description.",
  :phone => "4155069330",
  :address_line1 => "2261 Market Street",
  :address_line2 => "#567",
  :address_city => "San Francisco",
  :address_state => "CA",
  :address_zip => "94114"
)

customer = Paid::Customer.retrieve(new_customer.id)
customer.name = "Updated Name!!!"
customer.description = "updated desc"
customer.email = "joncalhoun@gmail.com"
customer.save

customers = Paid::Customer.all

invoices = customers.first.invoices
transactions = customers.first.transactions

Paid.api_key = "sk_test_ma6AiJSf4HitoUwI6cXhaQ"
events = Paid::Event.all
event = Paid::Event.retrieve(events.first.id)


invoices = Paid::Invoice.all
invoice = Paid::Invoice.retrieve(invoices.first.id)
invoice.issue
invoice.mark_as_paid

gen_invoice = customers.first.generate_invoice


transaction = Paid::Transaction.create(
  :amount => "100",
  :description => "Designing awesome holiday cards.",
  :properties => {
    :promotion => "holiday_cards",
    :discount => "bulk_100"
  },
  customer: customers.first.id
)

transactions = Paid::Transaction.all
trans = Paid::Transaction.retrieve(transactions.last.id)
trans.description = "more awesome cards.. updated desc"
trans.amount = "1000"
trans.save

transaction.mark_as_paid
