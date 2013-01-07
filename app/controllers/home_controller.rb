class HomeController < ApplicationController

  def index
    @subscriber = Subscriber.new
  end
  
  def subscribe
    @subscriber = Subscriber.new(params[:subscriber])
    if @subscriber.save
      flash[:notice] = "Thanks for subscribing"
    else
      flash[:alert] = @subscriber.errors.messages.collect {|k,v| "#{k} #{v.first}"}.join("\n")
    end
    redirect_to root_path
  end
end
