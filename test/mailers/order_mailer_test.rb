require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  test "confirmation" do
    order = orders(:paid_order)
    mail = OrderMailer.confirmation(order)
    assert_equal "Order Confirmed — #{order.order_number} | Avi Lace Studio", mail.subject
    assert_equal [ order.user.email ], mail.to
    assert_not_nil mail.body
  end
end
