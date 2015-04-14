require File.expand_path('../../test_helper', __FILE__)

module Paid
  class EventTest < Test::Unit::TestCase
    setup do
      @event_url = "#{Paid.api_base}/events"
    end

    context 'Event class' do
      should 'be retrieveable' do
        id = "event_id"
        @mock.expects(:get).once.with("#{@event_url}/#{id}", anything, anything).returns(test_response(test_event))
        event = Paid::Event.retrieve(id)
        assert(event.is_a?(Paid::Event))
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_event_list))

        events = Paid::Event.all

        assert(events.is_a?(Paid::APIList))
        events.each do |event|
          assert(event.is_a?(Paid::Event))
        end
      end
    end

    context 'Event instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@event_url}/#{test_event[:id]}", anything, anything).returns(test_response(test_event))
        event = Paid::Event.new(test_event[:id])
        event.refresh
        assert_equal(test_event[:type], event.type)
      end
    end

    context 'Retrieved Paid::Event instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_event))
        @event = Paid::Event.retrieve('event_id')
      end

      should 'have the id attribute' do
        assert_equal(test_event[:id], @event.id)
      end

      should 'have the object attribute' do
        assert_equal(test_event[:object], @event.object)
      end

      should 'have the created_at attribute' do
        assert_equal(test_event[:created_at], @event.created_at)
      end

      should 'have the type attribute' do
        assert_equal(test_event[:type], @event.type)
      end

      should 'have & convert the data attribute' do
        event2 = Paid::Event.new(test_event(test_invoice))
        assert(event2.data.is_a?(Paid::Invoice))
      end

    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::Event))
      assert_equal(Paid::Event, APIResource.api_subclass_fetch("event"))
    end

  end
end
