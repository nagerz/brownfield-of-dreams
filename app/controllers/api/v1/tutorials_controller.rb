# frozen_string_literal: true

# Admin api v1 tutorial controller restricted to admin
class Api::V1::TutorialsController < ApplicationController
  def index
    render json: Tutorial.all
  end

  def show
    render json: Tutorial.find(params[:id])
  end
end
