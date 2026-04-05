class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user  = order.user
    @items = order.order_items

    mail(
      to:      @user.email,
      subject: "Order Confirmed — #{@order.order_number} | Avi Lace Studio"
    )
  end
end
