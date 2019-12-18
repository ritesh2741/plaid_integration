class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def new
    @user = User.new
  end

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/:id
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
     render json: {error: "error"}, status: 400
    end
  end

  # PUT /users/:id
  def update
    unless @user.update(user_params)
       http_error(:unprocessable_entity)
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy if @user
  end

  def connect
    client = connect_plaid
    exchange_token_response =
    if plaid_params['public_token']
      client.item.public_token.exchange(plaid_params['public_token'])
      access_token = exchange_token_response['access_token']
      render json: {access_token: access_token}, status: 200
    else
      render json: {error: "Missing Public Token"}, status: 400
    end
  end

  private

  # Move to helper file or as service object whenever other services will use it
  def connect_plaid
    client = Plaid::Client.new(env: ENV['PLAID_ENV'],
       client_id: ENV['PLAID_CLIENT_ID'],
       secret: ENV['PLAID_SECRET'],
       public_key: ENV['PLAID_PUBLIC_KEY'])

  end

  def plaid_params
    params.permit(:public_token)
  end

  def user_params
    params.permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
