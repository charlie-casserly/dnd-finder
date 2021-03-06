class GamesController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @game = Game.create(game_params)
    @message = Message.create(message_params)
    @message.save!
    redirect_to group_path(@group)
  end

  def update
    game = Game.find(params[:id])
    game.update_column(:complete, true)
    players = GameRespond.where(game_id: game.id)
    players.each do |player| 
      player.user.rating += 13
      player.user.save!
    end
    redirect_to group_path(params[:group_id])
  end

  private 

  def game_params
    params.permit(:date, :time, :name, :location, :group_id)
  end

  def message_params
    params.permit(:group_id).merge(game_id: @game.id, user_id: current_user.id)
  end
end
