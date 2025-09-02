class SplashController < ApplicationController
  def index
    # Splash screen with welcome message and current date/time
    @current_time = Time.current
  end
end
