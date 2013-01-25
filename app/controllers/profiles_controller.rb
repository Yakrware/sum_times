class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.json

  respond_to :js, only: [:update]

  def index
    @profiles = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @current_schedule = current_user.schedules.where('start_date <= :date AND (end_date > :date OR end_date IS NULL)', :date => Date.today).first
    @future_schedules = current_user.schedules.where('start_date > :date', :date => Date.today)
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = User.new(params[:user])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = current_user
    @profile.update_attributes(params[:user])
    respond_with(@profile)
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = User.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end
end
