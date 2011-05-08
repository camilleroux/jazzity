class ModesController < ApplicationController
  before_filter :find_key
  before_filter :find_scale
  before_filter :find_mode

  def index
    redirect_to scale
  end

  def show
    if @mode.main?
      redirect_to [@key, @scale].compact
    else
      render "scales/show"
    end
  end


  protected

  def find_key
    if params[:key_id]
      @key = Key.find(params[:key_id])
      @key = nil if @key.main?
    end
  end

  def find_scale
    @scale = Scale.find(params[:scale_id])
    @scale = @scale.in_key_of(@key) if @key
  end

  def find_mode
    @mode = @scale.modes.find(params[:id])
    @mode = @mode.in_key_of(@key) if @key
  end
end
