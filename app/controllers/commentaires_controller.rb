class CommentairesController < ApplicationController
  def new
    @commentaire = Commentaire.new(date: Date.parse(params[:date]))
    render :edit
  end

  def edit
    @commentaire = Commentaire.find(params[:id])
  end

  def create
    if params[:commentaire][:text].present?
      Commentaire.create!(date: Date.parse(params[:date]), text: params[:commentaire][:text])
    end
    redirect_to root_path
  end

  def update
    commentaire = Commentaire.find(params[:id])
    if params[:commentaire][:text].present?
      commentaire.update(text: params[:commentaire][:text])
    end
    redirect_to root_path
  end
end
