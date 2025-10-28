class ProfilesController < ApplicationController
before_action :authenticate_user!
  before_action :set_user 

  def show
    redirect_to edit_profile_path
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to edit_profile_path, notice: "Your profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  # Strong params: Only allow the fields we want to be editable
  def profile_params
    params.require(:user).permit(:name, :address, :contact_number)
  end
end
