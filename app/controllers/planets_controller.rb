class PlanetsController < ApplicationController
  before_action :find_planet, except: [:index, :show, :new, :create, :destroy_all]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @planets = Planet.all
    @most_valued = User.most_valued
    @most_valued_customer = @most_valued[:user]
    @most_populated = Planet.most_populated
    @most_moons = Planet.most_moons
    @most_expensive = Planet.most_expensive
  end

  def show
    if params[:user_id]
      @planet = Planet.find(params[:id])
    else
      @planet = Planet.find(params[:id])
    end
  end

  def new
    @planet = Planet.new
    @orders = @planet.orders.build
    @feature = @orders.build_feature
  end

  def create
    @planet = Planet.new(planet_params)
    @planet.price = rand(1000000..8000000)
    @planet.user = current_user
    if !@planet.valid? || !user_signed_in?
      flash[:alert] = "Please make sure you have entered in the correct information."
      redirect_to new_planet_path
    else
      @planet.save
      flash[:notice] = "Your new planet #{@planet.name.titleize} and features cost a total of #{@planet.price * 1000 + @planet.orders.sum(:price) * 1000} Pu. We have deducted this amount from your account. Thank you for your business."
      redirect_to planet_path(@planet)
    end
  end

  def edit
    if @planet.user == current_user
      render :edit
    else
      flash[:alert] = "You cannot edit another user's planets."
      redirect_to planets_path
    end
  end

  def update
    if @planet.user == current_user && @planet.update(planet_params)
      redirect_to planet_path(@planet)
    else
      flash[:alert] = "You cannot edit another user's planets."
      redirect_to planets_path
    end
  end

  def destroy
    @user = @planet.user
    if @planet.user == current_user
      @planet.destroy
    else
      flash[:alert] = "You cannot destroy another user's planets."
    end
    redirect_to user_path(@user)
  end

  def destroy_all
    if current_user.planets.count == 0
      flash[:alert] = "You don't have any planets to destroy."
    elsif params[:user_id].to_i == current_user.id
      current_user.planets.destroy_all
      flash[:notice] = "The universe has successfully ended. Please purchase new planets to start over."
    else
      flash[:alert] = "You must be the owner to destroy the planets."
    end
    redirect_to user_path(current_user)
  end

  private

  def planet_params
    params.require(:planet).permit(:id, :name, :price, :population, :moons, orders_attributes: [:id, :size, :feature_id, feature_attributes: [:id, :name, :description]])
  end

  def find_planet
    @planet = Planet.find(params[:id])
  end

end
