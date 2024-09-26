class SessionsController < ApplicationController
  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  def new
    user = User.find_by_email(params[:email])
    current_ip = request.remote_ip
 
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: user.id, ip: current_ip })
      response.headers['Authorization'] = "Bearer #{token}"
      
      user.regenerate_refresh_token
 
      render json: { token: }, status: :ok
    else
      render json: { error: 'Incorrect email or password' }, status: :unauthorized
    end
  end

  def refresh
    authorization_header = request.headers['Authorization']
    token = authorization_header.split(" ").last if authorization_header
    
    current_ip = request.remote_ip
    
    decoded_token = JsonWebToken.decode(token)

    if decoded_token[:ip] == current_ip
      user = User.find(decoded_token[:user_id])

      new_access_token = JsonWebToken.encode({ user_id: user.id, ip: current_ip })
      user.regenerate_refresh_token

      render json: { token: new_access_token }, status: :ok
    else
      UserMailer.warn_email(user).deliver_now
      render json: { error: 'Something went wrong' }, status: :unauthorized
    end
  end

  private

  def invalid_token
    render json: { message: 'Invalid token' }
  end

  def decode_error
    render json: { message: 'Decode error' }
  end
end
