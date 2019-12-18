# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '/connect' do
    it 'should return access token on connection' do
      get :connect, public_token: 'public_token'
      expect(response).to have_http_status(200)
    end

    it 'should return bad request if public token is not given' do
      get :connect
      expect(response).to have_http_status(400)
    end
  end
end
