require 'jwt'
class ApplicationController < ActionController::API

  def issue_token(payload)
    JWT.encode(payload, ENV["SECRET_KEY"], 'HS256')
  end

  def decode_token
    begin
      JWT.decode(@token, ENV["SECRET_KEY"], true, {algorithm: 'HS256'}).first
    rescue JWT::DecodeError
      return {id: nil}
    end
  end

  def token
    request.headers["Authenticate"]
  end

  def id_from_token
    @decoded = decode_token
    if @decoded
      @decoded["id"]
    end
  end
end
