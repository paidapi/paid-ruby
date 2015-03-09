require 'paid'

class APITest
  def initialize(api_key)
    Paid.api_key = api_key
  end

  def run
    account = run_account_test
    customer = run_customer_tests
    plan = run_plan_tests
    subscription = run_subscription_tests(customer, plan)
    transaction = run_transaction_tests(customer)
    invoice = run_invoice_tests(customer)
    event = run_events_tests
    run_advanced_tests(transaction, invoice, subscription)
  end

  def run_advanced_tests(transaction, invoice, subscription)
    puts "Marking the transaction as paid..."
    transaction.mark_as_paid
    puts "Marked transaction=#{transaction.id} as paid."

    puts "Issuing the invoice..."
    invoice.issue
    puts "Invoice=#{invoice.id} issued."

    puts "Marking the invoice as paid..."
    invoice.mark_as_paid(:via => :ach)
    puts "Marked invoice=#{invoice.id} as paid."

    puts "Cancelling subscription=#{subscription.id}..."
    subscription.cancel
    puts "Subscription cancelled."
  end

  def run_events_tests
    puts "Looking up all events..."
    events = Paid::Event.all
    puts "Found #{events.length} events."

    puts "Retrieving the first event..."
    event = Paid::Event.retrieve(events.first.id)
    puts "Retrieved the event with the id=#{event.id}"

    event
  end

  def run_invoice_tests(customer)
    puts "Creating an invoice with customer=#{customer.id}"
    invoice = customer.generate_invoice
    puts "Created: #{invoice.inspect}"

    puts "Looking up all invoices..."
    invoices = Paid::Invoice.all
    puts "Found #{invoices.length} invoices."

    puts "Retrieving the generated invoice..."
    invoice = Paid::Invoice.retrieve(invoice.id)
    puts "Retrieved the invoice with the id=#{invoice.id}"

    puts "Retrieving the customer=#{customer.id}'s invoices..."
    invoices = customer.invoices
    puts "Retrieved: #{invoices.inspect}"

    invoice
  end

  def run_transaction_tests(customer)
    puts "Creating 2 transactions with customer=#{customer.id}"
    transaction = Paid::Transaction.create({
      :amount => 100,
      :description => 'a description',
      :customer => customer.id,
      :paid => false
    })
    transaction_b = Paid::Transaction.create({
      :amount => 1000,
      :description => 'another description',
      :customer => customer.id,
      :paid => false
    })
    puts "Created: #{transaction.inspect} + 1 other"

    puts "Looking up all transactions..."
    transactions = Paid::Transaction.all
    puts "Found #{transactions.length} transactions."

    puts "Retrieving the created transaction..."
    transaction = Paid::Transaction.retrieve(transaction.id)
    puts "Retrieved the transaction with the id=#{transaction.id}"

    puts "Updating the transaction's name..."
    transaction.description = "an updated description..."
    transaction.save
    puts "Updated the transaction with id=#{transaction.id} with the new description #{transaction.description.inspect}"

    puts "Looking up customer=#{customer.id}'s transactions..."
    transactions = customer.transactions
    puts "Retrieved: #{transactions.inspect}"

    transaction
  end

  def run_subscription_tests(customer, plan)
    puts "Creating a subscription for customer=#{customer.id} and plan=#{plan.id}..."
    subscription = Paid::Subscription.create({
      :starts_on => (Time.now + 1 * 60 * 60 * 24).strftime("%Y-%m-%d"),
      :plan => plan.id,
      :customer => customer.id
    })
    puts "Created: #{subscription.inspect}"

    puts "Looking up all subscriptions..."
    subscriptions = Paid::Subscription.all
    puts "Found #{subscriptions.length} subscriptions."

    puts "Retrieving the created subscription..."
    subscription = Paid::Subscription.retrieve(subscription.id)
    puts "Retrieved the subscription with the id=#{subscription.id}"

    subscription
  end

  def run_plan_tests
    puts "Creating a plan..."
    plan = Paid::Plan.create({
      :description => "Plan for testing stuff",
      :name => "Test Plan #{Time.now.to_i}-#{rand(2000)}",
      :interval => "month",
      :interval_count => 1,
      :amount => 5000
    })
    puts "Created: #{plan.inspect}"

    puts "Looking up all plans..."
    plans = Paid::Plan.all
    puts "Found #{plans.length} plans."

    puts "Retrieving the created plan..."
    plan = Paid::Plan.retrieve(plan.id)
    puts "Retrieved the plan with the id=#{plan.id}"

    plan
  end

  def run_customer_tests
    puts "Creating a customer..."
    customer = Paid::Customer.create({
      :name => "Paid",
      :email => "hello@paidapi.com",
      :description => "Obviously this is just a description.",
      :phone => "4155069330",
      :address_line1 => "2261 Market Street",
      :address_line2 => "#567",
      :address_city => "San Francisco",
      :address_state => "CA",
      :address_zip => "94114"
    })
    puts "Created: #{customer.inspect}"

    puts "Looking up all customers..."
    customers = Paid::Customer.all
    puts "Found #{customers.length} customers"

    puts "Retrieving the created customer..."
    customer = Paid::Customer.retrieve(customer.id)
    puts "Retrieved the customer with id=#{customer.id}"

    # TODO(joncalhoun): Add by_external_id lookup test

    puts "Updating the customer's name..."
    customer.name = "Paid Inc"
    customer.save
    puts "Updated the customer with id=#{customer.id} with the new name #{customer.name.inspect}"

    customer
  end

  def run_account_test
    puts "Looking up the account..."
    account = Paid::Account.retrieve
    puts "Retrieved the account with id=#{account.id}"
    account
  end

end
