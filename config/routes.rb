# frozen_string_literal: true

EIVO::Engine.routes.draw do
  scope module: 'eivo' do
    get :status, to: 'status#index'
  end
end
