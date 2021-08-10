class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @groups = Group.all
  end

  def show
    group_id = params[:id]
    @group_user = GroupUser.find_by(group_id: group_id, user_id: current_user.id)
    @messages = Message.where(group_id: group_id)
    @requests = Invitation.where(group_id: group_id, confirmed: false)
    @users = GroupUser.where(group_id: group_id)
    @games = Game.where(group_id: group_id)
  end

  def new
    @group = Group.new
  end

  def assign_dm 
    dm = GroupUser.find_by(group_id: params[:group_id], user_id: params[:user_id])
    dm.update_column(:dm, true)
    redirect_to group_path(params[:group_id])
  end

  def edit
    group = Group.where(id: @group.id)
  end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        @user_group = GroupUser.create(group_user_params)
        format.html { redirect_to @group, notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :party_size, :information, :game_edition, :campaign_type, :image, :party_level)
    end

    def group_user_params
      params.require(:group).permit(:character_name, :character_race, :character_class).merge(group_id: @group.id, user_id: current_user.id, admin: true)
    end
end
